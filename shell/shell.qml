// ============================================================================
// Noctua-Niri Shell — Quickshell Configuration
// ============================================================================

import Quickshell
import "services"

ShellRoot {
    // ── Global services ───────────────────────────────────────────────────────
    NiriService { id: niriService }

    // ── Background daemon or notifications placeholder ────────────────────────
    Component.onCompleted: {
        console.log("Noctua-Niri Quickshell initialized successfully.")
    }
}
