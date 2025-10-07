#!/bin/bash
# Script NAS Samba interactif pour Raspberry Pi 5
# Crée : dossier public, dossier privé, et dossiers personnels par utilisateur
# Usage : sudo ./install_nas.sh
set -e

# Définition des variables
DEVICE="/dev/sda1"
MOUNT_POINT="/mnt/nas"
LABEL="NAS_USB"
CONF_FILE="/etc/samba/smb.conf"
GROUP="smbusers"

# Vérification si root
if [ "$(id -u)" -ne 0 ]; then
    echo "⚠️ Ce script doit être exécuté avec sudo ou en root."
    exit 1
fi

echo "======================================="
echo " Installation / Maintenance NAS Samba"
echo "======================================="

# -----------------------
# 1️⃣ Formatage de la clé si nécessaire
# -----------------------
if ! blkid $DEVICE | grep -q "TYPE="; then
    echo "⚠️ La clé USB $DEVICE n'a pas de système de fichiers. Formatage en ext4..."
    mkfs.ext4 -F -L $LABEL $DEVICE
else
    echo "✅ La clé USB $DEVICE est déjà formatée."
fi

# -----------------------
# 2️⃣ Montage de la clé
# -----------------------
mkdir -p $MOUNT_POINT

UUID=$(blkid -s UUID -o value $DEVICE)
if [ -z "$UUID" ]; then
    echo "❌ Impossible de trouver l'UUID de la clé."
    exit 1
fi

if ! mount | grep -q "$MOUNT_POINT"; then
    mount -U $UUID $MOUNT_POINT
    echo "✅ Clé montée sur $MOUNT_POINT."
else
    echo "✅ La clé est déjà montée sur $MOUNT_POINT."
fi

# Ajouter à fstab si nécessaire
if ! grep -q "$UUID" /etc/fstab; then
    echo "UUID=$UUID $MOUNT_POINT ext4 defaults 0 2" >> /etc/fstab
    echo "✅ UUID ajouté à /etc/fstab."
fi

# -----------------------
# 3️⃣ Création des dossiers partagés
# -----------------------
mkdir -p $MOUNT_POINT/public
mkdir -p $MOUNT_POINT/prive
chmod 777 $MOUNT_POINT/public
chmod 770 $MOUNT_POINT/prive

# Création du groupe smbusers
groupadd -f $GROUP
chown root:$GROUP $MOUNT_POINT/prive
chown root:$GROUP $MOUNT_POINT/public

# -----------------------
# 4️⃣ Installation Samba
# -----------------------
apt update -y
apt install -y samba cifs-utils

# -----------------------
# 5️⃣ Sauvegarde config Samba
# -----------------------
if [ -f $CONF_FILE ]; then
    cp $CONF_FILE $CONF_FILE.bak.$(date +%F-%T)
fi

# -----------------------
# 6️⃣ Configuration Samba de base (corrigée)
# -----------------------
cat <<EOF > $CONF_FILE
[global]
   workgroup = WORKGROUP
   server string = Raspberry Pi NAS
   map to guest = Bad User
   dns proxy = no
   log file = /var/log/samba/log.%m
   max log size = 1000
   panic action = /usr/share/samba/panic-action %d
   server role = standalone server
   obey pam restrictions = yes

[public]
   path = $MOUNT_POINT/public
   browseable = yes
   read only = yes
   guest ok = yes
   public = yes
   force group = $GROUP
   create mask = 0664
   directory mask = 0775
   write list = @$GROUP

[prive]
   path = $MOUNT_POINT/prive
   browseable = yes
   writable = yes
   valid users = @$GROUP
   create mask = 0660
   directory mask = 0770
EOF

# -----------------------
# 7️⃣ Ajout interactif des utilisateurs et dossiers personnels
# -----------------------
read -p "Voulez-vous ajouter des utilisateurs Samba maintenant ? (o/n) " ADD_USERS
if [ "$ADD_USERS" = "o" ]; then
    while true; do
        read -p "Nom utilisateur à créer (ou 'fin' pour terminer) : " USER
        [ "$USER" = "fin" ] && break
        
        # Création utilisateur système si inexistant
        if ! id "$USER" &>/dev/null; then
            useradd -M -s /sbin/nologin "$USER"
            echo "✅ Utilisateur système $USER créé."
        else
            echo "ℹ️ L'utilisateur $USER existe déjà."
        fi
        
        # Définir le mot de passe Samba (interactif)
        smbpasswd -a "$USER"
        smbpasswd -e "$USER"
        
        # Ajouter au groupe smbusers
        usermod -aG $GROUP "$USER"

        # Création du dossier personnel
        USER_DIR="$MOUNT_POINT/$USER"
        mkdir -p "$USER_DIR"
        chown "$USER":$GROUP "$USER_DIR"
        chmod 0700 "$USER_DIR"

        # Ajouter le partage personnel dans smb.conf
        cat <<EOF >> $CONF_FILE

[$USER]
   path = $USER_DIR
   browseable = yes
   writable = yes
   valid users = $USER
   create mask = 0600
   directory mask = 0700
EOF
        echo "✅ Partage personnel pour $USER créé."
        echo "---"
    done
fi

# -----------------------
# 8️⃣ Redémarrage Samba
# -----------------------
systemctl restart smbd
systemctl enable smbd

# -----------------------
# 9️⃣ Résumé
# -----------------------
IP=$(hostname -I | awk '{print $1}')
echo "============================"
echo " ✅ NAS Samba prêt !"
echo ""
echo "📁 Structure créée :"
echo "   - $MOUNT_POINT/public  (lecture seule invités, RW pour $GROUP)"
echo "   - $MOUNT_POINT/prive   (RW groupe $GROUP)"
echo ""
echo "🌐 Accès réseau :"
echo "   smb://$IP/  (racine, montre les partages disponibles)"
echo "============================"
