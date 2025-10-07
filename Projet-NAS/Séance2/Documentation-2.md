# Documentation Technique – NAS Samba interactif (Raspberry Pi 5)


## Sommaire

1. [Présentation](#1-présentation)
2. [Matériel utilisé](#2-matériel-utilisé)
3. [Configuration réseau](#3-configuration-réseau)
4. [Services installés](#4-services-installés)

   * [NAS Samba](#nas-samba)
5. [Fichier de configuration Samba](#5-fichier-de-configuration-samba)

   * [Section globale `[global]`](#section-globale-global)
   * [Sections `[public]` et `[prive]`](#sections-public-et-prive)
6. [Script d’installation interactif `install_nas.sh`](#6-script-dinstallation-interactif-install_nassh)
7. [Arborescence des dossiers](#7-arborescence-des-dossiers)
8. [Instructions d’accès](#8-instructions-daccès)
9. [Problèmes rencontrés et solutions](#9-problèmes-rencontrés-et-solutions)

---

## 1. Présentation

**Service installé** : NAS Samba interactif

**Nom du groupe** : Groupe 1 – Binôme Noa & Axel

**Date d’installation** : 01/10/2025

**Objectif** : Fournir un NAS avec dossiers publics, privés et personnels pour chaque utilisateur, accessible via SMB sur le réseau local.

**Choix de l’installation graphique** :
Nous avons choisi la **version graphique de l’installation** pour faciliter la configuration initiale. Même si cela limite légèrement certaines options avancées, le bénéfice en termes de simplicité et de rapidité de mise en place est supérieur à ce que nous perdons en flexibilité.

---

## 2. Matériel utilisé

* Raspberry Pi modèle : 5
* Support de stockage : Clé USB (`/dev/sda1`)
* Connexion : Wi-Fi (HotSpot)
* Système : Raspberry Pi OS Desktop (installation graphique pour plus de simplicité)

---

## 3. Configuration réseau

* Adresse IP : `10.42.0.220` (DHCP)
* Masque : `255.255.255.0`
* Passerelle : `10.42.0.1`

---

## 4. Services installés

### NAS Samba

* **Partages créés** :

  * Public : `/mnt/nas/public` (lecture/écriture pour le groupe `smbusers`, lecture seule pour invités)
  * Privé : `/mnt/nas/prive` (lecture/écriture pour le groupe `smbusers`)
  * Personnels : `/mnt/nas/<nom_utilisateur>` (lecture/écriture pour l’utilisateur uniquement)

* **Groupe Samba** : `smbusers`

* **Création utilisateurs** : interactif via le script `install_nas.sh`

* **Permissions** :

  * Public : 0775 (RW pour le groupe, lecture seule pour invités)
  * Privé : 0770 (RW pour le groupe, aucun accès pour invités)


* **Configuration SMB** : `/etc/samba/smb.conf` (créé/modifié par le script avec backup automatique)

---

## 5. Fichier de configuration Samba

### Section globale `[global]`

```ini
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
```

### Sections `[public]` et `[prive]`

```ini
[public]
   path = /mnt/nas/public
   browseable = yes
   read only = yes
   guest ok = yes
   public = yes
   force group = smbusers
   create mask = 0664
   directory mask = 0775
   write list = @smbusers

[prive]
   path = /mnt/nas/prive
   browseable = yes
   writable = yes
   valid users = @smbusers
   create mask = 0660
   directory mask = 0770
```

---

## 6. Script d’installation interactif `install_nas.sh`

```bash
#!/bin/bash
# Script NAS Samba interactif pour Raspberry Pi 5
# Crée : dossier public, dossier privé, et dossiers personnels par utilisateur
# Usage : sudo ./install_nas.sh
set -e

# Variables
DEVICE="/dev/sda1"
MOUNT_POINT="/mnt/nas"
LABEL="NAS_USB"
CONF_FILE="/etc/samba/smb.conf"
GROUP="smbusers"

# Vérification root
if [ "$(id -u)" -ne 0 ]; then
    echo "⚠️ Ce script doit être exécuté avec sudo ou en root."
    exit 1
fi

echo "======================================="
echo " Installation / Maintenance NAS Samba"
echo "======================================="

# 1️⃣ Formatage clé USB
if ! blkid $DEVICE | grep -q "TYPE="; then
    echo "⚠️ Clé $DEVICE non formatée. Formatage en ext4..."
    mkfs.ext4 -F -L $LABEL $DEVICE
else
    echo "✅ Clé $DEVICE déjà formatée."
fi

# 2️⃣ Montage
mkdir -p $MOUNT_POINT
UUID=$(blkid -s UUID -o value $DEVICE)
if ! mount | grep -q "$MOUNT_POINT"; then
    mount -U $UUID $MOUNT_POINT
    echo "✅ Clé montée sur $MOUNT_POINT."
else
    echo "✅ Clé déjà montée."
fi
if ! grep -q "$UUID" /etc/fstab; then
    echo "UUID=$UUID $MOUNT_POINT ext4 defaults 0 2" >> /etc/fstab
    echo "✅ UUID ajouté à /etc/fstab."
fi

# 3️⃣ Dossiers partagés
mkdir -p $MOUNT_POINT/public $MOUNT_POINT/prive
chmod 777 $MOUNT_POINT/public
chmod 770 $MOUNT_POINT/prive
groupadd -f $GROUP
chown root:$GROUP $MOUNT_POINT/public $MOUNT_POINT/prive

# 4️⃣ Installation Samba
apt update -y
apt install -y samba cifs-utils

# 5️⃣ Backup smb.conf
[ -f $CONF_FILE ] && cp $CONF_FILE $CONF_FILE.bak.$(date +%F-%T)

# 6️⃣ Configuration Samba
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

# 7️⃣ Ajout utilisateurs
read -p "Ajouter utilisateurs Samba maintenant ? (o/n) " ADD_USERS
if [ "$ADD_USERS" = "o" ]; then
    while true; do
        read -p "Nom utilisateur (ou 'fin') : " USER
        [ "$USER" = "fin" ] && break
        if ! id "$USER" &>/dev/null; then
            useradd -M -s /sbin/nologin "$USER"
            echo "✅ Utilisateur système $USER créé."
        else
            echo "ℹ️ Utilisateur $USER existe déjà."
        fi
        smbpasswd -a "$USER"
        smbpasswd -e "$USER"
        usermod -aG $GROUP "$USER"
        USER_DIR="$MOUNT_POINT/$USER"
        mkdir -p "$USER_DIR"
        chown "$USER":$GROUP "$USER_DIR"
        chmod 0700 "$USER_DIR"
        cat <<EOF >> $CONF_FILE

[$USER]
   path = $USER_DIR
   browseable = yes
   writable = yes
   valid users = $USER
   create mask = 0600
   directory mask = 0700
EOF
        echo "✅ Partage personnel $USER créé."
    done
fi

# 8️⃣ Redémarrage Samba
systemctl restart smbd
systemctl enable smbd

# 9️⃣ Résumé
IP=$(hostname -I | awk '{print $1}')
echo "============================"
echo " ✅ NAS Samba prêt !"
echo "📁 Structure créée :"
echo "   - $MOUNT_POINT/public  (lecture seule invités, RW pour $GROUP)"
echo "   - $MOUNT_POINT/prive   (RW groupe $GROUP)"
for user_dir in $MOUNT_POINT/*/; do
    dirname=$(basename "$user_dir")
    [[ "$dirname" != "public" && "$dirname" != "prive" ]] && echo "   - $MOUNT_POINT/$dirname (RW utilisateur $dirname uniquement)"
done
echo "🌐 Accès réseau : smb://$IP/"
echo "============================"
```

---

## 7. Arborescence des dossiers

```
/mnt/nas
├─ public      (lecture/écriture pour smbusers, lecture seule invités)
├─ prive       (lecture/écriture pour groupe smbusers)
├─ etudiant1   (lecture/écriture pour utilisateur uniquement)
├─ etudiant2   (lecture/écriture pour utilisateur uniquement)
...
```

---

## 8. Instructions d’accès

* **iPhone** : app Files → “Se connecter au serveur” → `smb://<IP_RPi>/nom_du_partage` → identifiant/mdp
* **Mac** : Finder → “Se connecter au serveur” → `smb://<IP_RPi>/nom_du_partage` → identifiant/mdp
* **Windows** : Explorateur → `\\<IP_RPi>\nom_du_partage` → identifiant/mdp

---

## 9. Problèmes rencontrés et solutions

* 🔴 Clé USB non formatée → formatage automatique par le script
* 🔴 Permissions dossiers privés → réglées via `chmod` et groupe `smbusers`
* 🔴 Redémarrage service Samba → script redémarre et active `smbd` automatiquement

---

