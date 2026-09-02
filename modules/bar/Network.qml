import QtQuick
import Quickshell.Io

Text {
    id: root
    color: colors.sapphire
    font.family: "IosevkaTermSlab Nerd Font"
    font.pixelSize: 12
    leftPadding: 10
    rightPadding: 10

    BarColors { id: colors }

    Process {
        id: netProc
        command: ["sh", "-c", "nmcli -t -f active,ssid,signal dev wifi 2>/dev/null | grep '^yes' | head -1 || echo 'no::0'"]
        running: true

        stdout: SplitParser {
            onRead: function(line) {
                if (line.startsWith("yes")) {
                    let sig = parseInt(line.substring(line.lastIndexOf(":") + 1)) || 0
                    let idx = Math.min(Math.floor(sig / 25), 4)
                    let ssid = line.substring(line.indexOf(":") + 1, line.lastIndexOf(":"))
                    root.text = ["󰤯","󰤟","󰤢","󰤥","󰤨"][idx] + " " + ssid
                    root.color = colors.sapphire
                } else {
                    root.text = "󰤮 Disconnected"
                    root.color = colors.red
                }
            }
        }
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: netProc.running = true
    }

    MouseArea {
        anchors.fill: parent
        onClicked: openNetworkMan.running = true
    }

    Process {
        id: openNetworkMan
        command: ["kitty", "--class", "floating", "-e", "impala"]
    }
}
