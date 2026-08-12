# Noctua-Niri 🌌 — O Guia Definitivo "r/unixporn" (Eye-Candy Edition)

Esta é a edição definitiva do **Noctua-Niri**, projetada para entregar exatamente aquele visual de cair o queixo que domina o `r/unixporn`. Com a introdução do painel lateral **NoctuaDashboard** e serviços nativos de monitoramento de sistema, o setup atinge o nível de sofisticação visual completo.

---

## 💎 O que compõe a Edição "Screenshot-Level"

1. **Floating Glassmorphism Bar**: Barra superior translúcida com cantos arredondados, relógio neon e workspaces interativos.
2. **NoctuaDashboard (Painel Lateral)**: 
   - Painel flutuante à direita com borda em gradiente *Mauve*.
   - **System Monitor**: Barras de progresso em tempo real para uso de CPU, RAM e armazenamento raiz (`/`).
   - **Quick Controls**: Indicadores de rede (`NetworkService`) e Bluetooth integrados.
3. **Serviços Reativos em QML**:
   - `SystemMonitorService`: Leitura assíncrona de CPU/RAM.
   - `NetworkService`: Detecção de interface ativa (Wi-Fi/Ethernet).
   - `AudioService` & `BatteryService`: Controle de volume e bateria com detecção dinâmica.

---

## 📂 Estrutura Completa da Shell

```tree
shell/
├── shell.qml               # Gerenciador raiz do Quickshell
├── services/
│   ├── NiriService.qml     # Event stream do Niri
│   ├── AudioService.qml    # Controle de áudio (wpctl)
│   ├── BatteryService.qml  # Detecção dinâmica de bateria
│   ├── SystemMonitorService.qml # Leitura de CPU, RAM e Disco
│   └── NetworkService.qml  # Monitor de rede
└── modules/
    ├── bar/
    │   └── NoctuaBar.qml   # Barra flutuante principal
    └── sidebar/
        └── NoctuaDashboard.qml # Painel lateral de monitoramento
```

---

## 📸 Como Tirar Screenshots para o Reddit

Incluímos um utilitário simples em `scripts/capture.sh` para capturar sua tela em alta resolução:
```bash
./scripts/capture.sh
```
As imagens serão salvas em `~/Pictures/Screenshots/`.
