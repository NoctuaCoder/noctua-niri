// ============================================================================
// Noctua-Niri Shell — Quickshell Configuration (Eye-Candy Edition)
// ============================================================================

import Quickshell
import "services"
import "modules/bar"
import "modules/sidebar"

ShellRoot {
    NiriService           { id: niriService }
    AudioService          { id: audioService }
    BatteryService        { id: batteryService }
    SystemMonitorService  { id: systemMonitorService }
    NetworkService        { id: networkService }

    NoctuaBar             {}
    NoctuaDashboard       {}

    Component.onCompleted: {
        console.log("Noctua-Niri Eye-Candy Quickshell (with Dashboard) initialized successfully.")
    }
}
