# ⚡ God Tier Makefile

![Language](https://img.shields.io/badge/Language-C%20%2F%20Bash-00599C)
![Tools](https://img.shields.io/badge/Tools-FZF%20%7C%20Git%20%7C%20Docker-orange)
![License](https://img.shields.io/badge/License-MIT-green)

> **Stop just compiling.** > Turn your terminal into a complete productivity dashboard for C development.

This repository provides a universal **Makefile** and a suite of bash scripts designed to optimize developer workflow (highly recommended for **Epitech**, **42**, and generic C projects). It handles compilation, testing, git management, focus timers, and environment monitoring.

## ✨ Features

### 🛠 Build & Dev
- **`make menu`**: Interactive command navigation using **FZF**.
- **`make auto_build`**: Watches your files and recompiles automatically on save (`CTRL+S`).
- **`make debug`**: Launches GDB with breakpoints set on `main`.
- **`make leaks`**: Instant memory leak check with Valgrind.
- **`make docker`**: Runs your project inside a standardized testing container.

### 🐙 Git Integration (FZF Powered)
Visualize and manage your repository without typing complex commands.
- **`make commit`**: Clean, add, commit, and push in one line.
- **`make branch`**: Switch branches or create new ones interactively.
- **`make restore`**: Discard changes with a side-by-side diff preview.
- **`make git_log`**: Browse commit history with instant diff view.

### 🍅 Productivity
- **`make pomodoro`**: Focus timer integrated with **Lofi Girl** (YouTube streaming).
- **`make coffee`**: Break timer.
- **`make weather`**: Real-time weather display.

---

## 🚀 Installation

### 1. Clone the repository
```bash
git clone [https://github.com/YOUR_USERNAME/God-Tier-Makefile.git](https://github.com/YOUR_USERNAME/God-Tier-Makefile.git)
cd God-Tier-Makefile