import QtQuick

Text {
    id: root
    color: UpdatesState.count === -1 ? colors.yellow : UpdatesState.count === 0 ? colors.green : UpdatesState.count >= 15 ? colors.red : colors.yellow
    font.family: "IosevkaTermSlab Nerd Font"
    font.pixelSize: 12
    leftPadding: 10
    rightPadding: 10
    text: UpdatesState.count === -1 ? "󰏗 --" : "󰏗 " + UpdatesState.count

    BarColors { id: colors }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: UpdatesState.launchUpdate()
    }
}
