import QtQuick
import Quickshell.Io

Text {
    id: root
    color: colors.mauve
    font.family: "IosevkaTermSlab Nerd Font"
    font.pixelSize: 14
    leftPadding: 10
    rightPadding: 0

    BarColors { id: colors }

    property string normalText: "| 󰍛 -- |"
    property string detailText: "Loading..."
    property bool hovering: false

    text: hovering ? detailText : normalText

    Process {
        id: cpuProc
        command: ["sh", "-c", "awk '/^cpu / {printf \"%.0f\", ($2+$4)*100/($2+$4+$5)}' /proc/stat"]
        running: true

        stdout: SplitParser {
            onRead: function(line) {
                let pct = parseInt(line.trim())
                if (!isNaN(pct)) {
                    root.normalText = "| 󰍛 " + pct + "% |"
                    root.color = pct >= 80 ? colors.red : pct >= 50 ? colors.yellow : colors.mauve
                }
            }
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: cpuProc.running = true
    }

    Process {
        id: detailProc
        command: ["sh", "-c", "awk '/^cpu / {u=$2+$4; t=$2+$4+$5; printf \"%.1f\", u*100/t}' /proc/stat; echo; awk '{printf \"%.0f\", $1/1000}' /sys/class/thermal/thermal_zone0/temp; echo; nproc"]

        property int lineCount: 0

        stdout: SplitParser {
            onRead: function(line) {
                detailProc.lineCount++
                if (detailProc.lineCount === 1) {
                    root.detailText = "| 󰍛 " + line.trim() + "%"
                } else if (detailProc.lineCount === 2) {
                    root.detailText += " · " + line.trim() + "°C"
                } else if (detailProc.lineCount === 3) {
                    root.detailText += " · " + line.trim() + " cores |"
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

    Component.onCompleted: cpuProc.running = true
}
