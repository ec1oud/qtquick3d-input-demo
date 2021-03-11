import QtQuick
import QtQuick.Controls.Material

Rectangle {
    id: root
    width: 240; height: 60
    anchors.centerIn: parent
    color: "black"
    border.color: Material.accentColor
    border.width: 3
    radius: 5
    antialiasing: true
    property alias text: text.text

    Text {
        id: text
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        color: "white"
        text: "Hello world!"
        width: parent.width
        font.pointSize: 18

        NumberAnimation on font.letterSpacing { from: 0; to: 50; easing.type: Easing.InQuart; duration: 3000 }
        NumberAnimation on opacity {
            from: 1; to: 0; duration: 2600; easing.type: Easing.InQuad
            onFinished: closeAnimation.start()
        }
    }

    NumberAnimation on height {
        id: closeAnimation
        running: false
        to: 0; duration: 200; easing.type: Easing.InBack
        onFinished: root.destroy(100)
    }
}
