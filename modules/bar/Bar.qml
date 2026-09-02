import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: bar

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 24
    color: "transparent"

    BarColors { id: colors }

    Rectangle {
        anchors.fill: parent
        color: Qt.alpha(colors.background, 0.8)

        // Left: Workspaces + Window title
        RowLayout {
            id: leftSection
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
            spacing: 0

            Loader { active: true; sourceComponent: Workspaces { screenName: bar.screen.name } }

            Rectangle {
                color: colors.surface
                Layout.fillHeight: true
                Layout.minimumWidth: 100
                Layout.preferredWidth: 300

                Text {
                    id: titleText
                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                        leftMargin: 10
                        right: parent.right
                        rightMargin: 10
                    }
                    text: niri.focusedWindow?.title ?? ""
                    color: colors.text
                    font.family: "IosevkaTermSlab Nerd Font"
                    font.pixelSize: 12
                    font.italic: true
                    elide: Text.ElideRight
                }
            }

            Cpu {}
            Ram {}

        }

        // Center: Clock
        RowLayout {

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
            spacing: 0

            Cava {}
            Loader { active: true; sourceComponent: Clock {} }
            Cava {}
        }

        // Right: Music, Network, Backlight, Audio, Battery
        RowLayout {
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
                rightMargin: 5
            }
            spacing: 0

            Music {}
            Network {}
            Updates {}
            Backlight {}
            Audio {}
            Battery {}
        }
    }
}
