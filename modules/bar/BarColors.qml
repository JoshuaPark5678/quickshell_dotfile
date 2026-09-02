import QtQuick
import Quickshell.Io

Item {
    id: root

    property string background: "#1e1e2e"
    property string surface: "#313244"
    property string text: "#cdd6f4"
    property string subtext: "#6c7086"
    property string accent: "#b4befe"
    property string blue: "#89b4fa"
    property string green: "#a6e3a1"
    property string yellow: "#f9e2af"
    property string red: "#f38ba8"
    property string mauve: "#cba6f7"
    property string sapphire: "#74c7ec"

    FileView {
        id: colorFile
        path: "/home/jesh/.config/quickshell/niri-bar/scripts/bar-colors.json"
        watchChanges: true
        blockAllReads: true
        onFileChanged: reload()
        onLoaded: root.applyColors(text())
        Component.onCompleted: root.applyColors(text())
    }

    function applyColors(jsonStr) {
        try {
            let data = JSON.parse(jsonStr)
            if (data.background) root.background = data.background
            if (data.surface) root.surface = data.surface
            if (data.text) root.text = data.text
            if (data.subtext) root.subtext = data.subtext
            if (data.accent) root.accent = data.accent
            if (data.blue) root.blue = data.blue
            if (data.green) root.green = data.green
            if (data.yellow) root.yellow = data.yellow
            if (data.red) root.red = data.red
            if (data.mauve) root.mauve = data.mauve
            if (data.sapphire) root.sapphire = data.sapphire
        } catch(e) {}
    }
}
