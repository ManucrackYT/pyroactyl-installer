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

# Check if script is loaded, load if not or fail otherwise.
fn_exists() { declare -F "$1" >/dev/null; }
if ! fn_exists lib_loaded; then
  # shellcheck source=lib/lib.sh
  source /tmp/lib.sh || source <(curl -sSL "$GITHUB_BASE_URL/$GITHUB_SOURCE"/lib/lib.sh)
  ! fn_exists lib_loaded && echo "* ERROR: Could not load lib script" && exit 1
fi

