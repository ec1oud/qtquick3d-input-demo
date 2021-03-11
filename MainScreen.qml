import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Item {
    Material.theme: Material.Dark
    property alias backlightBrightness: backlightSlider.value
    property alias ambientBrightness: ambientSlider.value
    property alias taskLightBrightness: taskSlider.value
    property bool youHaveMail: mailTab.state !== ""
    function goToMail() {
        tabs.currentIndex = 4
    }
    width: 640; height: 640
    TabBar {
        id: tabs
        width: parent.width
        onCurrentIndexChanged: mailTimer.running = true
        TabButton {
            text: "Lighting"
        }
        TabButton {
            text: "Plain Qt Quick"
        }
        TabButton {
            text: "🪟"
            width: 80
        }
        TabButton {
            text: "⚙"
            width: 80
        }
        TabButton {
            id: mailTab
            text: "📪"
            states: [
                State {
                    name: "active"
                    PropertyChanges { target: mailTab; text: "📬" }
                }
            ]
            width: 80
            Timer {
                id: mailTimer
                interval: 50000
                onTriggered: mailTab.state = "active"
            }
        }
    }

    StackLayout {
        id: swipeview

        currentIndex: tabs.currentIndex
        anchors.fill: parent
        anchors.topMargin: tabs.height

        Pane {
            id: lightingPage
            GridLayout {
                anchors.centerIn: parent
                flow: GridLayout.TopToBottom
                rows: 2
                columnSpacing: 20

                Slider {
                    id: ambientSlider
                    orientation: Qt.Vertical
                    from: 0.1
                    to: 2
                    value: 0.25
                }
                Label { text: "ambiance" }

                Slider {
                    id: taskSlider
                    orientation: Qt.Vertical
                    from: 0
                    to: 10
                    value: 0
                }
                Label { text: "task lighting" }
            }
        }
        BusyBox {
            id: testPage
        }
        Item {
            id: emptyPage
            // window into the soul of the machine
        }
        Pane {
            Column {
                id: settingsPage
                Item {
                    height: 300
                }

                Label {
                    text: "Brightness"
                }
                Slider {
                    id: backlightSlider
                    from: 0.1
                    to: 1
                    value: 0.75
                }
            }
        }
        Rectangle {
            color: "#444"
            RowLayout {
                spacing: 12
                Button {
                    text: "Mark All Read"
                    onClicked: mailTab.state = ""
                }
                Button {
                    text: composePopup.visible ? "Nevermind" : "Compose"
                    onClicked: composePopup.visible = !composePopup.visible
                }
                Button {
                    visible: composePopup.visible
                    text: "Send"
                    onClicked: composePopup.visible = false
                }
            }
            Rectangle {
                id: composePopup
                color: "#333"
                border.color: Material.foreground
                visible: false
                width: 500; height: 400; anchors.centerIn: parent
                GridLayout {
                    anchors.fill: parent
                    anchors.margins: 6
                    columns: 2
                    Label { text: "To:" }
                    TextField { Layout.fillWidth: true }
                    TextArea {
                        Layout.columnSpan: 2
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }
                }
            }
        }
    }
}
