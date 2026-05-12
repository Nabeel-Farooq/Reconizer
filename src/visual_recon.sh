#!/usr/bin/env bash

set -Eeuo pipefail

# =========================
# Colors
# =========================
readonly red="$(tput setaf 1)"
readonly green="$(tput setaf 2)"
readonly yellow="$(tput setaf 3)"
readonly blue="$(tput setaf 4)"
readonly magenta="$(tput setaf 5)"
readonly reset="$(tput sgr0)"

# =========================
# Constants
# =========================
readonly HTTP_TIMEOUT=10000
readonly SCAN_TIMEOUT=300
readonly PORT_RANGE="xlarge"

# =========================
# Error Handler
# =========================
trap 'echo "${red}[-] Script failed at line $LINENO${reset}"' ERR

# =========================
# User Input
# =========================
read -rp "Enter domain name: " DOM

DOM="${DOM,,}"

if [[ -z "$DOM" ]]; then
  echo "${red}[-] Domain name cannot be empty${reset}"
  exit 1
fi

# =========================
# Paths
# =========================
readonly BASE_DIR="$HOME/reconizer/$DOM"
readonly VISUAL_RECON_DIR="$BASE_DIR/Visual_Recon"
readonly SUBDOMAIN_FILE="$BASE_DIR/Subdomains/unique.txt"

# =========================
# Create Required Directories
# =========================
mkdir -p "$VISUAL_RECON_DIR"

# =========================
# Banner
# =========================
printf "%s\n" "${red}
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

if [[ ! -s "$SUBDOMAIN_FILE" ]]; then
  echo "${red}[-] Subdomain file is empty${reset}"
  exit 1
fi

# =========================
# Dependency Check
# =========================
echo "${yellow}---------------------------------- xxxxxxxx ----------------------------------${reset}"
echo

if ! command -v go >/dev/null 2>&1; then
  echo "${red}[-] Golang is not installed${reset}"
  exit 1
fi

if ! command -v aquatone >/dev/null 2>&1; then
  echo "${blue}[+] Aquatone not found. Installing...${reset}"

  GO111MODULE=on go install github.com/michenriksen/aquatone@latest

  export PATH="$PATH:$HOME/go/bin"

  if ! command -v aquatone >/dev/null 2>&1; then
    echo "${red}[-] Failed to install Aquatone${reset}"
    exit 1
  fi
fi

# =========================
# Run Aquatone
# =========================
echo "${magenta}[+] Running Aquatone for screenshotting alive subdomains${reset}"

aquatone \
  -http-timeout "$HTTP_TIMEOUT" \
  -scan-timeout "$SCAN_TIMEOUT" \
  -ports "$PORT_RANGE" \
  -out "$VISUAL_RECON_DIR" \
  < "$SUBDOMAIN_FILE"

# =========================
# Completion
# =========================
echo
echo "${yellow}---------------------------------- xxxxxxxx ----------------------------------${reset}"
echo
echo "${green}[+] Successfully saved the results${reset}"
echo "${green}[+] Output directory:${reset} $VISUAL_RECON_DIR"
echo
echo "${red}[+] Thank you for using R3C0Nizer${reset}"
echo
echo "${yellow}---------------------------------- xxxxxxxx ----------------------------------${reset}"
