# ==================================================
# Compilers & Flags
# ==================================================

CC              = epiclang
TESTS_CC        = gcc
CFLAGS          = -Wall -Wextra -Werror
CSFMLFLAGS      = -lcsfml-window -lcsfml-graphics -lcsfml-audio -lcsfml-system
MATHSFLAGS      = -lm
CRITERION_FLAGS = -lcriterion

# ==================================================
# Colors
# ==================================================

C_RESET   = \033[0m
C_BOLD    = \033[1m

C_GREEN   = \033[32m
C_BLUE    = \033[34m
C_CYAN    = \033[36m
C_YELLOW  = \033[93m
C_PURPLE  = \033[35m

# ==================================================
# Paths & Files
# ==================================================

RDR_FILE   = 1000_planes_10_towers.rdr
BROWSER    = firefox

SCRIPTS_PATH    =  ~/Makefile/scripts
SRC_PATH   = src/
TESTS_PATH = tests/
UTILS_PATH = utils/
PATH_LIBMY  = lib/my/
PATH_LIBPRINTF  = lib/my_printf/

SRC = $(PATH_LIBMY)my_compute_power_rec.c \
      $(PATH_LIBMY)my_compute_square_root.c \
      $(PATH_LIBMY)my_find_prime_sup.c \
      $(PATH_LIBMY)my_getnbr.c \
      $(PATH_LIBMY)my_isneg.c \
      $(PATH_LIBMY)my_is_prime.c \
      $(PATH_LIBMY)my_putchar.c \
      $(PATH_LIBMY)my_put_nbr.c \
      $(PATH_LIBMY)my_putstr.c \
      $(PATH_LIBMY)my_revstr.c \
      $(PATH_LIBMY)my_showmem.c \
      $(PATH_LIBMY)my_showstr.c \
      $(PATH_LIBMY)my_sort_int_array.c \
      $(PATH_LIBMY)my_strcapitalize.c \
      $(PATH_LIBMY)my_strcat.c \
      $(PATH_LIBMY)my_strcmp.c \
      $(PATH_LIBMY)my_strcpy.c \
      $(PATH_LIBMY)my_str_isalpha.c \
      $(PATH_LIBMY)my_str_islower.c \
      $(PATH_LIBMY)my_str_isnum.c \
      $(PATH_LIBMY)my_str_isprintable.c \
      $(PATH_LIBMY)my_str_isupper.c \
      $(PATH_LIBMY)my_strlen.c \
      $(PATH_LIBMY)my_strlowcase.c \
      $(PATH_LIBMY)my_strncat.c \
      $(PATH_LIBMY)my_strncmp.c \
      $(PATH_LIBMY)my_strncpy.c \
      $(PATH_LIBMY)my_strstr.c \
      $(PATH_LIBMY)my_strupcase.c \
      $(PATH_LIBMY)my_swap.c \
      $(PATH_LIBPRINTF)my_put_float.c \
      $(PATH_LIBPRINTF)my_put_nbr_uint.c \
      $(PATH_LIBPRINTF)my_put_oct.c \
      $(PATH_LIBPRINTF)my_put_hex.c \
      $(PATH_LIBPRINTF)my_printf.c \
      $(PATH_LIBPRINTF)my_put_pointer.c \
      $(PATH_LIBPRINTF)my_isinf.c \
      $(PATH_LIBPRINTF)my_isnan.c \
      $(PATH_LIBPRINTF)my_put_ieee.c \
      $(PATH_LIBPRINTF)my_put_float_sci.c \
      $(PATH_LIBPRINTF)my_put_bin.c \
      $(SRC_PATH)my_count_files.c \
      $(SRC_PATH)my_copy_name.c \
      $(SRC_PATH)my_get_files.c \
      $(SRC_PATH)my_sort_files.c \
      $(SRC_PATH)my_display.c \
      $(SRC_PATH)my_flag_r.c \
      $(SRC_PATH)my_get_flags.c \
      $(SRC_PATH)my_path_complete.c \
      main.c

SRC_TESTS = $(TESTS_PATH)test_my_radar.c
OBJ       = $(SRC:.c=.o)

NAME      = my_ls
TEST_BIN  = test_runner

# ==================================================
# Build rules
# ==================================================

all: $(NAME)

$(NAME): $(OBJ)
	@$(CC) -o $(NAME) $(OBJ) $(CSFMLFLAGS) $(MATHSFLAGS)
	@echo "$(C_GREEN)Compiled (^_^)$(C_RESET)"
	@$(MAKE) --no-print-directory signature

%.o: %.c
	@echo "$(C_BLUE)Compiling $<$(C_RESET)"
	@$(CC) $(CFLAGS) -c $< -o $@

auto_build:
	@echo "$(C_CYAN)>>> Auto-Build System Online (Global Watch)...$(C_RESET)"
	@echo "$(C_CYAN)>>> Watching ALL files (excluding .git & artifacts)$(C_RESET)"
	@while true; do \
		inotifywait -q -r -e close_write --exclude '(\.git/|\.o$$|$(NAME)$$)' . 2>/dev/null; \
		echo "$(C_YELLOW)⚡ Change detected. Rebuilding...$(C_RESET)"; \
		$(MAKE) --no-print-directory; \
		echo "$(C_GREEN)Build finished. Waiting...$(C_RESET)"; \
	done

# ==================================================
# Run & Debug
# ==================================================

run: all
	@./$(NAME)
	@echo "$(C_GREEN)Program executed correctly :<$(C_RESET)"

docker:
	@echo "$(C_BLUE)Starting Epitech Docker...$(C_RESET)"
	@docker run -it -v ./:/usr/app epitechcontent/epitest-docker:latest

debug:
	@gcc -g3 $(SRC) -o $(NAME)_debug $(CFLAGS) $(CSFMLFLAGS) $(MATHSFLAGS)
	@echo "$(C_CYAN)>>> Starting GDB...$(C_RESET)"
	@gdb -ex "break main" -ex "run" ./$(NAME)_debug
	@rm -f $(NAME)_debug

leaks: all
	@valgrind --leak-check=full ./$(NAME)

# ==================================================
# Tests & Coverage
# ==================================================

tests:
	@$(TESTS_CC) $(CFLAGS) $(SRC) $(SRC_TESTS) -o $(TEST_BIN) $(CRITERION_FLAGS)
	@echo "$(C_YELLOW)Tests compiled :9$(C_RESET)"
	@./$(TEST_BIN)
	@echo "$(C_GREEN)Tests executed without errors ^^;$(C_RESET)"

coverage: tests
	@lcov -c -d . -o coverage.info --ignore-errors mismatch
	@echo "$(C_CYAN)Coverage data collected o_o$(C_RESET)"
	@lcov -r coverage.info "*/tests/*" -o coverage_filtered.info
	@echo "$(C_CYAN)Test files removed from coverage report ^.-$(C_RESET)"
	@genhtml coverage_filtered.info -o html_report
	@echo "$(C_CYAN)HTML coverage report generated ^^;$(C_RESET)"
	@$(BROWSER) html_report/index.html
	@echo "$(C_GREEN)Coverage report opened in browser :)$(C_RESET)"
	@$(MAKE) --no-print-directory signature

# ==================================================
# Cleaning
# ==================================================

clean:
	@rm -f $(OBJ)
	@echo "$(C_BLUE)Object files removed :D$(C_RESET)"
	@rm -f *.gcda *.gcno *.gcov
	@echo "$(C_BLUE)Test artifacts cleaned ;)$(C_RESET)"
	@rm -rf html_report coverage.info coverage_filtered.info
	@echo "$(C_BLUE)Coverage files deleted :P$(C_RESET)"

fclean: clean
	@rm -f $(NAME)
	@echo "$(C_CYAN)Binary removed <_<$(C_RESET)"

re: fclean all
	@echo "$(C_BOLD)$(C_YELLOW)Project rebuilt successfully \\o/$(C_RESET)"

# ==================================================
# Git
# ==================================================

commit:
	@clear
	@$(MAKE) --no-print-directory fclean
	@git add .
	@echo "$(C_YELLOW)Files added ^_^$(C_RESET)"
	@git commit -m "$(MSG)"
	@echo "$(C_YELLOW)Commit created with provided message :]$(C_RESET)"
	@git push --quiet
	@echo "$(C_GREEN)Changes pushed to GitHub <3$(C_RESET)"
	@$(MAKE) --no-print-directory signature

restore:
	@clear
	@$(SCRIPTS_PATH)/restore.sh

branch:
	@clear
	@$(SCRIPTS_PATH)/branch.sh

git_log:
	@clear
	@$(SCRIPTS_PATH)/history.sh

# ==================================================
# Info rules
# ==================================================

count:
	@echo ""
	@echo "$(C_BOLD)$(C_CYAN)Lines of C code:$(C_RESET)"
	@echo "$(C_CYAN)------------------$(C_RESET)"
	@echo "$(C_BOLD)$(C_CYAN)$$(wc -l $(SRC) | tail -n 1)$(C_RESET)"
	@echo "$(C_CYAN)------------------$(C_RESET)"
	@echo ""
	@$(MAKE) --no-print-directory signature

stats:
	@echo ""
	@echo "$(C_BOLD)$(C_CYAN)Project statistics$(C_RESET)"
	@echo "$(C_CYAN)------------------$(C_RESET)"
	@echo "$(C_CYAN)Source files :$(C_RESET) $(C_BOLD)$$(echo $(SRC) | wc -w)$(C_RESET)"
	@echo "$(C_CYAN)Test files   :$(C_RESET) $(C_BOLD)$$(echo $(SRC_TESTS) | wc -w)$(C_RESET)"
	@echo "$(C_CYAN)Utils files  :$(C_RESET) $(C_BOLD)$$(ls $(UTILS_PATH)/*.c 2>/dev/null | wc -l)$(C_RESET)"
	@echo "$(C_CYAN)Total lines  :$(C_RESET) $(C_BOLD)$$(wc -l $(SRC) | tail -n 1 | awk '{print $$1}')$(C_RESET)"
	@echo "$(C_CYAN)------------------$(C_RESET)"
	@echo ""
	@$(MAKE) --no-print-directory signature

# ==================================================
# Signature & Fun
# ==================================================

signature:
	@$(SCRIPTS_PATH)/signature.sh

star_wars:
	@ssh starwarstel.net

pomodoro:
	@$(SCRIPTS_PATH)/pomodoro.sh

weather:
	@clear
	@curl -s "wttr.in/Lille?format=3"
	@echo ""
	@curl -s "wttr.in/Lille?0"

coffee:
	@$(SCRIPTS_PATH)/coffee.sh

joke:
	@echo "\033[36m"
	@curl -s https://v2.jokeapi.dev/joke/Programming?format=txt
	@echo "\033[0m"

radio:
	@echo "$(C_PURPLE)>>> Tuning in to Lofi Girl Radio... 🎧$(C_RESET)"
	@mpv --no-video --really-quiet "https://www.youtube.com/watch?v=jfKfPfyJRdk" &
	@echo "$(C_CYAN)Radio started in background. Use 'killall mpv' to stop.$(C_RESET)"

menu:
	@echo "$(C_CYAN)⚡ Select a target:$(C_RESET)"
	@t=$$(printf "run\nauto_build\ntests\nleaks\ndebug\ndocker\ncommit\nbranch\nrestore\ngit_log\npomodoro\ncoffee\nweather\nstar_wars\nclean\nfclean" | fzf --height=50% --layout=reverse --border --prompt="Make > " --pointer="▶" --marker="✓") && \
	if [ -n "$$t" ]; then \
	   echo "$(C_GREEN)Executing: make $$t $(C_RESET)"; \
	   $(MAKE) --no-print-directory $$t; \
	fi

# ==================================================
# Help
# ==================================================

help:
	@echo ""
	@echo "$(C_BOLD)$(C_CYAN)Available targets:$(C_RESET)"
	@echo ""
	@echo "$(C_GREEN)  make$(C_RESET)            Build the project"
	@echo "$(C_GREEN)  make run$(C_RESET)        Run the program"
	@echo "$(C_GREEN)  make auto_build$(C_RESET) Auto-build on file save"
	@echo "$(C_GREEN)  make tests$(C_RESET)      Run unit tests"
	@echo "$(C_GREEN)  make docker$(C_RESET)     Run a virtual env"
	@echo "$(C_GREEN)  make debug$(C_RESET)      Run project in GDB"
	@echo "$(C_GREEN)  make leaks$(C_RESET)      Run valgrind leak check"
	@echo "$(C_GREEN)  make coverage$(C_RESET)   Open a web coverage report"
	@echo ""
	@echo "$(C_BLUE)  make clean$(C_RESET)      Remove object files"
	@echo "$(C_BLUE)  make fclean$(C_RESET)     Full cleanup"
	@echo "$(C_BLUE)  make re$(C_RESET)         Rebuild everything"
	@echo ""
	@echo "$(C_YELLOW)  make commit$(C_RESET)     Clean, commit and push"
	@echo "$(C_YELLOW)  make branch$(C_RESET)     Create or Switch branch (fzf)"
	@echo "$(C_YELLOW)  make restore$(C_RESET)    Discard changes (fzf)"
	@echo "$(C_YELLOW)  make git_log$(C_RESET)    Browse history (fzf)"
	@echo "                      Usage: make commit MSG='...'"
	@echo ""
	@echo "$(C_CYAN)  make count$(C_RESET)      Count total lines of C code"
	@echo "$(C_CYAN)  make stats$(C_RESET)      Show project statistics"
	@echo ""
	@echo "$(C_PURPLE)  make signature$(C_RESET)  Show the Makefile signature"
	@echo "$(C_PURPLE)  make pomodoro$(C_RESET)   Launch Pomodoro (Omori Theme)"
	@echo "$(C_PURPLE)  make coffee$(C_RESET)     Take a coffee break (timer)"
	@echo "$(C_PURPLE)  make weather$(C_RESET)    Check weather in Lille"
	@echo "$(C_PURPLE)  make joke$(C_RESET)       Get a random dev joke"
	@echo "$(C_PURPLE)  make star_wars$(C_RESET)  Watch Star Wars in ASCII"
	@echo ""
	@echo "$(C_CYAN)  make menu$(C_RESET)       Display the navigation menu"
	@echo "$(C_CYAN)  make help$(C_RESET)       Display this help message"
	@echo ""
	@$(MAKE) --no-print-directory signature
	@echo ""

.PHONY: all clean fclean re run leaks tests coverage commit restore branch git_log count stats help menu signature star_wars pomodoro coffee weather joke debug docker auto_build radio