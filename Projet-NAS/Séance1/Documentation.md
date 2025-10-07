# Documentation Technique – NAS Samba interactif (Raspberry Pi 5)

## 1. Présentation

**Service installé** : NAS Samba interactif
**Nom du groupe** : Groupe 1 – Binôme Noa & Axel
**Date d’installation** : 01/10/2025
**Objectif** : Fournir un NAS avec dossiers publics, privés et personnels pour chaque utilisateur, accessible via SMB sur le réseau local.

---

## 2. Matériel utilisé

* Raspberry Pi modèle : 5
* Support de stockage : Clé USB (`/dev/sda1`)
* Connexion : Wi-Fi (HotSpot)
* Système : Raspberry Pi OS Desktop

---

## 3. Configuration réseau

* Adresse IP : `10.42.0.220` (DHCP)
* Masque : `255.255.255.0`
* Passerelle : `10.42.0.1` 

---

## 4. Services installés

### NAS Samba

* **Partages créés** :

  * Public : `/mnt/nas/public` (lecture/écriture pour tous)
  * Privé : `/mnt/nas/prive` (lecture/écriture pour groupe `smbusers`)
  * Personnels : `/mnt/nas/<nom_utilisateur>` (lecture/écriture pour l’utilisateur uniquement)

* **Groupe Samba** : `smbusers`

* **Création utilisateurs** : interactif via le script

* **Permissions** :

  * Public : 777
  * Privé : 770
  * Personnel : 700

* **Configuration SMB** : `/etc/samba/smb.conf` (créé/modifié par le script avec backup automatique)

---

## 5. Scripts utilisés

* `install_nas.sh` : installation et configuration complète du NAS

  * Formatage et montage automatique de la clé USB
  * Création des dossiers partagés (`public`, `prive`, utilisateurs)
  * Installation et configuration Samba
  * Ajout interactif des utilisateurs et de leurs dossiers personnels
  * Redémarrage et activation du service Samba
* Backup automatique de `smb.conf` : `$CONF_FILE.bak.<date>`

---

## 6. Arborescence des dossiers

```
/mnt/nas
├─ public      (lecture/écriture pour tous)
├─ prive       (lecture/écriture pour groupe smbusers)
```

---

## 7. Instructions d’accès pour différents OS

* **iPhone** : app Files → “Se connecter au serveur” → smb://<IP_RPi>/nom_du_partage → identifiant/mdp
* **Mac** : Finder → “Se connecter au serveur” → smb://<IP_RPi>/nom_du_partage → identifiant/mdp
* **Windows** : Explorateur → \<IP_RPi>\nom_du_partage → identifiant/mdp

---

## 8. Problèmes rencontrés et solutions

* 🔴 Clé USB non formatée → formatage automatique en ext4 par le script
* 🔴 Permissions dossiers privés → réglées via chmod et groupe `smbusers`
* 🔴 Redémarrage service Samba → script redémarre et active smbd automatiquement

---


