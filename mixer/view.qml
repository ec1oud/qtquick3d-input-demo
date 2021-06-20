import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import Qt.labs.settings

import QtQuick3D
import QtQuick3D.Helpers
import QtQuick3D.AssetUtils

View3D {
    id: view3D; width: 2000; height: 1000

    environment: SceneEnvironment { backgroundMode: SceneEnvironment.Color; clearColor: "#333" }
    DirectionalLight { id: dirl; brightness: obj.phono1sliderValue }
    PerspectiveCamera { id: camera }

    Mixetta {
        id: obj
//        visible: false
        position: "0.954, 2.25, 370"
        eulerRotation: "90,0,0"

        phono1rot: ph1wh.rotation
        phono2rot: slider1.value
        microlineRot: slider1.value
        tape1rot: slider1.value
        tape2rot: slider1.value

        microbassRot: slider1.value
        levelRot: slider1.value

        Timer {
            id: vuTimer
            interval: 50; repeat: true; running: obj.powerOn
            onTriggered: {
                obj.leftMeterRot = 20 + Math.random() * 30
                obj.rightMeterRot = obj.leftMeterRot + (Math.random() - 0.5) * 5
            }
            onRunningChanged: if (!running) {

                              }
        }
        Behavior on leftMeterRot {
            NumberAnimation { duration: 100 }
        }
        Behavior on rightMeterRot {
            NumberAnimation { duration: 100 }
        }

        // workaround because making rodec_Mixetta_Rodec_Knobs_Power pickable doesn't sem to work
        Model {
            id: powerKnobEnvelope
            source: "#Cylinder"
            pickable: true
            scale: "0.03,0.02,0.03"
            position: "16,1,7"
            materials: DefaultMaterial { diffuseColor: pwkth.pressed ? "tomato" : "beige"; opacity: 0.1 }
            property bool powerOn: false
            TapHandler {
                id: pwkth
                onPressedChanged: if (!pressed) obj.powerOn = !obj.powerOn
            }
        }

        // workaround for rodec_Mixetta_Rodec_Knobs_Phono1
        Model {
            id: phono1KnobEnvelope
            source: "#Cylinder"
            pickable: true
            scale: "0.03,0.02,0.03"
//            position: Qt.vector3d(sliderx.value, slidery.value, sliderz.value)
            position: "-17.8,1,-2.2"
            materials: DefaultMaterial { diffuseColor: "beige"; opacity: 0.1 }
            WheelHandler {
                id: ph1wh
            }
        }
    }
//    WasdController { controlledObject: camera }

    function resetView() {
        camera.position = "0, 0, 400"
        obj.eulerRotation = "90, 0, 0"
    }
    Component.onCompleted: resetView()

    Row {
        x: 6; y: 6

//        Image {
//            source: "resources/view-refresh.png"
//            TapHandler { onTapped: view3D.resetView() }
//        }
//        Image {
//            width: 32; height: 32; opacity: axes.visible ? 1 : 0.5
//            source: "resources/noun_3D_2353959.svg"
//            TapHandler { onTapped: axes.visible = !axes.visible }
//        }
        Column {
            Slider {
                id: slider1
                from: 0
                to: 270
            }
            Text { color: "white"; text: slider1.value.toFixed(3) }
//            Slider {
//                id: slider2
//                from: 0
//                to: 10
//                value: 0.05
//            }
            Text { color: "white"; text: "Dir Light " + dirl.brightness.toFixed(3) }
        }
        Column {
            Slider {
                id: sliderx
                from: 0
                to: 100
                value: 16
            }
            Slider {
                id: slidery
                from: 0
                to: 20
                value: 1
            }
            Slider {
                id: sliderz
                from: 4
                to: 8
                value: 7
            }
            Text {
                color: "white"
                text: sliderx.value.toFixed(3) + ", " + slidery.value.toFixed(3) + ", " + sliderz.value.toFixed(3)
            }
        }
        Text {
            color: "white"
            text: obj.position.toString() + " rot " + obj.eulerRotation.toString()
        }
//        Text {
//            color: "white"
//            text: obj.display1.toFixed(3) + "\n" + obj.display2.toFixed(3)
//        }
//        Text {
//            color: "white"
//            text: obj.vis ? "☒ vis" : "☐ invis"
//            TapHandler {
//                onTapped: obj.vis = !obj.vis
//            }
//        }
    }
}
