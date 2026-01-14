#!/bin/bash

# ==========================================
# SentinelFW v2
# Basic UFW Firewall Automation
# Author: Kamalesh S
# ==========================================

THEME="neon"

set_theme() {
  RED='\033[1;35m'
  GREEN='\033[1;36m'
  YELLOW='\033[1;93m'
  CYAN='\033[1;96m'
  RESET='\033[0m'
}

set_theme
LOGFILE="$HOME/aegis-fw.log"

log() {
  echo "[$(date)] $1" >> "$LOGFILE"
}

enable_fw() {
  sudo ufw enable
  log "Firewall enabled"
}

allow_ports() {
  sudo ufw allow ssh
  sudo ufw allow http
  sudo ufw allow https
  log "Allowed SSH, HTTP, HTTPS"
}

limit_ssh() {
  sudo ufw limit ssh
  log "Enabled SSH rate limiting"
}

detect_bruteforce() {
  echo -e "${YELLOW}Scanning for SSH brute-force attempts...${RESET}"
  sudo grep "Failed password" /var/log/auth.log |
  awk '{print $(NF-3)}' |
  sort | uniq -c | sort -nr |
  while read count ip; do
    if [[ $count -ge 5 ]]; then
      sudo ufw deny from "$ip"
      log "Blocked IP $ip after $count failed attempts"
    fi
  done
}

menu() {
  clear
  echo -e "${CYAN}🛡️ SentinelFW v2${RESET}"
  echo "1) Enable Firewall"
  echo "2) Allow Common Ports"
  echo "3) Enable SSH Rate Limit"
  echo "4) Detect SSH Brute Force"
  echo "5) Exit"
}

while true; do
  menu
  read -p "Choose: " c

  case $c in
    1) enable_fw ;;
    2) allow_ports ;;
    3) limit_ssh ;;
    4) detect_bruteforce ;;
    5) exit ;;
  esac

  sleep 1
done
