## **Fiche 2 – RPi5 : Mise en place du serveur NAS (Séance 2 / 3)**

| Étape          | Description                                                                                                                                                                           | Statut                                                                   |
| -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| **Script NAS** | Développement du script `install_nas.sh` permettant d’automatiser le montage du NAS après redémarrage. Il facilite également l’ajout de nouveaux utilisateurs Samba.                  | ![Terminé](https://img.shields.io/badge/Statut-Termin%C3%A9-brightgreen) |
| **Dossiers**   | Configuration des droits d’accès :                                                                                                                                                    | ![Terminé](https://img.shields.io/badge/Statut-Termin%C3%A9-brightgreen) |
|                | • **Public** : `etudiant1` (lecture/écriture/suppression), `guest` (lecture seule). <br> • **Privé** : `etudiant1` (lecture/écriture), `guest` (aucun accès).                         |                                                                          |
| **Clients**    | Validation sur tous les postes disponibles : montage correct des partages et respect des permissions. Tests effectués **avant et après redémarrage** pour confirmer l’automatisation. | ![Terminé](https://img.shields.io/badge/Statut-Termin%C3%A9-brightgreen) |

---

### Détails et constats

* Le script `install_nas.sh` automatise complètement le lancement du NAS et le montage des dossiers après reboot.
* Tous les tests fonctionnels ont été passés avec succès, y compris la création d’un nouvel utilisateur via le script.
* Le NAS est stable même après une coupure d’électricité ou un redémarrage. Le problème vient du fait que l'utilisateur doit exécuter le script de manière manuelle en cas de coupure d'électricité. Le NAS n'est pas totalement automatique. 

---

### Résultat du script en exécution

```bash
pi@raspberrypi:~ $ sudo ./install_nas.sh
=======================================
 Installation / Maintenance NAS Samba
=======================================
✅ La clé USB /dev/sda1 est déjà formatée.
✅ La clé est déjà montée sur /mnt/nas.
...
✅ NAS Samba prêt !

📁 Arborescence créée :
   - /mnt/nas/public  (lecture seule invités, RW pour smbusers)
   - /mnt/nas/prive   (RW groupe smbusers)

🌐 Accès réseau :
   smb://10.42.0.220/   (racine, affiche les partages disponibles)
```

