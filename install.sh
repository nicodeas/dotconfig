#!/bin/bash

echo "Cloning dotfiles"
git clone --recursive https://github.com/nicodeas/dotconfig.git $HOME/dotconfig

MAC_OS=false

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CLEAR='\033[0m'

check_install_homebrew() {
    if [[ $(command -v brew) ]]; then
        echo -e "${GREEN}Homebrew${CLEAR} is already installed."
    else
        echo "Homebrew is not installed. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [[ $(command -v brew) ]]; then
            echo "Homebrew has been installed successfully."
        else
            echo "${RED}Failed to install Homebrew.${CLEAR}"
        fi
    fi
}

if [[ "$OSTYPE" == "darwin"* ]]; then
  MAC_OS=true
  check_install_homebrew
fi

check_install_neovim(){
    if [ -x "$(command -v nvim)" ]; then
        echo -e "${GREEN}Neovim${CLEAR} is already installed."
    else
        read -p "Neovim is not installed. Do you want to install it? (y/n): " choice
        if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
          echo "Installing Neovim..."
          if [[ MAC_OS ]]; then
            brew install neovim
          else
            echo "Installation not configured for Linux"
          fi
        else
          echo "${YELLOW}Installation of Neovim skipped.${CLEAR}"
        fi
    fi
}

check_install_nvm(){
  if [[ -s "$HOME/.nvm/" ]]; then
        echo -e "${GREEN}NVM${CLEAR} is already installed."
  else
      read -p "NVM is not installed. Do you want to install it? (y/n): " choice
      if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
        echo "Installing NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
      else
        echo "${YELLOW}Installation of NVM skipped.${CLEAR}"
      fi
  fi
}

check_installation() {
    if [ -x "$(command -v $1)" ]; then
        echo -e "${GREEN}$1${CLEAR} is already installed."
    else
        read -p "$1 is not installed. Do you want to install it? (y/n): " choice
        if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
          echo "Installing $1..."
          brew install $1
        else
          echo -e "${YELLOW}Installation of $1 skipped.${CLEAR}"
        fi
    fi
}

software_list=("git" "pyenv" "docker" "tmux" "fzf" "lazygit" "stow")

for software in "${software_list[@]}"; do
    check_installation "$software"
done

check_install_neovim
check_install_nvm

cd $HOME/dotconfig
echo "Creating Symlinks"
echo

stow */
