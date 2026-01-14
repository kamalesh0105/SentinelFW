#!/bin/bash

# ==========================================
# SentinelFW v1
# Basic UFW Firewall Automation
# Author: Kamalesh S
# ==========================================

RED='\033[1;31m'
GREEN='\033[1;32m'
CYAN='\033[1;36m'
RESET='\033[0m'

LOGFILE="$HOME/aegis-fw.log"

enable_fw() {
  sudo ufw enable
  echo "[INFO] Firewall enabled" >> "$LOGFILE"
}

disable_fw() {
  sudo ufw disable
}

allow_ports() {
  sudo ufw allow 22
  sudo ufw allow 80
  sudo ufw allow 443
}

block_ports() {
  sudo ufw deny 21
  sudo ufw deny 23
  sudo ufw deny 3306
}

while true; do
  clear
  echo -e "${CYAN}SentinelFW v1${RESET}"
  echo "1) Enable Firewall"
  echo "2) Disable Firewall"
  echo "3) Allow Common Ports"
  echo "4) Block Insecure Ports"
  echo "5) Exit"
  read -p "Choose: " c

  case $c in
    1) enable_fw ;;
    2) disable_fw ;;
    3) allow_ports ;;
    4) block_ports ;;
    5) exit ;;
  esac

  sleep 1
done
