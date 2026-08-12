# Noctua-Niri 🌌 — O Guia Definitivo "r/unixporn" (Eye-Candy)

Se você quer transformar sua área de trabalho em uma verdadeira obra de arte digna dos posts mais curtidos do Reddit, o **Noctua-Niri Eye-Candy Edition** foi feito sob medida para você. Combinando o scrollable-tiling futurista do **Niri** com a flexibilidade gráfica absoluta do **Quickshell (QML)**, esta edição eleva o conceito de personalização.

---

## 🎨 O Conceito Visual

1. **Floating Glassmorphism Bar**: A barra superior abandona o visual monolítico tradicional e flutua elegantemente sobre o wallpaper com bordas arredondadas (`radius: 16`), efeito translúcido em vidro fumê (`#1e1e2e` com 75% de opacidade) e acentos em tons pastéis Catppuccin Mocha.
2. **Animações Físicas com Molas (Spring Physics)**: Cada abertura de janela, transição de workspace e exibição de widgets responde com constantes de mola reais, criando uma sensação tátil orgânica.
3. **Paleta de Cores Coesa**:
   - **Fundo**: `#1e1e2e` (Dark Void)
   - **Destaque Principal**: `#cba6f7` (Mauve Neon)
   - **Atalhos / Relógio**: `#fab387` (Peach Pastel)
   - **Sucesso / Conexão**: `#a6e3a1` (Green Mint)

---

## 🛠️ Componentes Incluídos na Edição Eye-Candy

```tree
shell/
├── shell.qml               # Gerenciador raiz do Quickshell
├── services/
│   └── NiriService.qml     # Comunicação assíncrona em tempo real com niri msg
└── modules/
    └── bar/
        └── NoctuaBar.qml   # Barra flutuante com glassmorphism e relógio reativo
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
