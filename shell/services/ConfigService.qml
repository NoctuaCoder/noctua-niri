pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    // Cores padrão (Catppuccin Mocha)
    property color background: "#1e1e2e"
    property color surface: "#313244"
    property color surfaceHover: "#45475a"
    property color text: "#cdd6f4"
    property color subtext: "#9399b2"
    property color accent: "#cba6f7"
    property color accentBorder: "#f5e0dc"
    property color blue: "#89b4fa"
    property color peach: "#fab387"
    property color green: "#a6e3a1"
    property color red: "#f38ba8"

    property real shellOpacity: 0.90
    property int shellRadius: 16
    property string fontFamily: "JetBrainsMono Nerd Font"

    function loadConfig() {
        configLoader.running = true
    }

    Process {
        id: configLoader
        // Tenta ler o theme.json do diretório de config
        command: ["cat", Quickshell.env("HOME") + "/.config/quickshell/theme.json"]
        stdout: SplitParser {
            onRead: data => {
                try {
                    let cfg = JSON.parse(data)
                    if (cfg.theme) {
                        if (cfg.theme.background) root.background = cfg.theme.background
                        if (cfg.theme.surface) root.surface = cfg.theme.surface
                        if (cfg.theme.surface_hover) root.surfaceHover = cfg.theme.surface_hover
                        if (cfg.theme.text) root.text = cfg.theme.text
                        if (cfg.theme.subtext) root.subtext = cfg.theme.subtext
                        if (cfg.theme.accent) root.accent = cfg.theme.accent
                        if (cfg.theme.accent_border) root.accentBorder = cfg.theme.accent_border
                        if (cfg.theme.blue) root.blue = cfg.theme.blue
                        if (cfg.theme.peach) root.peach = cfg.theme.peach
                        if (cfg.theme.green) root.green = cfg.theme.green
                        if (cfg.theme.red) root.red = cfg.theme.red
                    }
                    if (cfg.shell) {
                        if (cfg.shell.opacity !== undefined) root.shellOpacity = cfg.shell.opacity
                        if (cfg.shell.radius !== undefined) root.shellRadius = cfg.shell.radius
                        if (cfg.shell.fontFamily) root.fontFamily = cfg.shell.fontFamily
                    }
                    console.log("[ConfigService] Theme loaded successfully from theme.json")
                } catch (e) {
                    console.log("[ConfigService] Error parsing theme.json, using defaults:", e)
                }
            }
        }
    }

    Component.onCompleted: {
        loadConfig()
    }
}
