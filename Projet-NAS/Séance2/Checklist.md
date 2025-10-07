# 📋 Checklist de test : NAS Raspberry Pi

---

## 1️⃣ Vérification de la clé USB
- ✅ **Détection de la clé USB** (`lsblk`)  
- ✅ **Montage de la clé USB** (`df -h`)  
- ✅ **Montage automatique après redémarrage** (`sudo reboot` → `df -h`)  

---

## 2️⃣ Vérification des dossiers
- ✅ **Dossier `public` présent**  
- ✅ **Dossier `prive` présent**  

---

## 3️⃣ Vérification des partages Samba sur le Raspberry
- ✅ **Liste des partages** (`smbclient -L localhost -U etudiant1`)  
- ✅ **Accès au partage Public** sans mot de passe (`smbclient //localhost/Public -N`)  
- ✅ **Accès au partage Privé** avec mot de passe (`smbclient //localhost/Prive -U etudiant1`)  
- ✅ **Seuls les utilisateurs Samba autorisés** (`etudiant1`, `etudiant2`) peuvent accéder au dossier privé  

---

## 4️⃣ Vérification depuis Windows
- ✅ **Accès au partage public** : `\\10.42.0.220\Public`  
- ✅ **Accès au partage privé** : `\\10.42.0.220\prive` avec `etudiant1` ou `etudiant2`  
- ✅ **Test lecture/écriture dans le dossier public**  
- ✅ **Test lecture/écriture dans le dossier privé**  
- ✅ **Montage des dossiers comme lecteur réseau** pour accès rapide  

---

## 5️⃣ Test de redémarrage
- ✅ **Redémarrage du Raspberry** (`sudo reboot`)  
- ✅ **Clé USB toujours montée** (`df -h`)  
- ✅ **Partages Samba toujours accessibles depuis Windows**  
- ✅ **Droits d’accès corrects** pour public et privé  

---

## 🎯 Validation finale
- ✅ La clé USB est montée et accessible  
- ✅ Les dossiers partagés fonctionnent correctement  
- ✅ Les utilisateurs Samba peuvent accéder au privé  
- ✅ Le NAS reste fonctionnel après redémarrage  
- ✅ Accessible via WiFi à l’IP `10.42.0.220`
