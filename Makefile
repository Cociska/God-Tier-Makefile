# ==================================================
# Compilers & Flags
# ==================================================

CC              = epiclang
CFLAGS          = -Wall -Wextra -Werror
CSFMLFLAGS      = -lcsfml-window -lcsfml-graphics -lcsfml-audio -lcsfml-system
MATHSFLAGS      = -lm
CRITERION_FLAGS = -lcriterion --coverage

# ==============================================================================
#   LOCATION & VIBES
# ==============================================================================

CITY        	= Lille
RADIO_URL   	= https://www.youtube.com/watch?v=jfKfPfyJRdk

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
C_ORANGE  = \033[38;5;208m

# ==================================================
# Paths & Files
# ==================================================

BROWSER    = firefox

SCRIPTS_PATH    =  ~/Makefile/scripts
SRC_PATH   = src/
TESTS_PATH = tests/
UTILS_PATH = utils/

SRC = 	main.c

SRC_TESTS = $(TESTS_PATH)tests.c

OBJ       = $(SRC:.c=.o)

NAME      = project_name
TEST_BIN  = test_runner

# ==================================================
# Build rules
# ==================================================

all: $(NAME)

$(NAME): $(OBJ)
	@$(CC) -o $(NAME) $(OBJ)
	@echo "$(C_GREEN)Compiled (^_^)$(C_RESET)"

%.o: %.c
	@echo "$(C_BLUE)Compiling $<$(C_RESET)"
	@$(CC) $(CFLAGS) -c $< -o $@

auto_build:
	@clear
	@echo "Recommendation : open in a background terminal :P"
	@$(SCRIPTS_PATH)/auto_build.sh

# ==================================================
# Run & Debug
# ==================================================

run:
	@clear
	all
	@./$(NAME)
	@echo "$(C_GREEN)Program executed correctly :<$(C_RESET)"

docker:
	@clear
	@echo "$(C_BLUE)Starting Epitech Docker...$(C_RESET)"
	@docker run -it -v ./:/usr/app epitechcontent/epitest-docker:latest

debug:
	@clear
	@gcc -g3 $(SRC) -o $(NAME)_debug $(CFLAGS)
	@echo "$(C_CYAN)>>> Starting GDB...$(C_RESET)"
	@gdb -ex "break main" -ex "run" ./$(NAME)_debug
	@rm -f $(NAME)_debug

leaks:
	@clear
	all
	@valgrind --leak-check=full ./$(NAME)

# ==================================================
# Tests & Coverage
# ==================================================

tests:
	@clear
	@gcc $(CFLAGS) $(SRC) $(SRC_TESTS) -o $(TEST_BIN) $(CRITERION_FLAGS)
	@echo "$(C_YELLOW)Tests compiled :9$(C_RESET)"
	@./$(TEST_BIN)
	@echo "$(C_GREEN)Tests executed ^^;$(C_RESET)"

coverage: tests
	@lcov -c -d . -o coverage.info --ignore-errors mismatch
	@echo "$(C_CYAN)Coverage data collected o_o$(C_RESET)"
	@lcov -r coverage.info "*/tests/*" -o coverage_filtered.info
	@echo "$(C_CYAN)Test files removed from coverage report ^.-$(C_RESET)"
	@genhtml coverage_filtered.info -o html_report
	@echo "$(C_CYAN)HTML coverage report generated ^^;$(C_RESET)"
	@$(BROWSER) html_report/index.html
	@echo "$(C_GREEN)Coverage report opened in browser :)$(C_RESET)"

# ==================================================
# Cleaning
# ==================================================

clean:
	@clear
	@rm -f $(OBJ)
	@echo "$(C_BLUE)Object files removed :D$(C_RESET)"
	@rm -f *.gcda *.gcno *.gcov
	@echo "$(C_BLUE)Test artifacts cleaned ;)$(C_RESET)"
	@rm -rf html_report coverage.info coverage_filtered.info
	@echo "$(C_BLUE)Coverage files deleted :P$(C_RESET)"

fclean: clean
	@rm -f $(NAME)
	@echo "$(C_CYAN)Binary removed <_<$(C_RESET)"

re: 	fclean all
	@echo "$(C_BOLD)$(C_YELLOW)Project rebuilt successfully \\o/$(C_RESET)"

# ==================================================
# Git
# ==================================================

commit:
	@clear
	@$(SCRIPTS_PATH)/commit.sh

restore:
	@clear
	@$(SCRIPTS_PATH)/restore.sh

branch:
	@clear
	@$(SCRIPTS_PATH)/branch.sh

git_log:
	@clear
	@$(SCRIPTS_PATH)/git_log.sh

# ==================================================
# Info rules
# ==================================================

count:
	@clear
	@$(SCRIPTS_PATH)/count.sh

stats:
	@clear
	@$(SCRIPTS_PATH)/stats.sh

# ==================================================
# Fun & focus
# ==================================================

star_wars:
	@$(SCRIPTS_PATH)/star_wars.sh

pomodoro:
	@clear
	@$(SCRIPTS_PATH)/pomodoro.sh

weather:
	@clear
	@$(SCRIPTS_PATH)/weather.sh

coffee:
	@clear
	@$(SCRIPTS_PATH)/coffee.sh

joke:
	@$(SCRIPTS_PATH)/joke.sh

radio:
	@$(SCRIPTS_PATH)/radio.sh

# ==================================================
# AI Assistant
# ==================================================

api:
	@$(SCRIPTS_PATH)/api.sh

claude:
	@$(SCRIPTS_PATH)/claude.py $(MSG)
	
claude_fix:
	@$(SCRIPTS_PATH)/claude_fix.sh

# ==================================================
# Update & Maintenance
# ==================================================

update:
	@clear
	@$(SCRIPTS_PATH)/update.sh
	
uninstall:
	@$(SCRIPTS_PATH)/uninstall.sh

# ==================================================
# Help & menu
# ==================================================

menu:
	@clear
	@$(SCRIPTS_PATH)/menu.sh

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
	@echo "$(C_YELLOW)  make branch$(C_RESET)     Create or switch branch (fzf)"
	@echo "$(C_YELLOW)  make restore$(C_RESET)    Discard changes (fzf)"
	@echo "$(C_YELLOW)  make git_log$(C_RESET)    Browse history (fzf)"
	@echo "                      Usage: make commit MSG='...'"
	@echo ""
	@echo "$(C_CYAN)  make count$(C_RESET)      Count total lines of C code"
	@echo "$(C_CYAN)  make stats$(C_RESET)      Show project statistics"
	@echo ""
	@echo "$(C_ORANGE)  make api$(C_RESET)        Launch AI API assistant"
	@echo "$(C_ORANGE)  make claude$(C_RESET)     Ask Claude (MSG='...')"
	@echo "$(C_ORANGE)  make claude_fix$(C_RESET) AI-powered fix suggestion"
	@echo ""
	@echo "$(C_PURPLE)  make signature$(C_RESET)  Show the Makefile signature"
	@echo "$(C_PURPLE)  make pomodoro$(C_RESET)   Launch Pomodoro (Omori Theme)"
	@echo "$(C_PURPLE)  make coffee$(C_RESET)     Take a coffee break"
	@echo "$(C_PURPLE)  make weather$(C_RESET)    Check weather in Lille"
	@echo "$(C_PURPLE)  make joke$(C_RESET)       Get a random dev joke"
	@echo "$(C_PURPLE)  make star_wars$(C_RESET)  Watch Star Wars in ASCII"
	@echo ""
	@echo "$(C_BLUE)  make update$(C_RESET)     Update tools & scripts"
	@echo ""
	@echo "$(C_CYAN)  make menu$(C_RESET)       Display navigation menu"
	@echo "$(C_CYAN)  make help$(C_RESET)       Display this help message"
	@echo ""
	@$(MAKE) --no-print-directory signature
	@echo ""

signature:
	@$(SCRIPTS_PATH)/signature.sh

.PHONY: \
	all run auto_build docker debug leaks \
	tests coverage \
	clean fclean re \
	commit restore branch git_log \
	count stats \
	api claude claude_fix \
	update \
	menu help signature \
	star_wars pomodoro coffee weather joke radio

