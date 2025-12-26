# ⚡ God Tier Makefile

A **Makefile template** for C projects (Epitech/42) that turns your terminal into a **productivity dashboard**: build, tests, Git, debug, Docker, plus an AI assistant and focus tools.

---

## 🚀 Installation (one-time)

```bash
git clone https://github.com/Cociska/God-Tier-Makefile.git
cd God-Tier-Makefile
./install.sh
```

> Remember to **restart your terminal** after installation.

---

## 🧰 Quick usage

### 1) Initialize a project
Inside any project directory:

```bash
makefile
```

➡️ Automatically copies the Makefile template into the current folder.

### 2) Edit variables (important)
Open the **`Makefile`** in your project, then **edit the variables** at the top to **match your needs** (binary name, sources, flags, libs, etc.):

```makefile
NAME = my_binary
SRC  = src/main.c src/other.c
```

### 3) Launch the dashboard
```bash
make menu
```

---

## 🏗️ Build & Dev

| Command | What it does |
|---|---|
| `make` | Compile the project (CSFML/Maths friendly). |
| `make run` | Compile and run. |
| `make auto_build` | Watch mode: rebuild on every file save (inotify). |
| `make debug` | Build with `-g3` and launch GDB. |
| `make docker` | Launch the Epitech Docker environment. |

---

## 🧪 Tests & Quality

| Command | What it does |
|---|---|
| `make leaks` | Run Valgrind to detect memory leaks. |
| `make tests` | Run unit tests (Criterion). |
| `make coverage` | Generate and open an HTML coverage report (lcov). |

---

## 🐙 Git (FZF powered)

| Command | What it does |
|---|---|
| `make branch` | Interactive branch switch / creation. |
| `make commit` | `add .` + commit + push (message prompted). |
| `make restore` | Interactive restore of modified files. |
| `make git_log` | Interactive git history with diff preview. |

---

## 🤖 AI Assistant (Claude)

> Requires an Anthropic API key. Setup with: `make api`

| Command | What it does |
|---|---|
| `make claude MSG="..."` | Ask Claude directly from the terminal. |
| `make claude_fix` | Compile, then send error logs to the AI for explanations and fix hints. |

---

## 🍅 Focus & Utils

| Command | What it does |
|---|---|
| `make pomodoro` | Pomodoro timer (25/5) with lofi and battery status. |
| `make stats` | Code statistics (lines, files, density). |
| `make radio` | Play a YouTube radio in background (mpv). |
| `make coffee` / `make joke` | Coffee break timer or random dev joke. |

---

## 🧹 Maintenance

- **Update:** `make update` (pulls repo and reinstalls scripts)
- **Uninstall:** `make uninstall` (full cleanup, global command included)

---

<sub>Made with 💜 and a dangerously motivated coffee.</sub>
