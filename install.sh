#!/bin/bash

set -e

######################################################################################
#                                                                                    #
# Project 'pyroactyl-installer'                                                      #
#                                                                                    #
# This script is not associated with the official Pyrodactyl Project.                #
# https://github.com/ManucrackYT/pyroactyl-installer                                 #
#                                                                                    #
#                           <\              _			                                   #
#                            \\          _/{			                                   #
#                     _       \\       _-   -_			                                 #
#                   /{        / `\   _-     - -_		                                 #
#                 _~  =      ( @  \ -        -  -_		                               #
#               _- -   ~-_   \( =\ \           -  -_		                             #
#             _~  -       ~_ | 1 :\ \      _-~-_ -  -_		                           #
#           _-   -          ~  |V: \ \  _-~     ~-_-  -_	                           #
#        _-~   -            /  | :  \ \            ~-_- -_	                         #
#     _-~    -   _.._      {   | : _-``               ~- _-_	                       #
#  _-~   -__..--~    ~-_  {   : \:}				                                           #
# =~__.--~~              ~-_\  :  /				                                           #
#                           \ : /__				                                           #
#                          //`Y'--\\      			                                     #
#                        <+       \\				                                         #
#                          \\      WWW				                                       #
#                          MMM					                                             #
######################################################################################

export GITHUB_SOURCE="v1.1.1"
export SCRIPT_RELEASE="v1.1.1"
export GITHUB_BASE_URL="https://raw.githubusercontent.com/ManucrackYT/pyroactyl-installer"

LOG_PATH="/var/log/pyroactyl-installer.log"

# check for curl
if ! [ -x "$(command -v curl)" ]; then
  echo "* curl is required in order for this script to work."
  echo "* install using apt (Debian and derivatives) or yum/dnf (CentOS)"
  exit 1
fi

# Always remove lib.sh, before downloading it
rm -rf /tmp/lib.sh
curl -sSL -o /tmp/lib.sh "$GITHUB_BASE_URL"/"$GITHUB_SOURCE"/lib/lib.sh
# shellcheck source=lib/lib.sh
source /tmp/lib.sh

# Global variable for Panel installation directory
PANEL_INSTALL_DIR="/var/www/pterodactyl"

