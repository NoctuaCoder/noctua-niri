# Noctua-Niri 🌌 (Prime Edition)

Uma suíte de dotfiles soberana, elegante e de alta performance construída exclusivamente para o **Niri** — o compositor Wayland com rolagem infinita de colunas (*scrollable-tiling*). O **Noctua-Niri** redefine o padrão de excelência no Linux, combinando componentes modulares em QML, arquitetura de configuração externa via JSON com **Hot-Reload**, painel lateral de telemetria em tempo real, **NoctuaLauncher nativo de alta performance** e a estética exclusiva Catppuccin Mocha.

---

## 💎 Arquitetura e Diferenciais Soberanos

1. **Configuração Externa com Hot-Reload (`theme.json`)**:
   - Centraliza cores, opacidades, raios de borda e fontes. Altere qualquer propriedade no arquivo de configuração e veja a shell se atualizar instantaneamente sem reinicializações.
2. **Biblioteca de Componentes Nativos (`shell/components/`)**:
   - `NoctuaCard.qml`: Cartões com glassmorphism avançado, bordas reativas ao hover e opacidade dinâmica.
   - `NoctuaButton.qml`: Botões interativos com transições suaves de cor e ícones integrados.
3. **Módulos de Shell Soberanos**:
   - `NoctuaBar`: Barra superior flutuante com relógio dinâmico, workspaces clicáveis e indicadores de áudio/bateria/rede.
   - `NoctuaDashboard`: Painel lateral flutuante com telemetria em tempo real (CPU, RAM, Disco) e animações de suavização.
   - `NoctuaLauncher`: Menu de aplicativos flutuante nativo em QML com busca em tempo real, parsing otimizado de binários e acionamento instantâneo via tecla **Super**.

---

## 📂 Estrutura do Repositório

```tree
noctua-niri/
├── .config/
│   ├── niri/
│   │   └── config.kdl      # Configuração central do Niri (com atalhos nativos)
│   └── quickshell/
│       └── theme.json      # Arquivo de configuração de temas com Hot-Reload
├── shell/                  # Noctua-Shell (Quickshell QML)
│   ├── shell.qml           # Ponto de entrada da shell
│   ├── components/         # Biblioteca de componentes visuais
│   │   ├── NoctuaCard.qml  # Cartão base dinâmico
│   │   └── NoctuaButton.qml# Botões interativos dinâmicos
│   ├── services/           # Serviços reativos (ConfigService com hot-reload, Niri, Audio, etc.)
│   └── modules/            # Módulos de barra, sidebar e launcher nativo
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

Distribuído sob la licença MIT. Veja o arquivo `LICENSE` para mais detalhes.
