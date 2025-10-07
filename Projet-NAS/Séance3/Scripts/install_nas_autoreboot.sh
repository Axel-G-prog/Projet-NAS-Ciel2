#!/bin/bash
# Script NAS Samba autonome - Raspberry Pi 5
set -e

# Variables principales
DEVICE="/dev/sda1"
MOUNT_POINT="/mnt/nas"
LABEL="NAS_USB"
CONF_FILE="/etc/samba/smb.conf"
GROUP="smbusers"
LOG_FILE="/var/log/install_nas.log"

# Fonction de log
log() {
    LEVEL=$1; shift
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$TIMESTAMP] [$LEVEL] $*" | tee -a "$LOG_FILE"
}

# Vérification root
[ "$(id -u)" -ne 0 ] && log ERROR "Doit être exécuté en root" && exit 1

# Préparer le fichier de log
mkdir -p /var/log
echo "===== NAS Samba Auto-Reboot - $(date) =====" > "$LOG_FILE"

# ------------------------------
# Désactiver services inutiles
# ------------------------------
for svc in bluetooth.service avahi-daemon.service; do
    if systemctl is-enabled $svc &>/dev/null; then
        systemctl disable $svc
        systemctl stop $svc
        log INFO "Service inutile $svc désactivé"
    fi
done

# Attente du périphérique USB
TIMEOUT=30; COUNTER=0
while [ ! -b "$DEVICE" ]; do
    log WARN "Périphérique $DEVICE non détecté, attente..."
    sleep 2
    COUNTER=$((COUNTER+2))
    [ $COUNTER -ge $TIMEOUT ] && log ERROR "Périphérique introuvable" && exit 1
done

# Formatage si nécessaire
if ! blkid $DEVICE | grep -q "TYPE="; then
    log WARN "Formatage de $DEVICE en ext4"
    mkfs.ext4 -F -L $LABEL $DEVICE
fi

# Montage
mkdir -p $MOUNT_POINT
UUID=$(blkid -s UUID -o value $DEVICE)
mount -U $UUID $MOUNT_POINT || log INFO "Clé déjà montée"
grep -q "$UUID" /etc/fstab || echo "UUID=$UUID $MOUNT_POINT ext4 defaults 0 2" >> /etc/fstab

# Dossiers partagés
mkdir -p $MOUNT_POINT/public $MOUNT_POINT/prive
chmod 775 $MOUNT_POINT/public
chmod 770 $MOUNT_POINT/prive
groupadd -f $GROUP
chown root:$GROUP $MOUNT_POINT/prive $MOUNT_POINT/public

# Installer Samba et CIFS-utils
apt update -y && apt install -y samba cifs-utils
log INFO "Samba et cifs-utils installés"

# Sauvegarde configuration existante
[ -f $CONF_FILE ] && cp $CONF_FILE $CONF_FILE.bak.$(date +%F-%T)

# Configuration Samba
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

# Redémarrage et activation Samba
systemctl restart smbd
systemctl enable smbd

# Vérification
systemctl is-active --quiet smbd && log INFO "Samba actif" || log ERROR "Samba inactif"

IP=$(hostname -I | awk '{print $1}')
echo "NAS Samba prêt : smb://$IP/"

# ------------------------------
# Affichage des services actifs
# ------------------------------
log INFO "Services actifs  :"
systemctl list-units --type=service --state=running | grep -v "smbd\|nmbd"

# ------------------------------
# Affichage des logs
# ------------------------------
log INFO "10 dernières lignes du log Samba :"
tail -n 10 /var/log/samba/log.smbd || log WARN "Aucun log Samba trouvé"

if systemctl list-units --type=service | grep -q hostapd; then
    log INFO "Logs hostapd disponibles :"
    journalctl -u hostapd -n 10
else
    log INFO "Service hostapd non détecté "
fi