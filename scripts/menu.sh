#!/usr/bin/env bash

# ==================================================
# Makefile Interactive Menu (fzf) - clean + aligned
# ==================================================

C_RESET='\033[0m'
C_CYAN='\033[1;36m'
C_GREEN='\033[1;32m'
C_RED='\033[1;31m'

if ! command -v fzf >/dev/null 2>&1; then
  echo -e "${C_RED}Error: 'fzf' is not installed.${C_RESET}"
  exit 1
fi

# Build list: "CMD (padded) | DESC" + hidden TARGET
# We use TAB as delimiter to avoid regex issues.
build_list() {
  local cmd desc target
  while IFS=$'\t' read -r cmd desc target; do
    # Left column padded to align nicely
    printf "%-26s |  %-20s\t%s\n" "$cmd" "$desc" "$target"
  done <<'EOF'
make	compile project	all
make run	run project	run
make auto_build	rebuild changes	auto_build
make debug	debug project	debug
make docker	test safely	docker
make leaks	check leaks	leaks
make tests	run tests	tests
make coverage	open coverage	coverage
make commit	commit & push	commit
make branch	switch/create branch	branch
make restore	restore files	restore
make git_log	commits history	git_log
make count	count lines	count
make stats	project stats	stats
make api	setup api	api
make claude	ask claude	claude
make claude_debug	explain compilation issue	claude_fix
make project_start	start timer	project_start
make project_stop	stop timer	project_stop
make project	view project time	project
make pomodoro	focus timer	pomodoro
make coffee	break timer	coffee
make weather	check weather	weather
make joke	dev joke	joke
make radio	play radio	radio
make star_wars	ascii movie	star_wars
make clean	remove objects	clean
make fclean	full clean	fclean
make re	rebuild all	re
make update	update tools	update
make uninstall	uninstall	uninstall
make signature	signature	signature
make help	show help	help
EOF
}

LIST="$(build_list)"

echo -e "${C_CYAN}make menu${C_RESET}"

SELECTED=$(echo "$LIST" | fzf \
  --height=70% \
  --layout=reverse \
  --border \
  --delimiter=$'\t' \
  --with-nth=1 \
  --prompt="> " \
  --pointer="▶" \
  --info=inline \
  --header="Enter = run • Esc = quit"
)

if [ -z "$SELECTED" ]; then
  echo -e "${C_RED}Cancelled.${C_RESET}"
  exit 0
fi

TARGET=$(echo "$SELECTED" | cut -f2)

echo -e "${C_GREEN}>>> make ${TARGET}${C_RESET}"

if [ "$TARGET" = "claude" ]; then
  read -r -p "MSG> " MSG
  [ -z "$MSG" ] && echo -e "${C_RED}MSG empty. Cancelled.${C_RESET}" && exit 1
  make --no-print-directory claude MSG="$MSG"
else
  make --no-print-directory "$TARGET"
fi

