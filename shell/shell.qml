// ============================================================================
// Noctua-Niri Shell — Quickshell Configuration (Eye-Candy Edition)
// ============================================================================

import Quickshell
import "services"
import "modules/bar"

ShellRoot {
    NiriService   { id: niriService }
    AudioService  { id: audioService }
    BatteryService{ id: batteryService }

    NoctuaBar {}

    Component.onCompleted: {
        console.log("Noctua-Niri Eye-Candy Quickshell initialized successfully.")
    }
}
