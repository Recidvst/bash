#  ALIASES
# ===========

# alias ls to print more usefully
alias ll="ls -ltah"
# alias cat to bat
alias cat="bat"
# print public IP
alias myip="curl ipinfo.io/ip; echo -e '\r'"
# fortune + cowsay
alias cow="fortune | cowsay -b"
# arttime
alias artime="arttime --nolearn --ac 4 -a skyline -t \"\$(fortune | sed  -e :a -e 's/^.\{1,213\}\$/ & /;ta')\""

#  SPLASH
# ===========

echo -e "\n"

neofetch --memory_percent on --memory_unit gib --shell_path on --color_blocks off --ascii_distro openSUSE

echo -e "\n"

#  PROMPTS
# ===========

PS1="\$(check_network_status)\[\e[2;37m\]\t\[\e[m\] \[\e[2;36m\]\u\[\e[m\] \[\e[0;34m\] \W\[\e[m\]\$(parse_git_branch)\$(parse_git_dirty)\$(check_jobs) \[\e[35m\]\$(show_sdk_versions)\[\e[m\]\[\e[5;37m\]\[\e[m\] "
PS1+=$'\n'

PS2="\[\e[5;31m\] "
PS3="\[\e[5;34m\] "
PS4="\[\e[37m\] "

# SCREENSAVERS
# ===========

alias pipes='bash ~/pipes.sh'

#  FUNCTIONS
# ===========

function parse_git_dirty {
  STATUS="$(git status 2> /dev/null)"
  if [[ $? -ne 0 ]]; then
    printf ""; return 1
  else
    if echo "${STATUS}" | grep -Eq "(renamed:|branch is ahead:|new file:|Untracked files:|modified:|deleted:)" &> /dev/null; then
      printf "\e[1;31m \e[m"
    else
      printf "\e[1;32m \e[m"
    fi
  fi
  return 0
}

function parse_git_branch {
  BRANCH=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
  if [[ -n "$BRANCH" ]]; then
    printf "\e[1;35m  $BRANCH \e[m"
  fi
}

function check_jobs {
  # Get the number of jobs
  job_count=$(jobs -p | wc -l)

  # Check if there is one or more jobs
  if [ "$job_count" -gt 0 ]; then
    # Print an icon (you can replace the icon with any symbol you prefer)
    printf "\e[5;33m󰜎$job_count\e[m"
  else
    # Print nothing if there are zero jobs
    printf ""
  fi
}

function watch() {
  ARGS="${@}"
  clear;
  while(true); do
    OUTPUT=$($ARGS)
    for i in {1..25}; do
      printf '\e[1A\e[K'
    done
    echo -e "${OUTPUT[@]}"
    sleep 1
  done
}

# Function to check network status
CACHE_FILE="/tmp/network_status_cache"
check_network_status() {
  local current_time=$(date +%s)
  local cache_time=0
  local cache_status=""

  if [[ -f $CACHE_FILE ]]; then
    cache_time=$(stat -c %Y "$CACHE_FILE")
    cache_status=$(cat "$CACHE_FILE")
  fi

  # Cache validity duration (5 minutes = 300 seconds)
  local cache_duration=300

  # If the cache is older than 5 minutes, update it
  if (( current_time - cache_time > cache_duration )); then
    if ping -c 1 8.8.8.8 &> /dev/null; then
      echo -e "Online" > "$CACHE_FILE"
      cache_status="Online"
    else
      echo -e "Offline" > "$CACHE_FILE"
      cache_status="Offline"
    fi
  fi

  # Print the cached status with color
  if [[ $cache_status == "Online" ]]; then
    echo -e "\e[1;32m󰖩 \e[m"
  else
    echo -e "\e[1;31m󱚼 \e[m"
  fi
}

function show_hostname {
  hostname=$(hostname)
  echo -e "@$hostname"
}

function show_sdk_versions() {
  local versions=""

  # Check if we're in a Git repository
  if git rev-parse --is-inside-work-tree &> /dev/null; then

    # Check if Node.js is installed and if package.json exists
    if command -v node &> /dev/null && git ls-files --error-unmatch '*.js' &> /dev/null; then
      versions+="Node: $(nvm current) "
    fi

    # Check if Python is installed
    if command -v python &> /dev/null && git ls-files --error-unmatch '*.py' &> /dev/null; then
      versions+="Python: $(python --version | awk '{print $2}') "
    fi

    # Check if .NET is installed
    if command -v dotnet &> /dev/null && git ls-files --error-unmatch '*.cs' &> /dev/null; then
      versions+=".NET: $(dotnet --version) "
    fi

    # Go version if installed
    if command -v go &> /dev/null && git ls-files --error-unmatch '*.go' &> /dev/null; then
      versions+="Go: $(go version | awk '{print $3}') "
    fi

  fi

  echo -n "$versions"
}

# Following line was automatically added by arttime installer
export MANPATH=/home/csnowden/.local/share/man:$MANPATH

# Following line was automatically added by arttime installer
export PATH=/home/csnowden/.local/bin:$PATH
