#!/bin/bash

# ==========================================================
# 🛡️ SentinelFW
# Author  : Kamalesh S
# Purpose : Linux Firewall Automation & Intrusion Detection
# ==========================================================

# ---------------- THEME ----------------
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RESET='\033[0m'

LOGFILE="$HOME/sentinelfw.log"

# ---------------- LOGO ----------------
print_logo() {
clear
echo -e "${CYAN}"
cat << "EOF"
███████╗███████╗███╗   ██╗████████╗██╗███╗   ██╗███████╗██╗     
██╔════╝██╔════╝████╗  ██║╚══██╔══╝██║████╗  ██║██╔════╝██║     
███████╗█████╗  ██╔██╗ ██║   ██║   ██║██╔██╗ ██║█████╗  ██║     
╚════██║██╔══╝  ██║╚██╗██║   ██║   ██║██║╚██╗██║██╔══╝  ██║     
███████║███████╗██║ ╚████║   ██║   ██║██║ ╚████║███████╗███████╗
╚══════╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝
 Host-Based Firewall Automation & Intrusion Detection
EOF
echo -e "${RESET}"
}

# ---------------- UTIL ----------------
log() {
  echo "[$(date)] $1" >> "$LOGFILE"
}

pause() {
  read -p "Press Enter to continue..."
}

# ---------------- FIREWALL OPS ----------------
enable_firewall() {
  sudo ufw enable
  log "Firewall enabled"
}

disable_firewall() {
  sudo ufw disable
  log "Firewall disabled"
}

allow_common_ports() {
  sudo ufw allow ssh
  sudo ufw allow http
  sudo ufw allow https
  log "Allowed SSH, HTTP, HTTPS"
}

block_insecure_ports() {
  sudo ufw deny 21
  sudo ufw deny 23
  sudo ufw deny 3306
  log "Blocked FTP, Telnet, MySQL"
}

enable_ssh_rate_limit() {
  sudo ufw limit ssh
  log "Enabled SSH rate limiting"
}

enable_firewall_logging() {
  sudo ufw logging on
  log "Firewall logging enabled"
}

# ---------------- ATTACK DETECTION ----------------
detect_ssh_bruteforce() {
  echo -e "${YELLOW}[+] Scanning for SSH brute-force attempts...${RESET}"
  sudo grep "Failed password" /var/log/auth.log 2>/dev/null | \
  awk '{print $(NF-3)}' | sort | uniq -c | sort -nr | \
  while read count ip; do
    if [[ $count -ge 5 ]]; then
      sudo ufw deny from "$ip"
      log "Blocked IP $ip after $count failed SSH attempts"
      echo -e "${RED}[BLOCKED] $ip (${count} attempts)${RESET}"
    fi
  done
}

# ---------------- MENU ----------------
menu() {
print_logo
echo -e "${CYAN}1)${RESET} Enable Firewall"
echo -e "${CYAN}2)${RESET} Disable Firewall"
echo -e "${CYAN}3)${RESET} Allow Common Ports (22,80,443)"
echo -e "${CYAN}4)${RESET} Block Insecure Ports (21,23,3306)"
echo -e "${CYAN}5)${RESET} Enable SSH Rate Limiting"
echo -e "${CYAN}6)${RESET} Enable Firewall Logging"
echo -e "${CYAN}7)${RESET} Detect & Block SSH Brute Force"
echo -e "${CYAN}8)${RESET} Show Firewall Status"
echo -e "${CYAN}9)${RESET} Exit"
echo
}

# ---------------- MAIN LOOP ----------------
while true; do
menu
read -p "Choose an option: " choice

case $choice in
  1) enable_firewall ;;
  2) disable_firewall ;;
  3) allow_common_ports ;;
  4) block_insecure_ports ;;
  5) enable_ssh_rate_limit ;;
  6) enable_firewall_logging ;;
  7) detect_ssh_bruteforce ;;
  8) sudo ufw status verbose ; pause ;;
  9) echo -e "${GREEN}Exiting SentinelFW. Stay Secure.${RESET}"; exit ;;
  *) echo -e "${RED}Invalid option${RESET}" ;;
esac

sleep 1
done
