// ============================================================================
// Noctua-Niri Shell — Quickshell Configuration (Caffyne-Style Edition)
// ============================================================================

import Quickshell
import "services"
import "modules/bar"
import "modules/sidebar"

ShellRoot {
    // ── Configuration & Services ──────────────────────────────────────────────
    ConfigService         { id: configService }
    NiriService           { id: niriService }
    AudioService          { id: audioService }
    BatteryService        { id: batteryService }
    SystemMonitorService  { id: systemMonitorService }
    NetworkService        { id: networkService }

    // ── Shell Modules ─────────────────────────────────────────────────────────
    NoctuaBar             {}
    NoctuaDashboard       {}

    Component.onCompleted: {
        console.log("Noctua-Niri Caffyne-Style Shell (with ConfigService) initialized successfully.")
    }
}
