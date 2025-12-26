# ⚡ God Tier Makefile

Un **template Makefile** pour projets C (Epitech/42) qui transforme ton terminal en **dashboard** : build, tests, Git, debug, Docker, + un assistant IA et un mode focus.

---

## 🚀 Installation (one-time)

```bash
git clone https://github.com/Cociska/God-Tier-Makefile.git
cd God-Tier-Makefile
./install.sh
```

> Pense à **relancer ton terminal** après l’installation.

---

## 🧰 Usage rapide

### 1) Initialiser un projet
Dans n’importe quel dossier de projet :

```bash
makefile
```

➡️ Copie automatiquement le template dans le dossier courant.

### 2) Modifier les variables (important)
Ouvre le **`Makefile`** du projet, puis **modifie les variables** en haut du fichier pour **matcher tes besoins** (nom du binaire, sources, flags, libs, etc.) :

```makefile
NAME = mon_binaire
SRC  = src/main.c src/autre.c
```

### 3) Lancer le dashboard
```bash
make menu
```

---

## 🏗️ Build & Dev

| Commande | Ce que ça fait |
|---|---|
| `make` | Compile (CSFML/Maths friendly). |
| `make run` | Compile + exécute. |
| `make auto_build` | Watch mode : recompile à chaque save (inotify). |
| `make debug` | Build `-g3` + lance GDB. |
| `make docker` | Lance l’environnement Epitech Docker (epitest-docker). |

---

## 🧪 Tests & Qualité

| Commande | Ce que ça fait |
|---|---|
| `make leaks` | Valgrind (fuites mémoire). |
| `make tests` | Unit tests (Criterion). |
| `make coverage` | Rapport HTML de coverage (lcov). |

---

## 🐙 Git (FZF inside)

| Commande | Ce que ça fait |
|---|---|
| `make branch` | Switch / création de branche interactive. |
| `make commit` | `add .` + commit + push (message demandé). |
| `make restore` | Restore interactif des fichiers modifiés. |
| `make git_log` | Historique interactif + preview diff. |

---

## 🤖 Assistant IA (Claude)

> Requiert une clé API Anthropic. Configuration : `make api`

| Commande | Ce que ça fait |
|---|---|
| `make claude MSG="..."` | Question à Claude depuis le terminal. |
| `make claude_fix` | Compile, puis en cas d’erreur envoie les logs à l’IA (explications + pistes de fix). |

---

## 🍅 Focus & Utils

| Commande | Ce que ça fait |
|---|---|
| `make pomodoro` | Pomodoro 25/5 + Lofi Girl + statut batterie. |
| `make stats` | Stats de code (lignes, fichiers, densité). |
| `make radio` | Radio YouTube en background (mpv). |
| `make coffee` / `make joke` | Pause café / blague dev. |

---

## 🧹 Maintenance

- **Update :** `make update` (pull + réinstalle scripts)
- **Uninstall :** `make uninstall` (nettoyage complet, commande globale incluse)

---

<sub>Made with 💜 and un café beaucoup trop déterminé.</sub>
