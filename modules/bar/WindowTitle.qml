import QtQuick
import Quickshell.Io

Rectangle {
    id: root
    color: colors.surface
    implicitHeight: 27
    implicitWidth: Math.min(titleText.contentWidth + 20, 400)

    BarColors { id: colors }

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
