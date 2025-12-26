# ⚡ God Tier Makefile

![Language](https://img.shields.io/badge/Language-Bash-00599C)
![Tools](https://img.shields.io/badge/Tools-FZF%20%7C%20Git%20%7C%20Docker-orange)

> **Stop just compiling.**  
> Turn your terminal into a complete productivity dashboard for C development.

A universal **Makefile** + a suite of **Bash scripts** to supercharge your workflow (especially handy for **Epitech**, **42**, and bigger C projects).  
It covers compilation, testing, Git ergonomics, focus timers, and a few fun terminal utilities.

---

## 🧭 Table of Contents

- [✨ Features](#-features)
- [🚀 Installation](#-installation)
- [📖 Use it in your project](#-use-it-in-your-project)
- [📚 Commands Reference](#-commands-reference)
  - [🛠️ Build & Execution](#️-build--execution)
  - [🧪 Quality & Testing](#-quality--testing)
  - [🐙 Git Workflow](#-git-workflow)
  - [🍅 Productivity & Fun](#-productivity--fun)
  - [📊 Info & Stats](#-info--stats)
  - [🧹 Cleaning](#-cleaning)
- [⚙️ Customization](#️-customization)
- [🤝 Contributing](#-contributing)

---

## ✨ Features

- **Interactive Dashboard**: navigate all commands using a fuzzy finder menu (`make menu`).
- **Live Monitoring**: auto-recompile your project on every file save (`make auto_build`).
- **Git Automation**: manage branches, commits, and history visually without leaving the terminal.
- **Quality Assurance**: one-command Valgrind leak checks, Criterion tests, coverage, Dockerized execution.
- **Focus Mode**: integrated Pomodoro timer with optional “Lofi Girl” radio streaming.

---

## 🚀 Installation

This Makefile relies on external scripts and system tools (FZF, Python, etc.).  
**You must run the installer first.**

### 1) Clone the repository

```bash
git clone https://github.com/Cociska/God-Tier-Makefile.git
cd God-Tier-Makefile
```

### 2) Run the automated installer

This script installs system dependencies (FZF, Valgrind, Inotify, MPV...), Python requirements (`yt-dlp`),  
and deploys scripts to `~/Makefile/scripts`.

```bash
./install.sh
```


---

## 📖 Use it in your project

This Makefile is **portable**. Once installed, you can use it in any C project.

### 1) Copy the Makefile into your project root

```bash
cp ~/God-Tier-Makefile/Makefile ./MyProject/
```

### 2) Edit variables at the top of the `Makefile`

```makefile
# Name of your binary
NAME      = my_program

# Your source files
SRC       = src/main.c \
            src/utils.c \
            ...
```

### 3) Launch the dashboard

```bash
make menu
```

---

## 📚 Commands Reference

A (pretty) complete list of targets available in the Makefile.

### 🛠️ Build & Execution

| Command | Description |
|---|---|
| `make` / `make all` | Compiles the project and generates the binary. |
| `make run` | Compiles (if needed) and executes the program. |
| `make auto_build` | **Live Monitor:** watches your sources and recompiles on every save. |
| `make debug` | Compiles with debug flags (`-g3`) and launches **GDB** automatically. |
| `make re` | Forces a full rebuild (clean + compile). |

### 🧪 Quality & Testing

| Command | Description |
|---|---|
| `make tests` | Compiles and runs unit tests (Criterion). |
| `make coverage` | Runs tests and opens an HTML code coverage report. |
| `make leaks` | Runs the program through **Valgrind** to check for memory leaks. |
| `make docker` | Launches the Epitech/standard Docker container for a clean Linux run. |

### 🐙 Git Workflow

| Command | Description |
|---|---|
| `make commit` | Cleans repo, adds all files, commits (`MSG="foo"`), and pushes. |
| `make branch` | **Interactive:** switch branches or create a new one by typing a name. |
| `make restore` | **Interactive:** view file diffs and discard local changes selectively. |
| `make git_log` | **Interactive:** browse commit history with side-by-side diff preview. |

### 🍅 Productivity & Fun

| Command | Description |
|---|---|
| `make pomodoro` | Starts a **25m Focus / 5m Break** timer with music integration. |
| `make coffee` | Starts a simple coffee break timer. |
| `make radio` | Streams “Lofi Girl” radio in the background (audio only). |
| `make weather` | Fetches and displays the current weather report. |
| `make joke` | Fetches a random programming joke from an API. |
| `make star_wars` | Streams Star Wars (Episode IV) in ASCII art via Telnet. |

### 📊 Info & Stats

| Command | Description |
|---|---|
| `make stats` | Displays project statistics (file count, types, utils, etc.). |
| `make count` | Counts total lines of code (LOC). |
| `make signature` | Displays the custom project header/signature. |
| `make help` | Displays the list of available commands. |
| `make menu` | Opens the **Interactive Dashboard** to select any command. |

### 🧹 Cleaning

| Command | Description |
|---|---|
| `make clean` | Removes object files (`.o`) and temporary test artifacts. |
| `make fclean` | Removes the binary and performs a full cleanup. |

---

## 🤝 Contributing

Any contribution is welcome !

---

Made with 💜 and too much caffeine.
