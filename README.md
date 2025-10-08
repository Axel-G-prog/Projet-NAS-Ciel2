````markdown
<h1 align="center">🍓 Projet NAS Samba sur Raspberry Pi 5</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Raspberry%20Pi-5-red?logo=raspberrypi" alt="Raspberry Pi">
  <img src="https://img.shields.io/badge/Bash-Scripting-blue?logo=gnu-bash" alt="Bash">
  <img src="https://img.shields.io/badge/Linux-Automation-green?logo=linux" alt="Linux">
  <img src="https://img.shields.io/badge/Samba-NAS-yellow?logo=samba" alt="Samba">
  <img src="https://img.shields.io/badge/License-MIT-lightgrey" alt="MIT License">
</p>
````
---
````
> 🧠 **Projet réalisé en 3 séances** pour concevoir un **NAS (serveur de stockage en réseau)** autonome et fonctionnel sur **Raspberry Pi 5**.  
> Le but est de mettre en place un partage de fichiers fiable via **Samba**, avec des scripts d’installation, d’automatisation et de gestion d’utilisateurs.

---
````
## 📦 Objectif du projet

Ce projet transforme un **Raspberry Pi 5** en un **NAS personnel** capable de :
- partager des dossiers sur le réseau local (public & privé),
- gérer automatiquement le montage USB et le service Samba,
- ajouter facilement des utilisateurs Samba,
- conserver des **logs détaillés** pour le suivi du système.

---
````
## 🧠 Pourquoi avoir choisi **Samba** ?

J’ai choisi **Samba** car c’est la **solution la plus simple et universelle** pour partager des fichiers entre plusieurs systèmes (Windows, Linux, macOS).  
Voici les principales raisons de ce choix :

1. 🖥️ **Compatibilité totale**  
   Samba utilise le protocole **SMB/CIFS**, le même que les partages Windows.  
   Cela permet d’accéder au NAS depuis n’importe quel ordinateur du réseau, sans configuration complexe.

2. ⚙️ **Facilité d’installation et de gestion**  
   L’installation est rapide (`sudo apt install samba`) et sa configuration se fait dans un seul fichier (`/etc/samba/smb.conf`).

3. 🔐 **Gestion des utilisateurs et des droits**  
   Samba permet de créer des **comptes sécurisés**, d’attribuer des permissions précises (lecture seule, lecture/écriture, etc.) et de séparer les dossiers publics des dossiers privés.

4. 🔄 **Intégration avec Linux**  
   Samba fonctionne parfaitement sur Raspberry Pi OS (Linux), tout en restant léger et stable, idéal pour un projet d’apprentissage et de démonstration.

> 💬 En résumé : Samba permet d’avoir un **NAS simple, sécurisé et accessible depuis tous les systèmes**, sans nécessiter de matériel coûteux.
````
---

## 🗂️ Arborescence du projet

