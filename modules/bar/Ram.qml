import QtQuick
import Quickshell.Io

Text {
    id: root
    color: colors.sapphire
    font.family: "IosevkaTermSlab Nerd Font"
    font.pixelSize: 14
    leftPadding: 0
    rightPadding: 10

    BarColors { id: colors }

    property string normalText: "| 󰘚 -- |"
    property string detailText: "Loading..."
    property bool hovering: false

    text: hovering ? detailText : normalText

    Process {
        id: ramProc
        command: ["sh", "-c", "free | awk '/Mem:/ {printf \"%.0f\", $3/$2*100}'"]
        running: true

        stdout: SplitParser {
            onRead: function(line) {
                let pct = parseInt(line.trim())
                if (!isNaN(pct)) {
                    root.normalText = "| 󰘚 " + pct + "% |"
                    root.color = pct >= 80 ? colors.red : pct >= 50 ? colors.yellow : colors.sapphire
                }
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: ramProc.running = true
    }

    Process {
        id: detailProc
        command: ["sh", "-c", "free -h | awk '/Mem:/ {printf \"%s/%s\", $3, $2}'; echo; free -h | awk '/Swap:/ {printf \"%s/%s\", $3, $2}'"]

        property int lineCount: 0

        stdout: SplitParser {
            onRead: function(line) {
                detailProc.lineCount++
                if (detailProc.lineCount === 1) {
                    root.detailText = "| 󰘚 " + line.trim()
                } else if (detailProc.lineCount === 2) {
                    root.detailText += " · Swap " + line.trim() + " |"
                    detailProc.lineCount = 0
                }
            }
        }
    }

    function refreshDetail() {
        detailProc.lineCount = 0
        detailProc.running = true
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: {
            root.hovering = true
            root.refreshDetail()
        }
        onExited: root.hovering = false
    }

    Component.onCompleted: ramProc.running = true
}
