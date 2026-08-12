#!/usr/bin/env bash
# ==============================================================================
# Noctua-Niri Screenshot Utility
# Requer grim e slurp (ou grimshot) instalados
# ==============================================================================

OUTPUT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$OUTPUT_DIR"
FILENAME="$OUTPUT_DIR/noctua-niri-$(date +%Y%m%d_%H%M%S).png"

if command -v grimshot &> /dev/null; then
    grimshot save active "$FILENAME"
    echo "[*] Screenshot salva em: $FILENAME"
elif command -v grim &> /dev/null; then
    grim "$FILENAME"
    echo "[*] Screenshot salva em: $FILENAME"
else
    echo "[!] Erro: grim ou grimshot não encontrados."
    exit 1
fi