```bash
Projet-NAS/
├── Séance1/
│   └── Documentation.md
│
├── Séance2/
│   ├── Checklist.md
│   ├── Documentation-2.md
│   ├── Suivi-avancement-1.md
│   └── Suivi-avancement-2.md
│
├── Séance3/
│   ├── Scripts/
│   │   ├── install_nas_autoreboot.sh
│   │   └── add_samba_user.sh
│   ├── Cahier-des-charges-NAS.md
│   ├── Documentation-3.md
│   ├── Fiche-Recette-NAS.md
│   ├── Gantt.md
│   ├── Suivi-avancement-3.md
│   ├── Tutoriel-Complet.md
│   ├── statuts.md
│   └── img/
│
└── README.md
````

---

## 🧩 Organisation du travail

Le projet est réparti sur **3 séances**, chacune correspondant à une étape du développement.

### 🔹 **Séance 1 – Préparation**

* Installation du Raspberry Pi et configuration initiale.
* Étude du **cahier des charges** et définition des objectifs.
  📄 *→ Voir le document :* `Séance1/Documentation.md`

---

### 🔹 **Séance 2 – Développement**

* Mise en place des premiers partages Samba.
* Création des dossiers publics et privés.
* Suivi d’avancement et checklist de progression.
  📄 *→ Voir :*
  `Séance2/Documentation-2.md`
  `Séance2/Checklist.md`
  `Séance2/Suivi-avancement-1.md`
  `Séance2/Suivi-avancement-2.md`

---

### 🔹 **Séance 3 – Automatisation et finalisation**

* Création des **scripts Bash** :

  * `install_nas_autoreboot.sh` → installe et configure automatiquement le NAS Samba.
  * `add_samba_user.sh` → ajoute un utilisateur Samba avec un dossier privé.
* Configuration du **service systemd** pour un démarrage automatique.
* Rédaction de la documentation finale.
  📄 *→ Voir :*
  `Séance3/Tutoriel-Complet.md` (guide complet pas à pas)
  `Séance3/Documentation-3.md`
  `Séance3/Fiche-Recette-NAS.md`
  `Séance3/Gantt.md`
  `Séance3/Suivi-avancement-3.md`
  `Séance3/statuts.md`

---

## 🧰 Fonctionnement global

Le NAS ainsi configuré est :

* **Autonome** : démarre automatiquement avec le Raspberry Pi.
* **Accessible** : partage les dossiers via le réseau local (`\\IP_RASPBERRY\public` / `\\IP_RASPBERRY\prive`).
* **Sécurisé** : chaque utilisateur Samba dispose d’un espace personnel privé.
* **Documenté** : toutes les étapes sont décrites dans les fichiers de chaque séance.

---

## 🖥️ Aperçu des résultats

Les captures de tests et de fonctionnement sont disponibles ici :
`Séance3/img/`

<p align="center">
  <img src="./Séance3/img/Resultat-Script.png" width="70%" alt="Résultat du script principal">
  <br>
  <img src="./Séance3/img/Resultat-Script-User.png" width="70%" alt="Résultat ajout utilisateur">
</p>

---

## 📚 Pour aller plus loin

* 📝 **Tutoriel complet :** `Séance3/Tutoriel-Complet.md`
* 📖 **Cahier des charges :** `Séance3/Cahier-des-charges-NAS.md`
* 🧾 **Fiche de recette :** `Séance3/Fiche-Recette-NAS.md`
* 📊 **Diagramme Gantt :** `Séance3/Gantt.md`
* 🧩 **Scripts utilisés :** `Séance3/Scripts/`

---

## 👨‍💻 Auteur

**Nom / :** *Gantou Axel*
**GitHub :**(https://github.com/ton-pseudo)](https://github.com/Axel-G-prog)

> 🧰 Projet pédagogique réalisé sur **Raspberry Pi 5**, autour de l’administration Linux, du réseau et de l’automatisation.

---

## 🪪 Licence

Projet sous **licence MIT** — libre d’utilisation, de modification et de diffusion.

```text
MIT License
Copyright (c) 2025
```

<p align="center">
  <img src="https://img.shields.io/badge/Made%20with-Linux%20%26%20Love-black?logo=linux" alt="Made with Linux">
</p>
```

---

## Badges utilisés lors de la rédaction de la documentation technique : 

![En cours](https://img.shields.io/badge/Statut-En%20cours-yellow)
![Non commencé](https://img.shields.io/badge/Statut-Non%20commenc%C3%A9-lightgrey)
![Terminé](https://img.shields.io/badge/Statut-Termin%C3%A9-brightgreen) 

![Non Valide](https://img.shields.io/badge/Statut-Non%20Valide-red)
![Partiellement Valide](https://img.shields.io/badge/Statut-Partiellement%20Valide-lightgrey)
![Validé](https://img.shields.io/badge/Statut-Valid%C3%A9-brightgreen)
