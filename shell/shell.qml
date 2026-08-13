// ============================================================================
// Noctua-Niri Shell — Quickshell Configuration (Sovereign Edition v1.2)
// ============================================================================

import Quickshell
import "services"
import "modules/bar"
import "modules/sidebar"
import "modules/launcher"
import "modules/osd"
import "modules/powermenu"
import "modules/notifications"

ShellRoot {
    // ── Configuration & Services ──────────────────────────────────────────────
    ConfigService         { id: configService }
    NiriService           { id: niriService }
    AudioService          { id: audioService }
    BatteryService        { id: batteryService }
    SystemMonitorService  { id: systemMonitorService }
    NetworkService        { id: networkService }
    NotificationService   { id: notificationService }

    // ── Shell Modules ─────────────────────────────────────────────────────────
    NoctuaBar             {}
    NoctuaDashboard       {}
    NoctuaLauncher        { id: noctuaLauncher }
    NoctuaOSD             { id: noctuaOSD }
    NoctuaPowerMenu       { id: noctuaPowerMenu }
    NoctuaNotifications   {}

    Component.onCompleted: {
        console.log("Noctua-Niri Sovereign Shell (v1.2) with Native Notifications initialized successfully.")
    }
}