check_dependencies() {
  output "Checking dependencies..."

  # Panel Dependencies
  output "Checking Panel dependencies..."

  # PHP
  if ! command -v php &> /dev/null; then
    error "PHP is not installed. Please install PHP and try again." 1
  else
    output "PHP: OK"
    # PHP Extensions
    local php_extensions=("cli" "openssl" "gd" "mysql" "pdo" "mbstring" "tokenizer" "bcmath" "xml" "curl" "zip")
    local missing_extensions=()
    for ext in "${php_extensions[@]}"; do
      if ! php -m | grep -iq "$ext"; then
        missing_extensions+=("$ext")
      fi
    done
    if [ ${#missing_extensions[@]} -gt 0 ]; then
      error "Missing PHP extensions: ${missing_extensions[*]}. Please install them and try again." 1
    else
      output "PHP Extensions: OK"
    fi
  fi

  # Database
  if ! command -v mysql &> /dev/null && ! command -v mariadb &> /dev/null; then
    warning "Neither MySQL nor MariaDB command was found. Panel installation might fail if a database server is not running or accessible."
  else
    output "Database client: OK (MySQL or MariaDB found)"
  fi

  # Redis
  if ! command -v redis-server &> /dev/null; then
    warning "redis-server command not found. Panel installation might fail if Redis is not running or accessible."
  else
    output "Redis: OK (redis-server found)"
  fi

  # Webserver - recommendation
  output "Webserver: Please ensure you have a webserver (Nginx, Apache, etc.) installed and configured for the panel."

  # Common Utilities
  local common_utils=("curl" "tar" "unzip" "git" "composer")
  for util in "${common_utils[@]}"; do
    if ! command -v "$util" &> /dev/null; then
      # curl is checked before lib.sh is sourced, so we can skip it here
      if [[ "$util" == "curl" && -x "$(command -v curl)" ]]; then
        output "curl: OK"
        continue
      fi
      error "$util is not installed. Please install $util and try again." 1
    else
      output "$util: OK"
    fi
  done

  # Wings Dependencies
  output "Checking Wings dependencies..."

  # Docker
  if ! command -v docker &> /dev/null; then
    error "Docker is not installed. Please install Docker and try again." 1
  else
    output "Docker: OK"
  fi

  output "Dependency checks complete. Please review any warnings above."
}

check_dependencies

# Variable to track if panel directory prompt was already shown
panel_dir_prompted=false

execute() {
  echo -e "\n\n* pyroactyl-installer $(date) \n\n" >>$LOG_PATH

  local main_action_is_panel=false
  if [[ "$1" == "panel" || "$1" == "panel_canary" ]]; then
    main_action_is_panel=true
  fi

  if [ "$main_action_is_panel" == true ] && [ "$panel_dir_prompted" == false ]; then
    output "Default Panel installation directory is $PANEL_INSTALL_DIR"
    echo -e -n "* Would you like to specify a custom installation directory for the Panel? (y/N): "
    read -r custom_dir_choice
    if [[ "$custom_dir_choice" =~ [Yy] ]]; then
      echo -e -n "* Enter the custom installation directory: "
      read -r PANEL_INSTALL_DIR_CUSTOM
      if [ -n "$PANEL_INSTALL_DIR_CUSTOM" ]; then
        PANEL_INSTALL_DIR="$PANEL_INSTALL_DIR_CUSTOM"
        output "Using custom Panel installation directory: $PANEL_INSTALL_DIR"
      else
        output "No custom directory entered, using default: $PANEL_INSTALL_DIR"
      fi
    else
      output "Using default Panel installation directory: $PANEL_INSTALL_DIR"
    fi
    panel_dir_prompted=true # Mark that we've prompted
  fi

  [[ "$1" == *"canary"* ]] && export GITHUB_SOURCE="master" && export SCRIPT_RELEASE="canary"
  update_lib_source

  local main_action_original="$1" # Save original first argument
  local main_action="${1//_canary/}"
  local next_action_original="$2" # Save original second argument
  local next_action=""
  [[ -n "$2" ]] && next_action="${2//_canary/}"

  if [[ "$main_action" == "panel" ]]; then
    # Pass PANEL_INSTALL_DIR as env var
    PANEL_INSTALL_DIR="$PANEL_INSTALL_DIR" run_ui "$main_action" |& tee -a $LOG_PATH
  else
    run_ui "$main_action" |& tee -a $LOG_PATH
  fi

  if [[ -n "$next_action" ]]; then
    echo -e -n "* Installation of $main_action completed. Do you want to proceed to $next_action installation? (y/N): "
    read -r CONFIRM
    if [[ "$CONFIRM" =~ [Yy] ]]; then
      # Pass the original next action (e.g., "panel_canary")
      execute "$next_action_original" ""
    else
      error "Installation of $next_action aborted."
      exit 1
    fi
  fi
}

welcome ""

# Array defining the available installation options for the main menu.
# Each string represents an option that will be displayed to the user.
readonly menu_options=(
  "Install the panel (optionally custom directory)"
  "Install Wings"
  "Install both Panel (optionally custom directory) and Wings"
  # "Uninstall panel or wings\n" # Example of a commented-out option

  "Install panel (optionally custom directory) with canary version"
  "Install Wings with canary version"
  "Install both Panel (optionally custom directory) and Wings with canary versions"
  "Uninstall panel or wings with canary version"
)

# Array mapping menu option indexes to specific actions or action pairs.
# Actions can be single (e.g., "panel") or combined (e.g., "panel;wings").
# The order must correspond to the 'menu_options' array.
readonly menu_actions=(
  "panel"
  "wings"
  "panel;wings" # semicolon is used to denote a sequence of actions
  # "uninstall"

  "panel_canary"
  "wings_canary"
  "panel_canary;wings_canary"
  "uninstall_canary"
)

# Function to display the main installation menu.
# It iterates over the 'menu_options' array and prints each option.
display_main_menu() {
  output "What would you like to do?"
  for i in "${!menu_options[@]}"; do
    output "[$i] ${menu_options[$i]}"
  done
}

# Function to handle the user's selected action.
# It validates the input and then calls the 'execute' function with the appropriate actions.
# Arguments:
#   $1: The user's input (selected action number).
# Returns:
#   0 if the action was successfully initiated.
#   1 if the input was invalid or empty, allowing the loop to continue.
handle_action() {
  local selected_index="$1"
  local primary_action=""
  local secondary_action=""

  if [ -z "$selected_index" ]; then
    error "Input is required. Please enter a number." # lib.sh error will log this
    return 1 # Indicate failure to allow loop to continue
  fi

  # Validate if the input is a valid number within the allowed range.
  local valid_indices=("$(for ((i = 0; i < ${#menu_actions[@]}; i += 1)); do echo "${i}"; done)")
  if [[ ! " ${valid_indices[*]} " =~ ${selected_index} ]]; then
    error "Invalid option: '$selected_index'. Please select a number from the list." # lib.sh error will log this
    return 1 # Indicate failure
  fi

  # Retrieve the action string (e.g., "panel" or "panel;wings")
  local action_string="${menu_actions[$selected_index]}"

  # Split the action string if it contains a semicolon, indicating multiple actions.
  # e.g., "panel;wings" becomes primary_action="panel", secondary_action="wings".
  IFS=";" read -r primary_action secondary_action <<<"$action_string"

  execute "$primary_action" "$secondary_action"
  return 0 # Indicate success
}

# Main script loop: displays the menu, gets user input, and handles the action.
# The loop continues until a valid action is successfully initiated by 'handle_action'.
keep_looping=true
while [ "$keep_looping" == true ]; do
  display_main_menu

  echo -n "* Input 0-$((${#menu_actions[@]} - 1)): "
  read -r user_choice

  # handle_action returns 0 on success (meaning execute was called and loop can stop),
  # or 1 on input error (meaning loop should continue).
  if handle_action "$user_choice"; then
    keep_looping=false # Valid action taken, exit loop
  else
    # If handle_action indicated an error, the loop continues automatically.
    # An additional message or pause could be added here if desired.
    output "Please try again." # Optional: give user a moment or more context
    echo "" # Add a blank line for readability before re-displaying menu
  fi
done

# Remove lib.sh, so next time the script is run the, newest version is downloaded.
rm -rf /tmp/lib.sh
