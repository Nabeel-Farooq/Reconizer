#!/usr/bin/env bash

set -euo pipefail

# =========================
# Colors
# =========================
red="$(tput setaf 1)"
green="$(tput setaf 2)"
yellow="$(tput setaf 3)"
blue="$(tput setaf 4)"
magenta="$(tput setaf 5)"
reset="$(tput sgr0)"

# =========================
# User Input
# =========================
read -rp "Enter domain name: " DOM

# =========================
# Paths
# =========================
BASE_DIR="$HOME/reconizer/$DOM"
VISUAL_RECON_DIR="$BASE_DIR/Visual_Recon"
SUBDOMAIN_FILE="$BASE_DIR/Subdomains/unique.txt"

# =========================
# Create Required Directories
# =========================
mkdir -p "$VISUAL_RECON_DIR"

# =========================
# Banner
# =========================
echo "${red}
 =================================================
|   ____  _____  ____ ___  _   _ _                |
|  |  _ \|___ / / ___/ _ \| \ | (_)_______ _ __   |
|  | |_) | |_ \| |  | | | |  \| | |_  / _ \ '__|  |
|  |  _ < ___) | |__| |_| | |\  | |/ /  __/ |     |
|  |_| \_\____/ \____\___/|_| \_|_/___\___|_|     |
|                                                 |
 ================== Anon-Artist ==================
${reset}"

echo "${blue}[+] Starting Visual Recon${reset}"
echo

# =========================
# Validation
# =========================
if [[ ! -f "$SUBDOMAIN_FILE" ]]; then
  echo "${red}[-] Subdomain file not found:${reset} $SUBDOMAIN_FILE"
  exit 1
fi

# =========================
# Aquatone Check
# =========================
echo "${yellow}---------------------------------- xxxxxxxx ----------------------------------${reset}"
echo

if ! command -v aquatone >/dev/null 2>&1; then
  echo "${blue}[+] Aquatone not found. Installing...${reset}"

  go install github.com/michenriksen/aquatone@latest

  export PATH="$PATH:$HOME/go/bin"
fi

# =========================
# Run Aquatone
# =========================
echo "${magenta}[+] Running Aquatone for screenshotting alive subdomains${reset}"

aquatone \
  -http-timeout 10000 \
  -scan-timeout 300 \
  -ports xlarge \
  -out "$VISUAL_RECON_DIR" \
  < "$SUBDOMAIN_FILE"

# =========================
# Completion
# =========================
echo
echo "${yellow}---------------------------------- xxxxxxxx ----------------------------------${reset}"
echo
echo "${green}[+] Successfully saved the results${reset}"
echo
echo "${red}[+] Thank you for using R3C0Nizer${reset}"
echo
echo "${yellow}---------------------------------- xxxxxxxx ----------------------------------${reset}"
