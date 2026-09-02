import QtQuick
import Quickshell.Io

Text {
    id: root
    color: colors.yellow
    font.family: "IosevkaTermSlab Nerd Font"
    font.pixelSize: 12
    leftPadding: 10
    rightPadding: 10
    text: "󰃝 --"

    BarColors { id: colors }

    Process {
        id: blProc
        command: ["bash", "-c", "current=$(brightnessctl get); max=$(brightnessctl max); echo $((current * 100 / max))"]
        running: true

        stdout: SplitParser {
            onRead: function(line) {
                let pct = parseInt(line.trim())
                if (!isNaN(pct)) {
                    let icon = pct >= 100 ? "󰃠" : pct >= 70 ? "󰃝" : pct >= 50 ? "󰃟" : "󰃞"
                    root.text = icon + " " + pct + "%"
                }
            }
        }
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: blProc.running = true
    }

    Component.onCompleted: blProc.running = true
}
