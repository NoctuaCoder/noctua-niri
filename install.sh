#!/usr/bin/env bash
set -e

echo "=================================================="
echo "    Instalador Oficial - Noctua-Niri Dotfiles     "
echo "    (Com suporte a Waybar e Quickshell QML)       "
echo "=================================================="

# Detect package manager
if command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
elif command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
else
    PKG_MANAGER="unknown"
fi

echo "[*] Gerenciador de pacotes detectado: $PKG_MANAGER"

if [ "$PKG_MANAGER" = "pacman" ]; then
    echo "[*] Instalando dependências essenciais via pacman (Arch Linux / Arch-based)..."
    sudo pacman -S --needed niri waybar fuzzel swaync swww kitty grim slurp wl-clipboard brightnessctl pavucontrol ttf-jetbrains-mono-nerd quickshell-git || {
        echo "[!] Quickshell-git pode requerer AUR (ex: yay -S quickshell-git)."
    }
elif [ "$PKG_MANAGER" = "apt" ]; then
    echo "[!] Certifique-se de ter niri, waybar, fuzzel e quickshell instalados."
else
    echo "[!] Instale manualmente: niri, waybar, fuzzel, quickshell, kitty, swww."
fi

echo "[*] Criando diretórios de configuração..."
mkdir -p ~/.config/niri
mkdir -p ~/.config/waybar
mkdir -p ~/.config/quickshell

echo "[*] Copiando arquivos de configuração para ~/.config/..."
cp -r .config/niri/* ~/.config/niri/
cp -r .config/waybar/* ~/.config/waybar/

if [ -d "shell" ]; then
    echo "[*] Copiando arquivos da Noctua-Shell (Quickshell)..."
    cp -r shell/* ~/.config/quickshell/
fi

echo "=================================================="
echo "   Instalação concluída com sucesso!"
echo "   Inicie o Niri e execute 'quickshell' para a UI QML."
echo "=================================================="
