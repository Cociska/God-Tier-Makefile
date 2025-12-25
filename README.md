# ⚡ God Tier Makefile

![Language](https://img.shields.io/badge/Language-C%20%2F%20Bash-00599C)
![Tools](https://img.shields.io/badge/Tools-FZF%20%7C%20Git%20%7C%20Docker-orange)
![License](https://img.shields.io/badge/License-MIT-green)

> **Ne vous contentez plus de compiler.**
> Transformez votre terminal en un véritable tableau de bord de productivité pour vos projets C.

Ce repository contient un **Makefile universel** et une suite de scripts Bash conçus pour optimiser le workflow des développeurs (particulièrement adapté pour Epitech/42). Il gère la compilation, les tests, git, le focus (Pomodoro) et bien plus encore.

## ✨ Fonctionnalités

### 🛠 Build & Dev
- **`make menu`** : Navigation interactive dans les commandes via **FZF**.
- **`make auto_build`** : Recompilation automatique à chaque sauvegarde (`CTRL+S`).
- **`make debug`** : Lance GDB automatiquement.
- **`make leaks`** : Vérification mémoire instantanée avec Valgrind.
- **`make docker`** : Lance un conteneur de test standardisé.

### 🐙 Git Integration (FZF Powered)
Plus besoin de taper des commandes git complexes. Tout est visuel.
- **`make commit`** : Clean, add, commit et push en une ligne.
- **`make branch`** : Changez de branche ou créez-en une nouvelle interactivement.
- **`make restore`** : Annulez des modifications fichier par fichier avec prévisualisation du diff.
- **`make git_log`** : Naviguez dans l'historique avec affichage du diff en direct.

### 🍅 Productivité & Fun
- **`make pomodoro`** : Timer de concentration avec intégration **Lofi Girl** (streaming audio YouTube).
- **`make coffee`** : Timer pour les pauses café.
- **`make weather`** : Météo en temps réel dans le terminal.
- **`make star_wars`** : Parce que pourquoi pas.

---

## 🚀 Installation

### 1. Pré-requis
Ce Makefile utilise des outils puissants. Assurez-vous de les avoir :

```bash
# Debian / Ubuntu / Kali
sudo apt install make gcc git fzf inotify-tools valgrind curl mpv socat
# Pour la musique (Lofi Girl)
sudo pip3 install yt-dlp