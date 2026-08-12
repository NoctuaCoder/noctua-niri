# Noctua-Niri 🌌 (Caffyne-Style Edition)

Uma suíte de dotfiles moderna, elegante e de alta performance construída para o **Niri** — o compositor Wayland com rolagem infinita de colunas (*scrollable-tiling*). Inspirada na sofisticação visual do **Caffyne Shell**, esta edição traz componentes modulares em QML, animações fluidas de estado, painel lateral de telemetria e estética Catppuccin Mocha.

---

## 💎 Arquitetura Modular "Caffyne-Style"

1. **Biblioteca de Componentes (`shell/components/`)**:
   - `NoctuaCard.qml`: Cartões com glassmorphism avançado, bordas reativas ao hover e opacidade configurável.
   - `NoctuaButton.qml`: Botões interativos com transições suaves de cor e ícones integrados.
2. **NoctuaBar & NoctuaDashboard**:
   - Barra superior flutuante com relógio dinâmico, workspaces clicáveis e indicadores de áudio/bateria/rede.
   - Painel lateral flutuante com telemetria em tempo real (CPU, RAM, Disco) e animações de suavização (*easing*).
3. **Niri Integrado (`config.kdl`)**:
   - Animações físicas baseadas em molas (`spring-damping-ratio`) e foco dinâmico.

---

## 📂 Estrutura do Repositório

```tree
noctua-niri/
├── .config/
│   ├── niri/
│   │   └── config.kdl      # Configuração central do Niri
│   └── waybar/
│       ├── config          # Layout alternativo da Waybar
│       └── style.css       # Estilização Glassmorphism
├── shell/                  # Noctua-Shell (Quickshell QML)
│   ├── shell.qml           # Ponto de entrada da shell
│   ├── components/         # Biblioteca de componentes visuais
│   │   ├── NoctuaCard.qml  # Cartão base com glassmorphism
│   │   └── NoctuaButton.qml# Botões interativos
│   ├── services/           # Serviços reativos (Niri, Audio, Bateria, CPU, Rede)
│   └── modules/            # Módulos de barra e sidebar (Dashboard)
├── docs/
│   └── EYECANDY.md         # Guia visual r/unixporn
├── install.sh              # Script interativo com backup e suporte multi-distro
└── README.md               # Documentação principal
```

---

## 🚀 Instalação Rápida

Clone o repositório e execute o script interativo:

```bash
git clone https://github.com/NoctuaCoder/noctua-niri.git
cd noctua-niri
chmod +x install.sh
./install.sh
```

---

## 📄 Licença

Distribuído sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.
