import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import Qt.labs.settings

import QtQuick3D
import QtQuick3D.Helpers
import QtQuick3D.AssetUtils

View3D {
    id: view3D; width: 4000; height: 2000; y: 100; x: 400

    environment: SceneEnvironment { }
//    environment: SceneEnvironment { backgroundMode: SceneEnvironment.Color; clearColor: "#333" }
    DirectionalLight { id: dirl; brightness: obj.phono1sliderValue }
    PerspectiveCamera { id: camera }

    Mixetta {
        id: obj
        position: "0.954, 2.25, 370"
        eulerRotation: "90,0,0"

        phono1rot: slider1.value
        phono2rot: slider1.value
        microlineRot: slider1.value
        tape1rot: slider1.value
        tape2rot: slider1.value

        microbassRot: mbwh.rotation
        levelRot: slider1.value

        Timer {
            id: vuTimer
            interval: 100; repeat: true; running: obj.powerOn
            onTriggered: {
                obj.leftMeterRot = 20 + Math.random() * 40
                obj.rightMeterRot = obj.leftMeterRot + (Math.random() - 0.5) * 5
            }
            onRunningChanged: if (!running) powerOffNeedleAnim.start()
        }
        Behavior on leftMeterRot {
            NumberAnimation { duration: 100 }
        }
        Behavior on rightMeterRot {
            NumberAnimation { duration: 100 }
        }
        NumberAnimation {
            id: powerOffNeedleAnim
            target: obj
            properties: "leftMeterRot,rightMeterRot"
            to: 0
            duration: 700
            easing.type: Easing.OutBounce
            easing.amplitude: 0.7
        }

        // workaround because making rodec_Mixetta_Rodec_Knobs_Power pickable doesn't seem to work
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

        // workaround for rodec_Mixetta_Rodec_Knobs_MicroBass
        Model {
            id: microBassKnobEnvelope
            source: "#Cylinder"
            pickable: true
            scale: "0.03,0.02,0.03"
//            position: Qt.vector3d(sliderx.value, slidery.value, sliderz.value)
            position: "16,1,2"
            materials: DefaultMaterial { diffuseColor: "beige"; opacity: 0.1 }
            WheelHandler { id: mbwh }
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
        visible: false

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
                to: 50
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
                from: -2
                to: 8
                value: 2
            }
            Text {
                color: "white"
                text: sliderx.value.toFixed(3) + ", " + slidery.value.toFixed(3) + ", " + sliderz.value.toFixed(3)
            }
        }
        Text {
            color: "white"
            text: obj.position.toString() + " rot " + obj.rot1.toString()
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
