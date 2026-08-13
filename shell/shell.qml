// ============================================================================
// Noctua-Niri Shell — Quickshell Configuration (Ultimate Edition v2.0)
// ============================================================================

import Quickshell
import "services"
import "modules/bar"
import "modules/sidebar"
import "modules/launcher"
import "modules/osd"
import "modules/powermenu"
import "modules/notifications"
// import "modules/lockscreen" // v2.0 uses swaylock for real security

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
    // NoctuaLock            { id: noctuaLock } // v2.0 uses swaylock for real security

    Component.onCompleted: {
        console.log("Noctua-Niri Ultimate Shell (v2.0) with Swaylock integration initialized successfully.")
    }
}
