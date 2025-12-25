Voici le contenu complet du fichier `README.md`. Tu n'as qu'à cliquer sur "Copier" et coller ça dans ton fichier.

```markdown
# ⚡ God Tier Makefile

![Language](https://img.shields.io/badge/Language-C%20%2F%20Bash-00599C)
![Tools](https://img.shields.io/badge/Tools-FZF%20%7C%20Git%20%7C%20Docker-orange)
![License](https://img.shields.io/badge/License-MIT-green)

> **Stop just compiling.**
> Turn your terminal into a complete productivity dashboard for C development.

This repository provides a universal **Makefile** and a suite of bash scripts designed to optimize developer workflow (highly recommended for **Epitech**, **42**, and complex C projects). It handles compilation, testing, advanced Git management, focus timers, and environment monitoring.

## ✨ Features

* **Interactive Dashboard:** Navigate all commands using a fuzzy finder menu (`make menu`).
* **Live Monitoring:** Auto-recompile your project on every file save (`make auto_build`).
* **Git Automation:** Manage branches, commits, and history visually without leaving the terminal.
* **Quality Assurance:** One-command memory leak checks (Valgrind), unit testing (Criterion), and Dockerized execution.
* **Focus Mode:** Integrated Pomodoro timer with Lofi Girl radio streaming.

---

## 🚀 Installation

This Makefile relies on external scripts and system tools (FZF, Python, etc.). **You must run the installer first.**

### 1. Clone the repository
```bash
git clone [https://github.com/YOUR_USERNAME/God-Tier-Makefile.git](https://github.com/YOUR_USERNAME/God-Tier-Makefile.git)
cd God-Tier-Makefile

```

### 2. Run the automated installer

This script will install system dependencies (FZF, Valgrind, Inotify, MPV...), Python requirements (`yt-dlp`), and deploy the scripts to `~/Makefile/scripts`.

```bash
chmod +x install.sh
./install.sh

```

> **⚠️ Important:** Restart your terminal after installation to enable FZF keyboard shortcuts (`CTRL+R`, `CTRL+T`).

---

## 📖 How to use in your project

This Makefile is **portable**. Once installed on your machine, you can use it in any C project.

1. **Copy the Makefile** to the root of your C project:
```bash
cp ~/God-Tier-Makefile/Makefile ./MyProject/

```


2. **Edit the variables** at the top of the `Makefile` to match your project:
```makefile
# Name of your binary
NAME      = my_program

# Your source files
SRC       = src/main.c \
            src/utils.c ...

```


3. **Launch the dashboard:**
```bash
make menu

```



---

## 📚 Commands Reference

Here is a comprehensive list of all targets available in the Makefile.

### 🛠️ Build & Execution

| Command | Description |
| --- | --- |
| `make` / `all` | Compiles the project and generates the binary. |
| `make run` | Compiles (if needed) and executes the program. |
| `make auto_build` | **Live Monitor:** Watches your source files and recompiles automatically on every save (`CTRL+S`). |
| `make debug` | Compiles with debug flags (`-g3`) and launches **GDB** automatically. |
| `make re` | Forces a full rebuild (Clean + Compile). |

### 🧪 Quality & Testing

| Command | Description |
| --- | --- |
| `make tests` | Compiles and runs unit tests (using Criterion). |
| `make coverage` | Runs tests and opens a visual HTML code coverage report in your browser. |
| `make leaks` | Runs the program through **Valgrind** to check for memory leaks. |
| `make docker` | Launches the Epitech/standard Docker container to test your project in a clean Linux environment. |

### 🐙 Git Workflow (FZF Powered)

| Command | Description |
| --- | --- |
| `make commit` | Cleans the repo, adds all files, commits with a message (`MSG="foo"`), and pushes. |
| `make branch` | **Interactive:** Switch branches or create a new one by typing a name. |
| `make restore` | **Interactive:** View file diffs and discard local changes selectively. |
| `make git_log` | **Interactive:** Browse commit history with side-by-side diff preview. |

### 🍅 Productivity & Fun

| Command | Description |
| --- | --- |
| `make pomodoro` | Starts a **25m Focus / 5m Break** timer with Lofi Girl music integration. |
| `make coffee` | Starts a simple coffee break timer. |
| `make radio` | Streams "Lofi Girl" radio in the background (audio only). |
| `make weather` | Fetches and displays the current weather report. |
| `make joke` | Fetches a random programming joke from an API. |
| `make star_wars` | Streams Star Wars (Episode IV) in ASCII art via Telnet. |

### 📊 Info & Stats

| Command | Description |
| --- | --- |
| `make stats` | Displays project statistics (number of files, types, utils, etc.). |
| `make count` | Counts the total lines of code (LOC) in your source files. |
| `make signature` | Displays the custom project header/signature. |
| `make help` | Displays the list of available commands. |
| `make menu` | Opens the **Interactive Dashboard** to select any command. |

### 🧹 Cleaning

| Command | Description |
| --- | --- |
| `make clean` | Removes object files (`.o`) and temporary test artifacts. |
| `make fclean` | Removes the binary and performs a full cleanup. |

---

## ⚙️ Customization

All scripts are located in `~/Makefile/scripts`. You can modify them to:

* Change the radio station URL (in `pomodoro.sh` or `radio`).
* Adjust Pomodoro timer duration.
* Change terminal colors.

## 🤝 Contributing

Feel free to fork this repository and add your own scripts!

---

Made with 💜 and too much caffeine.

```

```
