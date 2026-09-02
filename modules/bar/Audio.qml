import QtQuick
import Quickshell.Io

Text {
    id: root
    color: colors.mauve
    font.family: "IosevkaTermSlab Nerd Font"
    font.pixelSize: 12
    leftPadding: 10
    rightPadding: 10

    BarColors { id: colors }

    Process {
        id: volProc
        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@"]
        running: true

        stdout: SplitParser {
            onRead: function(line) {
                let parts = line.split(" ")
                let vol = Math.round(parseFloat(parts[1]) * 100)
                let muted = line.includes("[MUTED]")
                if (muted) {
                    root.text = "󰖁 Mute"
                    root.color = colors.subtext
                } else {
                    let icon = vol < 30 ? "󰕿" : vol < 70 ? "󰖀" : "󰕾"
                    root.text = icon + " " + vol + "%"
                    root.color = colors.mauve
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: volProc.running = true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: openBluetooth.running = true
    }

    Process {
        id: openBluetooth
        command: ["kitty", "--class", "floating", "-e", "bluetuith"]
    }
}
