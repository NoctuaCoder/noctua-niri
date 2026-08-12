// ============================================================================
// Noctua-Niri Shell — Quickshell Configuration (Prime Edition)
// ============================================================================

import Quickshell
import "services"
import "modules/bar"
import "modules/sidebar"
import "modules/launcher"

ShellRoot {
    // ── Configuration & Services ──────────────────────────────────────────────
    ConfigService         { id: configService }
    NiriService           { id: niriService }
    AudioService          { id: audioService }
    BatteryService        { id: batteryService }
    SystemMonitorService  { id: systemMonitorService }
    NetworkService        { id: networkService }

    // ── Shell Modules ────────────────────────────────-------------------------
    NoctuaBar             {}
    NoctuaDashboard       {}
    NoctuaLauncher        { id: noctuaLauncher }

    Component.onCompleted: {
        console.log("Noctua-Niri Prime Shell (with Launcher) initialized successfully.")
    }
}
