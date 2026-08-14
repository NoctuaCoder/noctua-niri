pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

QtObject {
    id: root

    property color background: "#27153D"
    property color surface: "#355B67"
    property color surfaceHover: "#4E7D85"
    property color text: "#F6FFFA"
    property color subtext: "#D8E6E8"
    property color accent: "#A6C9B6"
    property color accentBorder: "#F6B6B7"
    property color blue: "#B6AAC7"
    property color peach: "#F6B6B7"
    property color green: "#A6C9B6"
    property color red: "#D48D95"
    property color waveColor: "#A6C9B6"
    property color waveHighlight: "#F6FFFA"
    property real waveOpacity: 0.24
    property string paletteMode: "original"

    property real shellOpacity: 0.90
    property int shellRadius: 16
    property string fontFamily: "JetBrainsMono Nerd Font"

    function loadConfig() {
        configLoader.running = true
    }

    // Hot-Reload: Timer para verificar alterações no theme.json a cada 1 segundo
    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            configLoader.running = true
        }
    }

    Process {
        id: configLoader
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
                        if (cfg.theme.wave_color) root.waveColor = cfg.theme.wave_color
                        if (cfg.theme.wave_highlight) root.waveHighlight = cfg.theme.wave_highlight
                        if (cfg.theme.wave_opacity !== undefined) root.waveOpacity = cfg.theme.wave_opacity
                        if (cfg.theme.palette_mode) root.paletteMode = cfg.theme.palette_mode
                    }
                    if (cfg.shell) {
                        if (cfg.shell.opacity !== undefined) root.shellOpacity = cfg.shell.opacity
                        if (cfg.shell.radius !== undefined) root.shellRadius = cfg.shell.radius
                        if (cfg.shell.fontFamily) root.fontFamily = cfg.shell.fontFamily
                    }
                } catch (e) {
                    // Ignora erros parciais durante salvamento
                }
            }
        }
    }

    Component.onCompleted: {
        loadConfig()
    }
}
