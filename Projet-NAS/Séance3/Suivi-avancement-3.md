# **Fiche – RPi5 : Mise en place NAS Samba autonome**

| Étape                   | Description                                                                                                                                                                                              | Statut                                                                   |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------ |
| **Préparation système** | Mise à jour du Raspberry Pi 5 et installation de `samba` + `cifs-utils`.                                                                                                                                 | ![Terminé](https://img.shields.io/badge/Statut-Termin%C3%A9-brightgreen) |
| **Script principal**    | Création du script `install_nas_autoreboot.sh` : <br>• Gestion automatique du périphérique USB. <br>• Formatage si nécessaire (ext4). <br>• Création des dossiers partagés (public / privé).             | ![Terminé](https://img.shields.io/badge/Statut-Termin%C3%A9-brightgreen) |
| **Configuration Samba** | Ajout et sauvegarde du fichier `smb.conf` avec 3 sections : <br>• **Public** (accès invité lecture seule, RW pour groupe smbusers). <br>• **Privé** (accès réservé smbusers). <br>• Utilisateurs futurs. | ![Terminé](https://img.shields.io/badge/Statut-Termin%C3%A9-brightgreen) |
| **Service systemd**     | Mise en place du service `nas-autoreboot.service` permettant l’exécution automatique du script au démarrage (auto-reboot après coupure ou redémarrage).                                                  | ![Terminé](https://img.shields.io/badge/Statut-Termin%C3%A9-brightgreen)       |
| **Script utilisateurs** | Création du script `add_samba_user.sh` : automatisation de la création d’un compte Samba avec son dossier personnel protégé.                                                                             | ![Terminé](https://img.shields.io/badge/Statut-Termin%C3%A9-brightgreen) |
| **Services inutiles désactivés & logs  activés**  | • Logs : `tail -f /var/log/install_nas.log`                                      | ![Terminé](https://img.shields.io/badge/Statut-Termin%C3%A9-brightgreen)       |
| **Validation & tests**  | • Test des partages depuis différents clients (Mac, iPhone & Windows). <br>• Vérification après redémarrage. <br>• Vérification des logs (`install_nas.log` et `smbd`).                                        | ![Terminé](https://img.shields.io/badge/Statut-Termin%C3%A9-brightgreen)       |

---

### **Détails et constats**

* Le script `install_nas_autoreboot.sh` gère bien :

  * la détection du périphérique USB,
  * le formatage si besoin,
  * le montage et l’écriture dans `/etc/fstab`,
  * la configuration automatique de Samba.
* Les partages **public** et **privé** sont accessibles selon les permissions définies.
* Les tests montrent que Samba est stable après un reboot.
* **Problème restant** : en cas de coupure d’électricité, il faut encore **relancer manuellement le script** si le service `nas-autoreboot.service` n’est pas activé correctement → l’automatisation n’est donc pas encore complète.
* Le script `add_samba_user.sh` fonctionne : création d’utilisateurs Samba + dossiers privés personnels avec droits exclusifs.

---

### **Résultat en exécution (extrait)**

```bash   
pi@raspberrypi:~ $ sudo ./install_nas_autoreboot.sh
=======================================
 Installation / Maintenance NAS Samba
=======================================
✅ La clé USB /dev/sda1 est déjà formatée.
✅ La clé est déjà montée sur /mnt/nas.
✅ Samba actif et configuré.
✅ NAS Samba prêt !

📁 Arborescence créée :
   - /mnt/nas/public  (lecture seule invités, RW pour smbusers)
   - /mnt/nas/prive   (RW groupe smbusers)

🌐 Accès réseau :
   smb://10.42.0.220/
```

#### **GANTT** 

Suivi du projet : 

<img src="../img/gantt.png" alt="gantt">

---
## Conclusion 

Le **NAS** est 100 % fonctionnel, même en cas de **coupure d'électricité**. L'automatisation du script au démarrage nous a forcé à créer un **deuxième** script pour l'ajout des utilisateurs. 

De plus les **services intutiles** ont été désactivés et les **logs** sont actifs, comme demandé. Ainsi le NAS correspond entièrement aux demandes. 

