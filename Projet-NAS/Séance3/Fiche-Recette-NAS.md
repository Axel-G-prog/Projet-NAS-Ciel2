# Fiche de recette - NAS Samba interactif (Raspberry Pi 5)

**Binôme** : Noa & Axel

**Date** : 03/10/2025

**Version** : 2.0

---

## 1. Prérequis

| **ID** | **Description**                                    | **Validé**                                                             | **Commentaires**                         |             |
| ------ | -------------------------------------------------- | ---------------------------------------------------------------------- | ---------------------------------------- | ----------- |
| PR01   | Raspberry Pi OS à jour                             | ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) | `sudo apt update && sudo apt upgrade`    |             |
| PR02   | Clé USB ou disque externe disponible               | ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) | Vérifier avec `lsblk` ou `blkid`         |             |
| PR03   | Paquet `samba` installé                            | ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) | `apt list --installed`                    `grep samba` |
| PR04   | Groupe `smbusers` créé                             | ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) | Créé automatiquement par le script       |             |
| PR05   | Dossiers `/mnt/nas/public`, `/mnt/nas/prive` créés | ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) | Créés automatiquement par le script      |             |
| PR06   | Accès réseau local fonctionnel                     | ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) | Ping depuis un client iPhone/Mac/Windows |             |

---

## 2. Tests fonctionnels

### 2.1 Configuration du partage public

| **ID Test** | **Fonctionnalité**        | **Description**                                 | **Méthode/Commande**                      | **Résultat attendu**       | **Résultat obtenu** | **Statut**                                                             |
| ----------- | ------------------------- | ----------------------------------------------- | ----------------------------------------- | -------------------------- | ------------------- | ---------------------------------------------------------------------- |
| T01         | Dossier public accessible | Accès en lecture sans authentification | `smbclient //localhost/public -N -c "ls"` | Liste des fichiers visible | ✔                   | ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) |
| T02         | Création de fichier       | Création d’un fichier depuis un client          | `touch /mnt/nas/public/test.txt`          | Fichier créé               | ✔                   | ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) |

### 2.2 Configuration du partage privé

| **ID Test** | **Fonctionnalité**                 | **Description**                    | **Méthode/Commande**                            | **Résultat attendu**          | **Résultat obtenu** | **Statut**                                                             |
| ----------- | ---------------------------------- | ---------------------------------- | ----------------------------------------------- | ----------------------------- | ------------------- | ---------------------------------------------------------------------- |
| T03         | Accès refusé sans authentification | Tentative de connexion anonyme     | `smbclient //localhost/prive -N -c "ls"`        | Accès refusé                  | ✔                   | ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) |
| T04         | Accès autorisé avec utilisateur    | Connexion avec un utilisateur créé | `smbclient //localhost/prive -U <user> -c "ls"` | Liste des fichiers accessible | ✔                   | ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) |


---

## 3. Tests clients iPhone / Mac / Windows

| **ID Test** | **Fonctionnalité**                  | **Description**                                                             | **Méthode/Commande / Instructions d’accès** | **Résultat attendu**                 | **Résultat obtenu** | **Statut**                                                             |
| ----------- | ----------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------- | ------------------------------------ | ------------------- | ---------------------------------------------------------------------- |
| T06         | Montage du partage public (iPhone)  | Accès depuis l’app Files                                                    | smb://<IP_RPi>/public + identifiants        | Accès en lecture/écriture            | ✔                   | ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) |
| T07         | Montage du partage privé (iPhone)   | Accès depuis l’app Files                                                    | smb://<IP_RPi>/prive + identifiants         | Accès en lecture/écriture            | ✔                   | ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) |
| T08         | Montage du partage public (Mac)     | Accès depuis Finder                                                         | smb://<IP_RPi>/public + identifiants        | Accès en lecture/écriture            | ✔                   | ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) |
| T09         | Montage du partage privé (Mac)      | Accès depuis Finder                                                         | smb://<IP_RPi>/prive + identifiants         | Accès en lecture/écriture            | ✔                   | ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) |
| T10         | Montage du partage public (Windows) | Accès via Explorateur Windows                                               | <IP_RPi>\public + identifiants              | Accès en lecture/écriture            | ✔                   | ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) |
| T11         | Montage du partage privé (Windows)  | Accès via Explorateur Windows                                               | <IP_RPi>\prive + identifiants               | Accès en lecture/écriture            | ✔                   | ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) |
| T12         | Transfert fichier lourd dans le dossier prive & public (>5 Mo)     | Copier un fichier >5 Mo dans public et privé                                | iPhone/Mac/Windows + identifiants           | Fichier copié et intact              | ✔                   | ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) |
| T13         | Séparation public / privé           | Vérifier que public est accessible par tous et privé seulement par smbusers | iPhone/Mac/Windows                          | Dossiers bien distincts et sécurisés | ✔                   | ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) |

---

## 4. Tests de robustesse réseau

| **ID Test** | **Fonctionnalité**                        | **Description**                                       | **Méthode/Commande / Instructions** | **Résultat attendu**                       | **Résultat obtenu** | **Statut**                                                             |
| ----------- | ----------------------------------------- | ----------------------------------------------------- | ----------------------------------- | ------------------------------------------ | ------------------- | ---------------------------------------------------------------------- |
| T14         | Connexion simultanée de plusieurs clients | Plusieurs clients accèdent aux partages simultanément | iPhone / Mac / Windows              | Tous les clients accèdent sans erreur, pour 3 appareils      | ✔                   | ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) |
| T15         | Redémarrage du service Samba              | Redémarrage propre de Samba                           | `sudo systemctl restart smbd`       | Service actif, partages accessibles        | ✔                   | ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) |
| T16         | Reboot du Raspberry Pi                    | Vérifier persistance des partages                     | `sudo reboot`                       | Tous les partages accessibles après reboot | ✔                   | ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) |

---

## 5. Observations

* **Succès** : Les partages public, privé et personnels fonctionnent correctement sur iPhone, Mac et Windows.
* **Points à améliorer** :

  * Ajouter quotas disque pour utilisateurs privés.
  * Automatiser la création des utilisateurs Samba depuis un fichier CSV pour de grandes installations.
  * Ajouter tests de débit et performance pour fichiers volumineux.
  * Prévoir un plan de backup automatique du NAS.

---

## 6. Instructions d’accès pour différents OS

* **iPhone** : app Files → “Se connecter au serveur” → smb://<IP_RPi>/nom_du_partage → identifiant/mdp.
* **Mac** : Finder → “Se connecter au serveur” → smb://<IP_RPi>/nom_du_partage → identifiant/mdp.
* **Windows** : Explorateur → <IP_RPi>\nom_du_partage → identifiant/mdp.

---

## 7. Validation globale

**Statut final** : ![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen) 

