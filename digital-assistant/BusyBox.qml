import QtQuick

Rectangle {
    id: root
    objectName: "busybox"
    height: 640
    width: 640

    color: "#444"

    property var toastComponent: Qt.createComponent("Toast.qml")

    component HoverTapButton: Rectangle {
        id: htbutton
        property string name: ""
        objectName: name + " handlers button"
        property  alias pressed: utap.pressed
        property point lastPressPos: Qt.point(-1, -1)
        property point lastReleasePos: Qt.point(-1, -1)
        property int clickedCount: 0
        signal tapped
        onPressedChanged: {
            if (pressed)
                lastPressPos = utap.point.position;
            else
                lastReleasePos = utap.point.position;
        }
        width: 120; height: 40
        color: utap.pressed ? "tomato" : "beige"
        radius: 5
        border.width: 3
        border.color: uhover.hovered ? "orange" : "black"
        antialiasing: true
        HoverHandler {
            id: uhover
            objectName: htbutton.name + " HoverHandler"
            cursorShape: Qt.OpenHandCursor
        }
        TapHandler {
            id: utap
            objectName: htbutton.name + " TapHandler"
            onTapped: {
                ++clickedCount
                console.log("----------------- tap ", utap.point.position.toString())
                toastComponent.createObject(root, {text: "Tap @ " + utap.point.position.x.toFixed(2) + ", " + utap.point.position.y.toFixed(2)});
                htbutton.tapped()
            }
        }
        Text {
            anchors.centerIn: parent
            text: "hover & tap"
        }
    }

    HoverHandler {
        id: feedback
        objectName: root.objectName + " hover position feedback"
        target: Rectangle {
            color: "orange"
            parent: root
            x: feedback.point.position.x - width / 2
            y: feedback.point.position.y - height / 2
            width: 10; height: width; radius: width
        }
    }

    Text {
        color: "orange"
        text: "hover " + feedback.point.position.x.toFixed(1) + ", " + feedback.point.position.y.toFixed(1)
        anchors.bottom: parent.bottom
        anchors.margins: 12
        x: 12
    }

    Row {
        x: 10; y: 10; z: 1
        spacing: 10
        Column {
            spacing: 10
            HoverTapButton {
                name: root.objectName + " upper"
            }
            HoverTapButton {
                name: root.objectName + " lower"
            }
            Rectangle {
                objectName: root.objectName + " mousearea button"
                width: 120; height: 40
                color: ma.pressed ? "tomato" : "beige"
                radius: 5
                border.width: 3
                border.color: ma.containsMouse ? "orange" : "black"
                antialiasing: true
                MouseArea {
                    id: ma
                    objectName: root.objectName + " button mousearea"
                    anchors.fill: parent
                    hoverEnabled: true
                    property point lastPressPos: Qt.point(-1, -1)
                    property point lastReleasePos: Qt.point(-1, -1)
                    property int clickedCount: 0
                    onPressed: (mouse) => { lastPressPos = Qt.point(mouse.x, mouse.y) }
                    onReleased: (mouse) => { lastReleasePos = Qt.point(mouse.x, mouse.y) }
                    onClicked: ++clickedCount
                }
                Text {
                    anchors.centerIn: parent
                    text: "hover & click"
                }
            }
            TextInput {
                text: "Editable Text"
                color: "cyan"
            }
            TextInput {
                text: "More Editable Text"
                color: "cyan"
            }
        }
        DragAnywhereSlider { }
    }
}
