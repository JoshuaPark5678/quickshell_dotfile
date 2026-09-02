pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // -1 means "not yet checked", shown as "--" in bar
    property int count: -1

    function refresh() {
        if (!checkProc.running)
            checkProc.running = true
    }

    function launchUpdate() {
        if (!updateTerm.running)
            updateTerm.running = true
    }

    Process {
        id: checkProc
        command: ["sh", "-c", "checkupdates 2>/dev/null | wc -l"]

        stdout: SplitParser {
            onRead: function(line) {
                let c = parseInt(line.trim())
                if (isNaN(c)) c = 0
                root.count = c
            }
        }
    }

    Timer {
        id: refreshTimer
        interval: 1800000 // 30 minutes
        running: true
        repeat: true
        onTriggered: root.refresh()
    }

    Process {
        id: updateTerm
        command: ["kitty", "--class", "floating", "-e", "sh", "-c", "yay; echo; read -p 'Press enter to close...'"]
        onExited: root.refresh()
    }

    Component.onCompleted: root.refresh()
}
