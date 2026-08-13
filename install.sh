#!/usr/bin/env bash
set -e

echo "=================================================="
echo "    Instalador Oficial - Noctua-Niri Prime        "
echo "    (Ultimate Edition v2.0)                       "
echo "=================================================="

backup_existing() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        echo "[*] Fazendo backup de $target para ${target}.bak..."
        mv "$target" "${target}.bak"
    fi
}

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

echo ""
echo "Escolha a interface principal da shell:"
echo "1) Quickshell (Noctua-Shell flutuante soberana com OSD, Launcher e Notificações DBus)"
echo "2) Waybar (Barra tradicional com Glassmorphism)"
echo "3) Ambos"
read -p "Opção [1-3, padrão 1]: " bar_choice
bar_choice=${bar_choice:-1}

if [ "$PKG_MANAGER" = "pacman" ]; then
    echo "[*] Instalando dependências no Arch Linux..."
    sudo pacman -S --needed niri fuzzel swaync swww kitty grim slurp wl-clipboard brightnessctl pamixer pavucontrol ttf-jetbrains-mono-nerd python-dbus python-gobject nc swaylock
elif [ "$PKG_MANAGER" = "dnf" ]; then
    echo "[!] Fedora detectado. Certifique-se de instalar niri, quickshell, python3-dbus e python3-gobject."
elif [ "$PKG_MANAGER" = "apt" ]; then
    echo "[!] Debian/Ubuntu detectado. Instalação manual necessária para Niri e Quickshell."
fi

echo "[*] Criando diretórios e aplicando backups..."
mkdir -p ~/.config/niri
mkdir -p ~/.config/waybar
mkdir -p ~/.config/quickshell
mkdir -p ~/.config/swaylock

backup_existing "$HOME/.config/niri/config.kdl"
backup_existing "$HOME/.config/waybar/config"
backup_existing "$HOME/.config/waybar/style.css"
backup_existing "$HOME/.config/swaylock/config"

cp -r .config/niri/* ~/.config/niri/
cp -r .config/waybar/* ~/.config/waybar/
cp -r .config/swaylock/* ~/.config/swaylock/

if [ -d "shell" ]; then
    cp -r shell/* ~/.config/quickshell/
fi

# Garante permissão de execução no daemon Python de notificações
if [ -f "$HOME/.config/quickshell/services/notification_daemon.py" ]; then
    chmod +x "$HOME/.config/quickshell/services/notification_daemon.py"
fi

# Configuração robusta do startup no config.kdl
CONFIG_KDL="$HOME/.config/niri/config.kdl"
if [ -f "$CONFIG_KDL" ]; then
    if [ "$bar_choice" = "1" ]; then
        echo "[*] Configurando Niri para iniciar Quickshell..."
        sed -i 's/spawn-at-startup "waybar"/\/\/ spawn-at-startup "waybar"\nspawn-at-startup "quickshell"/g' "$CONFIG_KDL"
    elif [ "$bar_choice" = "2" ]; then
        echo "[*] Configurando Niri para iniciar Waybar..."
        sed -i 's/spawn-at-startup "quickshell"/\/\/ spawn-at-startup "quickshell"/g' "$CONFIG_KDL"
    else
        echo "[*] Configurando Niri para iniciar ambos..."
        sed -i 's/\/\/ spawn-at-startup "quickshell"/spawn-at-startup "quickshell"/g' "$CONFIG_KDL"
    fi
fi

echo "=================================================="
echo "   Instalação concluída com sucesso! (v2.0)"
echo "   Backups salvos com extensão .bak"
echo "   Inicie o Niri a partir do seu gerenciador de login."
echo "=================================================="
