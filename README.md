# Noctua-Niri 🌌 (Caffyne-Style Edition)

Uma suíte de dotfiles moderna, elegante e de alta performance construída para o **Niri** — o compositor Wayland com rolagem infinita de colunas (*scrollable-tiling*). Inspirada na sofisticação visual do **Caffyne Shell**, esta edição traz componentes modulares em QML, arquitetura de configuração externa via JSON, painel lateral de telemetria e estética Catppuccin Mocha.

---

## 💎 Arquitetura e Diferenciais

1. **Configuração Externa (`theme.json`)**:
   - Centraliza cores, opacidades, raios de borda e fontes. Personalize toda a shell sem tocar em uma única linha de código QML.
2. **Biblioteca de Componentes (`shell/components/`)**:
   - `NoctuaCard.qml`: Cartões com glassmorphism avançado, bordas reativas ao hover e opacidade dinâmica.
   - `NoctuaButton.qml`: Botões interativos com transições suaves de cor e ícones integrados.
3. **NoctuaBar & NoctuaDashboard**:
   - Barra superior flutuante com relógio dinâmico, workspaces clicáveis e indicadores de áudio/bateria/rede.
   - Painel lateral flutuante com telemetria em tempo real (CPU, RAM, Disco) e animações de suavização (*easing*).

---

## 📂 Estrutura do Repositório

```tree
noctua-niri/
├── .config/
│   ├── niri/
│   │   └── config.kdl      # Configuração central do Niri
│   └── quickshell/
│       └── theme.json      # Arquivo de configuração de temas e shell
├── shell/                  # Noctua-Shell (Quickshell QML)
│   ├── shell.qml           # Ponto de entrada da shell
│   ├── components/         # Biblioteca de componentes visuais
│   │   ├── NoctuaCard.qml  # Cartão base dinâmico
│   │   └── NoctuaButton.qml# Botões interativos dinâmicos
│   ├── services/           # Serviços reativos (Config, Niri, Audio, Bateria, CPU, Rede)
│   └── modules/            # Módulos de barra e sidebar (Dashboard)
├── docs/
│   └── EYECANDY.md         # Guia visual r/unixporn
├── ROADMAP.md              # Planejamento estratégico de evolução
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
