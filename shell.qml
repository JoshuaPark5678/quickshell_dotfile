import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Niri
import "./modules/bar/"

ShellRoot {
    id: root

    Niri {
        id: niri
        Component.onCompleted: connect()
        onConnected: console.info("Connected to niri")
        onErrorOccurred: function(error) {
            console.error("Niri error:", error)
        }
    }

    Variants {
        model: Quickshell.screens
        delegate: Component {
            Bar {
                property var modelData
                screen: modelData
            }
        }
    }
}
