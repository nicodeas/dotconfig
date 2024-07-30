#!/bin/bash

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

# WIP for when I add linux installation
if [[ "$OSTYPE" == "darwin"* ]]; then
  check_install_homebrew
else
  echo -e "${RED}INSTALLSCRIPT NOT AVAILABLE FOR OS"
  exit 1
fi

check_install_neovim(){
    if [ -x "$(command -v nvim)" ]; then
        echo -e "${GREEN}Neovim${CLEAR} is already installed."
    else
        echo -en "${YELLOW}Neovim${CLEAR} is not installed. Do you want to install it? (y/n): "
        read -r choice
        if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
          echo "Installing Neovim..."
          if [[ $MAC_OS ]]; then
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
      echo -en "${GREEN}NVM${CLEAR} is not installed. Do you want to install it? (y/n): " 
      read -r choice
      if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
        echo "Installing NVM..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
      else
        echo "${YELLOW}Installation of NVM skipped.${CLEAR}"
      fi
  fi
}

check_installation() {
    if [ -x "$(command -v "$1")" ]; then
        echo -e "${GREEN}$1${CLEAR} is already installed."
    else
        echo
        echo -en "${YELLOW}$1${CLEAR} is not installed. Do you want to install it? (y/n): "
        read -r choice
        if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
          echo "Installing $1..."
          brew install "$1"
        else
          echo -e "${YELLOW}Installation of $1 skipped.${CLEAR}"
          echo
        fi
    fi
}

software_list=( "pyenv"
                "docker"
                "tmux"
                "fzf"
                "lazygit"
                "stow"
                "wezterm"
                "jq"
                "yq"
                "zoxide"
                "eza"
              )

for software in "${software_list[@]}"; do
    check_installation "$software"
done

setup_shell(){
  if [ ! -d "$HOME/.oh-my-zsh/" ]; then

    echo
    echo -e "${YELLOW}oh my zsh has not been setup.${CLEAR}"
    echo -en "Set up ${GREEN}Oh-My-Zsh${CLEAR}? (y/n) "
    read -r choice

    if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
      # install oh-my-zsh
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
      # zsh-autosuggestions
      git clone "https://github.com/zsh-users/zsh-autosuggestions" "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
      # zsh-syntax-highlighting
      git clone "https://github.com/zsh-users/zsh-syntax-highlighting.git" "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
      check_installation "starship"
    else
      echo -e "${YELLOW}SKIPPED${CLEAR}"
    fi

  else
    echo -e "${GREEN}oh my zsh${CLEAR} has already been setup"
  fi
}

check_install_neovim
check_install_nvm
setup_shell

echo

cd "$HOME/dotconfig" || exit 1

for file in "$HOME/dotconfig"/*; do
  if [ -d "${file}" ]; then
    echo -n "Create symlink for $(basename "$file")? (y/n): "
    read -r choice
    if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
      stow "$(basename "$file")"
      echo -e "${GREEN}$(basename "$file")${CLEAR} symlink ${GREEN}created${CLEAR}"
      echo
    else
      echo -e "${YELLOW}SKIPPED${CLEAR}"
      echo
    fi
  fi
done
