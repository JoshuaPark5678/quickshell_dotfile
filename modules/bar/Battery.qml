import QtQuick
import Quickshell.Io

Text {
    id: root
    color: colors.green
    font.family: "IosevkaTermSlab Nerd Font"
    font.pixelSize: 12
    leftPadding: 10
    rightPadding: 10

    BarColors { id: colors }

    readonly property var icons: ["󰁺","󰁻","󰁼","󰁽","󰁾","󰁿","󰂀","󰂁","󰂂","󰁹"]

    property string normalText: "󰁹 --"
    property string detailText: "Loading..."
    property bool hovering: false

    text: hovering ? detailText : normalText

    Process {
        id: batProc
        command: ["sh", "-c", "cat /sys/class/power_supply/BAT0/capacity && cat /sys/class/power_supply/BAT0/status"]
        running: true

        stdout: SplitParser {
            property int cap: 0
            property int lineCount: 0

            onRead: function(line) {
                lineCount++
                if (lineCount === 1) {
                    cap = parseInt(line)
                } else {
                    let status = line.trim()
                    let isCharging = status.toLowerCase() === "charging"
                    let iconIdx = Math.min(Math.floor(cap / 10), 9)
                    let icon = isCharging ? "󰂄" : root.icons[iconIdx]
                    root.normalText = icon + " " + cap + "%"
                    root.color = cap <= 15 ? colors.red : cap <= 30 ? colors.yellow : colors.blue
                    lineCount = 0
                }
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: batProc.running = true
    }

    Process {
        id: detailProc
        command: ["sh", "-c", "B=$(upower -e | grep -m1 BAT); upower -i $B | grep -E 'state:|energy-rate:|time to empty:|time to full:|percentage:'"]

        property string state: ""
        property string rate: ""
        property string timeLine: ""

        stdout: SplitParser {
            onRead: function(line) {
                let idx = line.indexOf(":")
                if (idx === -1) return
                let key = line.substring(0, idx).trim()
                let value = line.substring(idx + 1).trim()

                if (key === "state") {
                    detailProc.state = value
                } else if (key === "energy-rate") {
                    detailProc.rate = value
                } else if (key === "time to empty" || key === "time to full") {
                    detailProc.timeLine = value + (key === "time to full" ? " to full" : " left")
                }

                let timePart = detailProc.timeLine !== "" ? detailProc.timeLine : "Idle"
                let ratePart = detailProc.rate !== "" ? detailProc.rate : "-- W"
                root.detailText = timePart + "  ·  " + ratePart
            }
        }
    }

    function refreshDetail() {
        detailProc.state = ""
        detailProc.rate = ""
        detailProc.timeLine = ""
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

    Component.onCompleted: batProc.running = true
}
