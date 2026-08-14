#!/usr/bin/env python3
"""Generate a restrained Noctua Rail palette from a wallpaper image."""
import json
import sys
from pathlib import Path

from PIL import Image, ImageStat


def clamp(value: int) -> int:
    return max(0, min(255, int(value)))


def hex_color(rgb: tuple[int, int, int]) -> str:
    return "#%02X%02X%02X" % tuple(clamp(v) for v in rgb)


def main() -> int:
    if len(sys.argv) not in (2, 3):
        print("usage: apply-wallpaper-palette.py WALLPAPER [THEME_JSON]", file=sys.stderr)
        return 2

    wallpaper = Path(sys.argv[1]).expanduser()
    theme_path = Path(sys.argv[2]).expanduser() if len(sys.argv) == 3 else Path.home() / ".config/quickshell/theme.json"
    with Image.open(wallpaper) as image:
        image = image.convert("RGB")
        image.thumbnail((96, 96))
        quantized = image.quantize(colors=8).convert("RGB")
        colors = quantized.getcolors(maxcolors=96 * 96) or []
        colors.sort(reverse=True)
        dominant = colors[0][1] if colors else (39, 21, 61)
        mean = ImageStat.Stat(image).mean

    r, g, b = dominant
    mr, mg, mb = mean
    background = (clamp(r * 0.20), clamp(g * 0.20), clamp(b * 0.20))
    surface = (clamp(r * 0.42 + 18), clamp(g * 0.42 + 18), clamp(b * 0.42 + 18))
    accent = (clamp(r * 0.72 + 65), clamp(g * 0.72 + 65), clamp(b * 0.72 + 65))
    wave = (clamp(mr * 0.55 + 80), clamp(mg * 0.55 + 80), clamp(mb * 0.55 + 80))
    highlight = (clamp(235 + mr * 0.08), clamp(238 + mg * 0.06), clamp(235 + mb * 0.08))

    data = json.loads(theme_path.read_text())
    theme = data.setdefault("theme", {})
    theme.update({
        "name": "Wallpaper Adaptive · Noctua Rail",
        "palette_mode": "wallpaper",
        "background": hex_color(background),
        "surface": hex_color(surface),
        "surface_hover": hex_color((r * 0.55 + 30, g * 0.55 + 30, b * 0.55 + 30)),
        "accent": hex_color(accent),
        "accent_border": hex_color(highlight),
        "blue": hex_color((120 + b * 0.30, 140 + g * 0.25, 180 + r * 0.18)),
        "peach": hex_color((220 + r * 0.12, 150 + g * 0.12, 125 + b * 0.10)),
        "green": hex_color((120 + g * 0.25, 180 + r * 0.18, 150 + b * 0.18)),
        "red": "#F38BA8",
        "wave_color": hex_color(wave),
        "wave_highlight": hex_color(highlight),
        "wave_opacity": 0.22,
    })
    theme_path.write_text(json.dumps(data, indent=2) + "\n")
    print(f"Applied wallpaper palette to {theme_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
