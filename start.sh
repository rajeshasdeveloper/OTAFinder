#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# --- SETTINGS ---
B_SH_URL="https://raw.githubusercontent.com/EvGRaF87/OTAFinder/refs/heads/main/real.sh"
# --- END OF SETTINGS ---

# Colors
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
RED="\e[31m"
RESET="\e[0m"

# Paths
OTA_DIR="$HOME/OTA"
B_SH_PATH="$OTA_DIR/real.sh"
REALME_OTA_BIN="/data/data/com.termux/files/usr/bin/realme-ota"

# Error output
handle_error() {
    echo -e "\n${RED}ERROR: $1${RESET}"
    echo -e "${YELLOW}Installation aborted.${RESET}"
    exit 1
}

# --- START OF SCRIPT ---
clear
echo -e "${BLUE}=====================================================${RESET}"
echo -e "${BLUE}==        OTAFindeR Automatic Installer            ==${RESET}"
echo -e "${BLUE}=====================================================${RESET}"
echo ""
echo -e "${YELLOW}This script will automatically download and configure everything you need.${RESET}"
read -p "Press [Enter] to start..."

# --- Step 1: Setting up storage and updating packages ---
echo -e "\n${GREEN}>>> Step 1: Setting up storage and updating the system...${RESET}"
termux-setup-storage
mkdir -p "$OTA_DIR" || handle_error "Failed to create folder $OTA_DIR."

DPKG_OPTIONS="-o Dpkg::Options::=--force-confold"
pkg update -y || handle_error "Failed to update package lists."
pkg upgrade -y $DPKG_OPTIONS || handle_error "Failed to upgrade packages."
echo -e "${GREEN}Termux system updated successfully.${RESET}"

# --- Step 2: Installing dependencies ---
echo -e "\n${GREEN}>>> Step 2: Installing system packages (python, git, tsu)...${RESET}"
pkg install -y $DPKG_OPTIONS python python2 git tsu curl || handle_error "Failed to install system packages."
echo -e "${GREEN}All system packages are installed.${RESET}"

# --- Step 3: Installing Python modules ---
echo -e "\n${GREEN}>>> Step 3: Installing Python modules...${RESET}"
pip install --upgrade pip wheel pycryptodome || handle_error "Failed to install wheel or pycryptodome."
pip3 install --upgrade requests pycryptodome git+https://github.com/R0rt1z2/realme-ota || handle_error "Failed to install realme-ota."

# Permissions
if [ -f "$REALME_OTA_BIN" ]; then
    echo -e "${BLUE}Assigning execute permissions for realme-ota...${RESET}"
    chmod +x "$REALME_OTA_BIN"
else
    echo -e "${YELLOW}WARNING: File $REALME_OTA_BIN not found. Possible problems in operation.${RESET}"
fi
echo -e "${GREEN}Python modules successfully installed and configured.${RESET}"

# --- Step 4: Downloading the script ---
echo -e "\n${GREEN}>>> Step 4: Downloading the script (real.sh)...${RESET}"

if [ ! -d "$OTA_DIR" ]; then
  mkdir -p "$OTA_DIR"
  if [ $? -eq 0 ]; then
    echo "Created '$OTA_DIR' folder."
  else
    echo "Error creating folder '$OTA_DIR'."
    exit 1
  fi
else
  echo "Folder '$OTA_DIR' already exists."
fi

curl -sL "$B_SH_URL" -o "$B_SH_PATH"

if [ $? -ne 0 ]; then
    handle_error "Failed to download the real.sh script!"
fi
if [ ! -f "$B_SH_PATH" ] || [ ! -s "$B_SH_PATH" ]; then
    handle_error "The real.sh file was not downloaded or is empty! Check the URL and internet connection."
fi
echo -e "${GREEN}The real.sh script was successfully downloaded to $B_SH_PATH${RESET}"

# --- Step 5: Creating the device list realme.txt ---
echo -e "\n${GREEN}>>> Step 5: Creating the device list realme.txt...${RESET}"
TXT_DIR="$HOME/"
TXT_FILE="$TXT_DIR/realme.txt"

chmod 700 -R "$TXT_DIR"

echo -e "${BLUE}Creating file: $TXT_FILE...${RESET}"
{
echo "Realme GTNeo6|RMX3852|97|C"
echo "Realme GTNeo6SE|RMX3850|97|C"
echo "Realme GT6|RMX3851IN|1B|C"
echo "Realme GT6T|RMX3853IN|1B|C"
echo "Realme GT6|RMX3851EEA|44|C"
echo "Realme GT6T|RMX3853EEA|44|C"
echo "Realme GT6|RMX3851RU|37|C"
echo "Realme GT6T|RMX3853RU|37|C"
echo "Realme GT7Pro RE|RMX5090|97|A"
echo "Realme GT7Pro|RMX5010|97|A"
echo "Realme GT7Pro|RMX5011IN|1B|A"
echo "Realme GT7Pro|RMX5011EEA|44|A"
echo "Realme GT7Pro|RMX5011RU|37|A"
echo "Realme GT5Pro|RMX3888|97|C"
echo "Realme GT6CN|RMX3800|97|C"
echo "Realme GTNeo5 150W|RMX3706|97|F"
echo "Realme GTNeo5 240W|RMX3708|97|F"
echo "Realme GTNeo5SE|RMX3700|97|F"
echo "Realme GT3 RU|RMX3709RU|37|F"
echo "Realme GTNeo5SE|RMX3701|A6|F"
} > "$TXT_FILE"

chmod +x "$TXT_FILE"
echo -e "${GREEN}File 'realme.txt' created successfully!${RESET}"

# --- Step 6: Creating a shortcut for the widget ---
echo -e "\n${GREEN}>>> Step 6: Automatically creating a shortcut...${RESET}"
SHORTCUT_DIR="$HOME/.shortcuts"
SHORTCUT_FILE="$SHORTCUT_DIR/FindeReal"
mkdir -p "$SHORTCUT_DIR"
chmod 700 -R "$SHORTCUT_DIR"

echo -e "${BLUE}Creating shortcut file: $SHORTCUT_FILE...${RESET}"

cat "$B_SH_PATH" >> "$SHORTCUT_FILE"

chmod +x "$SHORTCUT_FILE"
echo -e "${GREEN}Shortcut 'FindeReal' created successfully!${RESET}"

# --- COMPLETION ---
clear
echo -e "${GREEN}=============================================${RESET}"
echo -e "${GREEN}  🎉 Installation completed successfully! 🎉 ${RESET}"
echo -e "${GREEN}=============================================${RESET}"
echo ""
echo -e "${YELLOW}What to do next:${RESET}"
echo "1. Completely close the Termux application (with the 'exit' command)."
echo "2. Go to your phone's home screen."
echo "3. Add the 'Termux' widget."
echo "4. 'FindeReal' should appear in the list of available shortcuts."
echo "5. Click on it to run the update search script."
echo ""
echo -e "${BLUE}With you was${RESET}" "${RED}SeRViP!${RESET}"
