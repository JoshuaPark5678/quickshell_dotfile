import QtQuick
import Quickshell.Io

Text {
    id: root
    color: colors.text
    font.family: "IosevkaTermSlab Nerd Font"
    font.pixelSize: 13
    font.bold: true
    leftPadding: 15
    rightPadding: 15
    topPadding: 4
    BarColors { id: colors }

    property bool expanded: false

    Process {
        id: dateProc
        command: root.expanded
            ? ["date", "+%A, %B %d, %I:%M:%S %p"]
            : ["date", "+%I:%M %p"]
        running: true

        stdout: SplitParser {
            onRead: function(line) {
                root.text = line
            }
        }
    }

    Timer {
        interval: root.expanded ? 1000 : 10000
        running: true
        repeat: true
        onTriggered: dateProc.running = true
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.expanded = !root.expanded
            dateProc.running = true
        }
    }
}
