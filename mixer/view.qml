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
    DirectionalLight { }
    DirectionalLight { eulerRotation.x: 180 }
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

        microbassRot: slider1.value
        levelRot: slider1.value

        leftMeterRot: slider1.value
        rightMeterRot: slider1.value
    }
//    WasdController { controlledObject: obj }

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
        Slider {
            id: slider1
            from: 0
            to: 270
        }
        Text {
            color: "white"
            text: obj.position.toString() + " rot " + obj.eulerRotation.toString()
        }
        Text {
            color: "white"
            text: obj.display1.toFixed(3) + "\n" + obj.display2.toFixed(3)
        }
//        Text {
//            color: "white"
//            text: obj.vis ? "☒ vis" : "☐ invis"
//            TapHandler {
//                onTapped: obj.vis = !obj.vis
//            }
//        }
    }
}
