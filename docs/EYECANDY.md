# Noctua-Niri 🌌 — O Guia Definitivo "r/unixporn" (Eye-Candy)

Se você quer transformar sua área de trabalho em uma verdadeira obra de arte digna dos posts mais curtidos do Reddit, o **Noctua-Niri Eye-Candy Edition** foi feito sob medida para você. Combinando o scrollable-tiling futurista do **Niri** com a flexibilidade gráfica absoluta do **Quickshell (QML)**, esta edição eleva o conceito de personalização.

---

## 🎨 O Conceito Visual

1. **Floating Glassmorphism Bar**: A barra superior flutua elegantemente sobre o wallpaper com cantos arredondados (`radius: 16`), efeito translúcido em vidro fumê (`#1e1e2e` com 88% de opacidade) e acentos em tons pastéis Catppuccin Mocha.
2. **Quickshell Reativo e Inteligente**: 
   - **NiriService**: Comunicação em tempo real via `niri msg event-stream` para rastreamento instantâneo de workspaces.
   - **AudioService & BatteryService**: Leitura síncrona de volume via `wpctl` (com suporte a clique para mute) e detecção dinâmica de bateria (compatível com notebooks e desktops).
3. **Animações Físicas com Molas (Spring Physics)**: Cada abertura de janela, transição de workspace e efeito de *hover* na barra responde com constantes de mola e transições suaves.

---

## 🛠️ Componentes Incluídos na Edição Eye-Candy

```tree
shell/
├── shell.qml               # Gerenciador raiz do Quickshell
├── services/
│   ├── NiriService.qml     # Serviço reativo baseado em event-stream
│   ├── AudioService.qml    # Controle e monitoramento de áudio (wpctl)
│   └── BatteryService.qml  # Detecção dinâmica de bateria
└── modules/
    └── bar/
        └── NoctuaBar.qml   # Barra flutuante com glassmorphism, relógio e workspaces clicáveis
```

---

## 🚀 Como Ativar

Certifique-se de que o **Quickshell** e o **Niri** estão instalados e execute:

```bash
quickshell &
```

No seu `~/.config/niri/config.kdl`, adicione para iniciar com o compositor:
```kdl
spawn-at-startup "quickshell"
```
