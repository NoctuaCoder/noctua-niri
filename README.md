# Noctua-Niri 🌌

Uma suíte de dotfiles moderna, elegante e de alta performance construída para o **Niri** — o compositor Wayland com rolagem infinita de colunas (scrollable-tiling). Esta suíte eleva a filosofia visual e ergonômica do ecossistema **Noctua**, combinando a fluidez de animações baseadas em molas físicas (*spring animations*) com a eficiência incomparável de gerenciamento de espaço de trabalho em colunas.

---

## ✨ Por que o Niri com Noctua é Superior?

Comparado a compositores tradicionais baseados em árvores binárias ou grid estático (como Hyprland, i3 ou Sway), o Niri introduz um paradigma revolucionário que resolve os maiores gargalos de produtividade:

1. **Rolagem Infinita de Colunas**: Suas janelas são organizadas em colunas fluidas que você rola horizontalmente. Nunca mais faltará espaço na tela ao abrir várias referências ou terminais.
2. **Animações Físicas Baseadas em Molas**: Movimentos de abertura, fechamento, redimensionamento e transição de foco utilizam funções de mola reais (`spring-damping-ratio`), garantindo uma sensação tátil e orgânica incomparável.
3. **Foco Dinâmico e Consumo Inteligente**: O layout gerencia automaticamente a largura das colunas com proporções pré-definidas (`0.33`, `0.5`, `0.75`, `1.0`), mantendo o foco limpo e sem poluição visual.
4. **Estética Noctua Integrada**: Paleta de cores inspirada no tema Catppuccin Mocha com tons pastéis, bordas com gradientes suaves, cantos arredondados e transparências glassmorphism no Waybar e centro de notificações.

---

## 📂 Estrutura dos Dotfiles

```tree
noctua-niri/
├── .config/
│   ├── niri/
│   │   └── config.kdl      # Configuração central do compositor Niri (Keybindings, layout, regras)
│   └── waybar/
│       ├── config          # Layout superior da barra de status
│       └── style.css       # Estilização Glassmorphism em CSS
├── install.sh              # Script automatizado de instalação e verificação de dependências
└── README.md               # Documentação completa
```

---

## ⌨️ Atalhos Principais (Keybindings)

| Atalho | Ação | Descrição |
| :--- | :--- | :--- |
| `Mod + Enter` | Abrir Terminal | Lança o emulador **Kitty** |
| `Mod + Space` | Lançador de Apps | Abre o **Fuzzel** para busca rápida |
| `Mod + Q` | Fechar Janela | Encerra a janela em foco |
| `Mod + H / L` | Navegar Colunas | Move o foco para a coluna à esquerda / direita |
| `Mod + J / K` | Navegar Janelas | Move o foco para a janela abaixo / acima na coluna |
| `Mod + Ctrl + H/L`| Mover Coluna | Desloca a coluna inteira para a esquerda / direita |
| `Mod + 1..6` | Trocar Workspace | Alterna para o workspace correspondente |
| `Mod + Shift + 1..6`| Enviar para Workspace | Move a coluna atual para o workspace indicado |
| `Mod + F` | Maximizar Coluna | Alterna a largura da coluna para 100% |
| `Mod + R` | Redimensionar | Alterna entre larguras predefinidas (`1/3`, `1/2`, `2/3`, `1.0`) |
| `Print` | Captura de Tela | Salva screenshot da tela inteira |

---

## 🚀 Instalação Rápida

Clone este repositório e execute o script de instalação:

```bash
git clone https://github.com/NoctuaCoder/noctua-niri.git
cd noctua-niri
chmod +x install.sh
./install.sh
```

---

## 🛠️ Dependências Recomendadas

Para aproveitar a experiência completa do **Noctua-Niri**, certifique-se de ter os seguintes pacotes instalados:
- **Compositor**: `niri`
- **Barra de Status**: `waybar`
- **Lançador de Aplicativos**: `fuzzel`
- **Central de Notificações**: `swaync`
- **Gerenciador de Wallpaper**: `swww`
- **Emulador de Terminal**: `kitty`
- **Captura de Tela**: `grim` / `slurp` / `grimshot`
- **Fonte**: `ttf-jetbrains-mono-nerd`

---

## 📄 Licença

Distribuído sob a licença MIT. Sinta-se à vontade para modificar e adaptar para o seu fluxo de trabalho.
