## **Fiche 1 – RPi5 Serveur NAS (Séance 1 / 3)**

| Étape    | Description                                                                                                                                                                      | Statut                                                                   |
| -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| Dossiers | Création de dossiers **Public** et **Privé** sur une clé USB montée sur le RPi5. Les dossiers ont été testés pour s’assurer qu’ils étaient accessibles depuis d’autres machines. | ![Terminé](https://img.shields.io/badge/Statut-Termin%C3%A9-brightgreen) |
| Samba    | Configuration de Samba pour partager les dossiers sur le réseau. Configuration basique appliquée : accès au dossier public et privé pour l’utilisateur `etudiant1`.              | ![En cours](https://img.shields.io/badge/Statut-En%20cours-yellow)       |
| Clients  | Montage des partages sur différents systèmes : **Mac, iPhone, Windows**. Le partage fonctionne correctement sur ces systèmes. Linux non testé faute de machine disponible.       | ![En cours](https://img.shields.io/badge/Statut-En%20cours-yellow)       |

**Détails et observations :**

* Installation du NAS suivie via un tutoriel précis.
* Création d’un utilisateur `etudiant1`.
* Dossiers Public et Privé fonctionnels.
* Tests réseau : Mac, iPhone et Windows peuvent accéder aux dossiers. Linux non testé.
* **Problème majeur** : après reboot du Raspberry Pi, la configuration Samba et le montage des dossiers sont perdus.
* Nécessité d’un script pour automatiser le relancement du NAS après coupure ou redémarrage.

---

