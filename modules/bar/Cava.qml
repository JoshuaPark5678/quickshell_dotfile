import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Item {
    id: root
    Layout.fillHeight: true
    Layout.preferredWidth: barCount * barWidth + (barCount - 1) * barSpacing
    readonly property int barCount: 16
    readonly property int barWidth: 3
    readonly property int barSpacing: 2
    readonly property int maxBarHeight: 18
    readonly property int maxRange: 100
    
    property var levels: Array(barCount).fill(0)
    property string barColor: "#89b4fa"

    // Color is written by ~/.config/niri/scripts/wp.sh (cava-bar.color) so
    // it follows the current wallpaper scheme. blockAllReads makes the first
    // text() read synchronous so the saved color applies on bar startup.
    // fileChanged only signals that the file changed on disk; it does not
    // reload the cached text, so we have to call reload() and pick the new
    // value up once it actually lands (onLoaded), not synchronously here.
    FileView {
        id: colorFile
        path: "/home/jesh/.config/quickshell/niri-bar/scripts/cava-bar.color"
        watchChanges: true
        blockAllReads: true

        onFileChanged: reload()
        onLoaded: { root.barColor = text().trim() || root.barColor }
        Component.onCompleted: { root.barColor = text().trim() || root.barColor }
    }

    Repeater {
        model: root.barCount

        delegate: Rectangle {
            x: index * (root.barWidth + root.barSpacing)
            anchors.verticalCenter: root.verticalCenter
            width: root.barWidth
            radius: 1
            color: root.barColor
            height: Math.max(2, (root.levels[index] / root.maxRange) * root.maxBarHeight)

            Behavior on height {
                NumberAnimation { duration: 50 }
            }

            Behavior on color {
                ColorAnimation { duration: 200 }
            }
        }
    }

    Process {
        id: cavaProc
        command: ["cava", "-p", "/home/jesh/.config/quickshell/niri-bar/scripts/cava-bar.conf"]
        running: true

        stdout: SplitParser {
            onRead: function(line) {
                let parts = line.split(";").filter(p => p.length > 0)
                if (parts.length === root.barCount) {
                    root.levels = parts.map(p => parseInt(p))
                    watchdog.receivedData = true
                }
            }
        }
    }

    // cava can start before pipewire/the default audio device is ready
    // (e.g. at niri startup, or a bluetooth sink reconnecting), and then
    // never picks up audio. Restart it if no frames have arrived recently.
    Timer {
        id: watchdog
        interval: 3000
        repeat: true
        running: true
        property bool receivedData: false

        onTriggered: {
            if (!receivedData) {
                cavaProc.running = false
                cavaProc.running = true
            }
            receivedData = false
        }
    }

    Component.onDestruction: cavaProc.running = false
}
