#!/usr/bin/env bash
set -e

echo "=================================================="
echo "    Instalador Oficial - Noctua-Niri Dotfiles     "
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
    sudo pacman -S --needed niri waybar fuzzel swaync swww mako kitty grim slurp wl-clipboard brightnessctl pamixer pavucontrol ttf-jetbrains-mono-nerd
elif [ "$PKG_MANAGER" = "apt" ]; then
    echo "[!] O Niri e componentes Wayland mais recentes são recomendados no Arch Linux ou Fedora."
    echo "[!] Certifique-se de ter niri, waybar, fuzzel e swww instalados manualmente na sua distro."
else
    echo "[!] Gerenciador não suportado automaticamente. Por favor instale: niri, waybar, fuzzel, swww, swaync, kitty."
fi

echo "[*] Criando diretórios de configuração..."
mkdir -p ~/.config/niri
mkdir -p ~/.config/waybar

echo "[*] Copiando arquivos de configuração para ~/.config/..."
cp -r .config/niri/* ~/.config/niri/
cp -r .config/waybar/* ~/.config/waybar/

echo "=================================================="
echo "   Instalação concluída com sucesso!"
echo "   Inicie o Niri a partir do seu gerenciador de login."
echo "=================================================="
