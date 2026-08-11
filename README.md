# Noctua-Niri 🌌

Uma suíte de dotfiles moderna, elegante e de alta performance construída para o **Niri** — o compositor Wayland com rolagem infinita de colunas (scrollable-tiling). Esta suíte eleva a filosofia visual e ergonômica do ecossistema **Noctua**, combinando a fluidez de animações baseadas em molas físicas (*spring animations*) com a eficiência incomparável de gerenciamento de espaço de trabalho em colunas e uma **Noctua-Shell** altamente customizável em **Quickshell (QML)**.

---

## ✨ Por que o Niri com Noctua e Quickshell é Superior?

1. **Rolagem Infinita de Colunas**: Suas janelas são organizadas em colunas fluidas que você rola horizontalmente.
2. **Noctua-Shell em Quickshell (QML)**: Substitui interfaces rígidas por uma camada reativa construída em QML, permitindo serviços dinâmicos, integração com o estado do Niri (`niri msg`) e widgets altamente responsivos.
3. **Animações Físicas Baseadas em Molas**: Movimentos de abertura, fechamento e transição de foco utilizam funções de mola reais (`spring-damping-ratio`).
4. **Estética Noctua Integrada**: Paleta Catppuccin Mocha com tons pastéis, glassmorphism e bordas com gradientes suaves.

---

## 📂 Estrutura dos Dotfiles

```tree
noctua-niri/
├── .config/
│   ├── niri/
│   │   └── config.kdl      # Configuração central do compositor Niri
│   └── waybar/
│       ├── config          # Layout superior da barra de status
│       └── style.css       # Estilização Glassmorphism em CSS
├── shell/                  # Noctua-Shell baseada em Quickshell (QML)
│   ├── shell.qml           # Ponto de entrada da shell QML
│   └── services/
│       └── NiriService.qml # Serviço de integração com o Niri (niri msg)
├── install.sh              # Script automatizado de instalação
└── README.md               # Documentação completa
```

---

## 🚀 Instalação e Execução

Clone este repositório e execute o script de instalação:

```bash
git clone https://github.com/NoctuaCoder/noctua-niri.git
cd noctua-niri
chmod +x install.sh
./install.sh
```

Para iniciar a shell em QML junto ao Niri, adicione ao seu `config.kdl`:
```kdl
spawn-at-startup "quickshell"
```

---

## 📄 Licença

Distribuído sob a licença MIT.
