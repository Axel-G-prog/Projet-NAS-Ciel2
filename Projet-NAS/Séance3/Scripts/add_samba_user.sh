#!/bin/bash
# Créer un utilisateur Samba avec dossier personnel
set -e

GROUP="smbusers"
MOUNT_POINT="/mnt/nas"
CONF_FILE="/etc/samba/smb.conf"
LOG_FILE="/var/log/install_nas.log"

log() {
    LEVEL=$1; shift
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$TIMESTAMP] [$LEVEL] $*" | tee -a "$LOG_FILE"
}

# Vérification root
[ "$(id -u)" -ne 0 ] && log ERROR "Doit être root" && exit 1

read -p "Nom utilisateur à créer : " USER
[ -z "$USER" ] && log ERROR "Nom vide" && exit 1

id "$USER" &>/dev/null || useradd -M -s /sbin/nologin "$USER" && log INFO "Utilisateur système $USER créé"
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

systemctl restart smbd
log INFO "Partage personnel pour $USER créé"