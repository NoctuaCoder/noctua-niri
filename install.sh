#!/usr/bin/env bash
set -e

echo "=================================================="
echo "    Instalador Oficial - Noctua-Niri Dotfiles     "
echo "    (Noctua Aesthetics + Quickshell + Waybar)     "
echo "=================================================="

# Função de backup
backup_existing() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "[*] Fazendo backup de $target para ${target}.bak..."
        mv "$target" "${target}.bak"
    fi
}

# Detectar gerenciador de pacotes
if command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
elif command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
else
    PKG_MANAGER="unknown"
fi

echo "[*] Gerenciador de pacotes detectado: $PKG_MANAGER"

# Escolha interativa de barra
echo ""
echo "Escolha a barra de status principal:"
echo "1) Quickshell (Noctua-Shell flutuante com QML e dados reais)"
echo "2) Waybar (Barra tradicional com Glassmorphism)"
echo "3) Ambos"
read -p "Opção [1-3, padrão 1]: " bar_choice
bar_choice=${bar_choice:-1}

# Instalação de dependências
if [ "$PKG_MANAGER" = "pacman" ]; then
    echo "[*] Instalando dependências no Arch Linux..."
    sudo pacman -S --needed niri fuzzel swaync swww kitty grim slurp wl-clipboard brightnessctl pamixer pavucontrol ttf-jetbrains-mono-nerd
elif [ "$PKG_MANAGER" = "dnf" ]; then
    echo "[!] Fedora detectado. Certifique-se de instalar niri, waybar, fuzzel e quickshell."
elif [ "$PKG_MANAGER" = "apt" ]; then
    echo "[!] Debian/Ubuntu detectado. Instalação manual necessária para Niri e Quickshell."
fi

# Criação de diretórios e backups
echo "[*] Criando diretórios e aplicando backups..."
mkdir -p ~/.config/niri
mkdir -p ~/.config/waybar
mkdir -p ~/.config/quickshell

backup_existing "$HOME/.config/niri/config.kdl"
backup_existing "$HOME/.config/waybar/config"
backup_existing "$HOME/.config/waybar/style.css"

# Copiar arquivos
cp -r .config/niri/* ~/.config/niri/
cp -r .config/waybar/* ~/.config/waybar/

if [ -d "shell" ]; then
    cp -r shell/* ~/.config/quickshell/
fi

# Ajustar startup no Niri com base na escolha
if [ "$bar_choice" = "1" ]; then
    echo "[*] Configurando Niri para iniciar Quickshell..."
    sed -i 's/spawn-at-startup "waybar"/\/\/ spawn-at-startup "waybar"\nspawn-at-startup "quickshell"/g' ~/.config/niri/config.kdl
elif [ "$bar_choice" = "2" ]; then
    echo "[*] Configurando Niri para iniciar Waybar..."
    sed -i 's/spawn-at-startup "quickshell"/\/\/ spawn-at-startup "quickshell"/g' ~/.config/niri/config.kdl
else
    echo "[*] Configurando Niri para iniciar ambos..."
    sed -i 's/\/\/ spawn-at-startup "quickshell"/spawn-at-startup "quickshell"/g' ~/.config/niri/config.kdl
fi

echo "=================================================="
echo "   Instalação concluída com sucesso!"
echo "   Backups salvos com extensão .bak"
echo "   Inicie o Niri a partir do seu gerenciador de login."
echo "=================================================="
