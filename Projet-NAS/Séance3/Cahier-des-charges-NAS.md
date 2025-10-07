# Cahier des charges – Mise en place d’un NAS via serveur Samba sur Raspberry Pi

## 1. Objectif

Mettre en place un service de partage de fichiers sur un Raspberry Pi via Samba, permettant l’accès à des dossiers partagés depuis différents clients (Windows, macOS, iOS, Linux).

## 2. Prérequis

| ID   | Description                                        | Statut | Commentaires                                                 |             |
| ---- | -------------------------------------------------- | ------ | ------------------------------------------------------------ | ----------- |
| PR01 | Raspberry Pi OS à jour                             | Validé | `sudo apt update && sudo apt upgrade`                        |             |
| PR02 | Clé USB ou disque externe disponible               | Validé | Vérifier avec `lsblk` ou `blkid`                             |             |
| PR03 | Paquet **samba** installé                          | Validé | Vérification avec `apt list --installed grep samba` |
| PR04 | Groupe **smbusers** créé                           | Validé | Créé automatiquement par le script                           |             |
| PR05 | Dossiers `/mnt/nas/public`, `/mnt/nas/prive` créés | Validé | Créés automatiquement par le script                          |             |
| PR06 | Accès réseau local fonctionnel                     | Validé | Testé par l'accès de **fichiers lourds** (>5 Mo) depuis un client (iPhone / Mac / Windows) |             |

## 3. Contraintes techniques

* Utilisation d’un Raspberry Pi comme serveur NAS.
* Support du protocole Samba (SMB/CIFS) pour compatibilité multi-plateformes.
* Gestion des droits utilisateurs via le groupe `smbusers`.
* Répertoires séparés pour les partages publics et privés.

## 4. Livrables

* Un Raspberry Pi configuré et opérationnel.
* Un disque externe ou clé USB monté sous `/mnt/nas/`.
* Service Samba actif et accessible sur le réseau local.
* Documentation d’installation et d’utilisation pour l’utilisateur final.

## 5. Vérification

* Accès aux partages Samba depuis plusieurs clients (Windows, macOS, iOS).
* Vérification des droits d’accès :

  * Le dossier **public** accessible sans authentification.
  * Le dossier **privé** accessible uniquement par des utilisateurs Samba définis.

---

