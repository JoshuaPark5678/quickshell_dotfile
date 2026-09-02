import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    spacing: 0
    height: 24

    property string screenName: ""

    BarColors { id: colors }

    Repeater {
        model: niri.workspaces

        Rectangle {
            width: 26
            height: 24
            color: "transparent"
            visible: model.output === screenName

            Text {
                anchors.centerIn: parent
                text: (model.index).toString()
                color: model.isFocused ? colors.accent : model.isActive ? colors.blue : colors.subtext
                font.family: "IosevkaTermSlab Nerd Font"
                font.pixelSize: 12
                font.bold: model.isFocused
            }

            Rectangle {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: 2
                color: model.isFocused ? colors.accent : "transparent"
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: niri.focusWorkspaceById(model.id)
            }
        }
    }
}
