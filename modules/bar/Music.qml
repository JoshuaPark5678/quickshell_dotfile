import QtQuick
import QtQuick.Layouts
import Quickshell.Io

Rectangle {
    id: root
    clip: true
    color: "transparent"
    Layout.fillHeight: true
    Layout.preferredWidth: Math.min(200, Math.max(50, contentMetrics.width + leftMargin + rightMargin))

    readonly property int leftMargin: 14
    readonly property int rightMargin: 14

    BarColors { id: colors }

    property string fullText: ""
    property string logicalText: fullText.length > 0 ? fullText : "󰎈 No music"
    property bool needsScroll: contentMetrics.width > (width - leftMargin - rightMargin)
    property real loopWidth: contentMetrics.width + gapMetrics.width

    TextMetrics {
        id: contentMetrics
        font: musicText.font
        text: root.logicalText
    }

    TextMetrics {
        id: gapMetrics
        font: musicText.font
        text: "     "
    }

    Text {
        id: musicText
        text: root.needsScroll
            ? root.logicalText + "     " + root.logicalText
            : root.logicalText
        x: root.leftMargin
        anchors.verticalCenter: parent.verticalCenter
        color: root.fullText.length > 0 ? colors.text : colors.subtext
        font.family: "IosevkaTermSlab Nerd Font"
        font.pixelSize: 11
    }

    NumberAnimation {
        id: scrollAnim
        target: musicText
        property: "x"
        from: root.leftMargin
        to: root.leftMargin - root.loopWidth
        duration: root.loopWidth * 30
        loops: Animation.Infinite
        running: root.needsScroll

        onRunningChanged: {
            if (!running) musicText.x = root.leftMargin
        }
    }

    onNeedsScrollChanged: {
        scrollAnim.stop()
        musicText.x = root.leftMargin
        if (needsScroll) scrollAnim.start()
    }

    onFullTextChanged: {
        scrollAnim.stop()
        musicText.x = root.leftMargin
        if (needsScroll) scrollAnim.start()
    }

    Process {
        id: playerctlProc
        command: ["playerctl", "metadata", "--format", "{{ artist }} - {{ title }}"]
        running: false
        stdout: SplitParser {
            onRead: function(line) {
                let clean = line.trim()
                if (clean === "" || clean.includes("No players")) {
                    root.fullText = ""
                } else if (clean !== root.fullText) {
                    root.fullText = clean
                }
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            playerctlProc.running = false
            playerctlProc.running = true
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
          playPause.running = false
          playPause.running = true
        }
    }

    Process { id: playPause; command: ["playerctl", "play-pause"] }
    Process { id: nextTrack; command: ["playerctl", "next"] }
    Process { id: prevTrack; command: ["playerctl", "previous"] }
}
