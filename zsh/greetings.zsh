terminal_greeting() {
  [[ $- != *i* ]] && return

  local art_file="$HOME/dotfiles/zsh/arts/penguim.txt"
  [[ -r "$art_file" ]] || return

  local os kernel uptime wm terminal memory disk cpu
  local uptime_raw line
  integer uptime_s days hours minutes art_width=0
  local -a art info

  os=$(. /etc/os-release && echo "$PRETTY_NAME")
  kernel="$(uname -r)"

  read -r uptime_raw _ < /proc/uptime
  uptime_s="${uptime_raw%%.*}"

  days=$(( uptime_s / 86400 ))
  hours=$(( (uptime_s % 86400) / 3600 ))
  minutes=$(( (uptime_s % 3600) / 60 ))

  if (( days > 0 )); then
    uptime="${days}d ${hours}h ${minutes}m"
  elif (( hours > 0 )); then
    uptime="${hours}h ${minutes}m"
  else
    uptime="${minutes}m"
  fi

  wm="${XDG_CURRENT_DESKTOP:-Hyprland}"
  terminal="${TERM_PROGRAM:-${TERM:-unknown}}"

  memory="$(free -h | awk '/^Mem:/ {print $3 " / " $2}')"
  disk="$(df -h / | awk 'NR==2 {print $3 " / " $2 " (" $5 ")"}')"

  cpu="$(
    awk -F ': ' '/model name/ {
      print $2
      exit
    }' /proc/cpuinfo
  )"

  while IFS= read -r line || [[ -n "$line" ]]; do
    art+=("$line")
    (( ${#line} > art_width )) && art_width=${#line}
  done < "$art_file"

  info=(
    "  ${USER}@$(hostname)"
    "󱄅  $os"
    "  $kernel"
    "󰅐  $uptime"
    "  $wm"
    "  $terminal"
    "  $cpu"
    "  $memory"
    "  $disk"
  )

  integer rows=${#art[@]}
  (( ${#info[@]} > rows )) && rows=${#info[@]}

  printf '\n'

  for (( i = 1; i <= rows; i++ )); do
    printf '  %-*s   %s\n' \
      "$art_width" \
      "${art[i]:-}" \
      "${info[i]:-}"
  done

  printf '\n'
}

terminal_greeting
