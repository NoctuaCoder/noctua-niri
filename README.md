# Noctua-Niri 🌌

Uma suíte de dotfiles moderna, elegante e de alta performance construída para o **Niri** — o compositor Wayland com rolagem infinita de colunas (*scrollable-tiling*). Esta suíte combina a fluidez de animações baseadas em molas físicas com a **Noctua-Shell** em **Quickshell (QML)**, oferecendo dados em tempo real, workspaces interativos e estética Catppuccin Mocha.

---

## 📌 Status do Projeto: Work in Progress (MVP Avançado)

> **Nota**: Este projeto está em constante evolução. O compositor Niri e a barra Quickshell estão totalmente funcionais, mas novos módulos e refinamentos visuais continuam sendo adicionados.

---

## ✨ Arquitetura e Componentes

1. **Niri Compositor (`config.kdl`)**: Gerenciamento de janelas em colunas roláveis, bordas com foco dinâmico e animações físicas de mola (`spring-damping-ratio`).
2. **Noctua-Shell (`Quickshell / QML`)**: Barra superior flutuante com *Glassmorphism*, workspaces clicáveis sincronizados via event stream do Niri, indicador de áudio (`wpctl`) e bateria.
3. **Waybar (Alternativa)**: Barra secundária com estilo Catppuccin Mocha para quem prefere componentes tradicionais em C++.

---

## 📂 Estrutura do Repositório

```tree
noctua-niri/
├── .config/
│   ├── niri/
│   │   └── config.kdl      # Configuração central do Niri
│   └── waybar/
│       ├── config          # Layout da barra Waybar
│       └── style.css       # Estilização Glassmorphism do Waybar
├── shell/                  # Noctua-Shell (Quickshell QML)
│   ├── shell.qml           # Ponto de entrada da shell
│   ├── services/
│   │   ├── NiriService.qml # Serviço reativo (event-stream)
│   │   ├── AudioService.qml# Leitura de volume em tempo real
│   │   └── BatteryService.qml# Monitoramento de bateria
│   └── modules/
│       └── bar/
│           └── NoctuaBar.qml # Barra flutuante interativa
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

Durante a instalação, você poderá escolher entre usar o **Quickshell**, a **Waybar** ou **ambos**. O script faz backup automático de arquivos existentes (`.bak`).

---

## 🗺️ Roadmap

- [x] Configuração base do Niri com spring animations.
- [x] Quickshell reativo com `niri msg event-stream`.
- [x] Workspaces interativos e clicáveis na barra.
- [x] Leitores reais de áudio e bateria.
- [ ] Central de notificações customizada em Quickshell.
- [ ] Launcher de aplicativos flutuante em QML.
- [ ] Adição de screenshots reais e GIF de demonstração no README.

---

## 📄 Licença

Distribuído sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.
