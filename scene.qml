import QtQuick
import QtQuick3D
import QtQuick.Controls
import QtQuick.Controls.Material

View3D {
    id: view
    width: 1600
    height: 1600
    hoverEnabled: hoverEnabledSw.checked

    environment: SceneEnvironment {
        clearColor: window.color
        backgroundMode: SceneEnvironment.SkyBox
        antialiasingMode: SceneEnvironment.MSAA
        lightProbe: Texture {
            source: "blinds_2k.hdr"
        }
        probeOrientation: Qt.vector3d(probeOrientX.value, probeOrientY.value, 0)
        probeExposure: mainScreen.ambientBrightness
    }

    SpotLight {
        z: 300
        brightness: mainScreen.taskLightBrightness
        ambientColor: Qt.rgba(0.2, 0.2, 0.22, 1.0)
        eulerRotation.y: -20
        coneAngle: 50
        innerConeAngle: 10
    }

    PerspectiveCamera {
        id: camera
        position: Qt.vector3d(112, 93, 218)
    }

    Model {
        id: case_
        source: "meshes/case.mesh"
        eulerRotation: Qt.vector3d(eulerX.value, eulerY.value, eulerZ.value)
        scale: Qt.vector3d(ph.scale, ph.scale, ph.scale)
        pickable: true
        PinchHandler {
            id: ph
            minimumScale: 0.5
            maximumScale: 2.5
        }
        materials: PrincipledMaterial {
            baseColor: "navajowhite"
            roughness: 10
        }
        Model {
            id: button0
            source: "meshes/button0.mesh"
            materials: DefaultMaterial {
                emissiveColor: "cyan"
                emissiveFactor: th0.pressed ? 1 : 0
            }
            z: th0.pressed ? -1 : 0
            pickable: true
            TapHandler {
                id: th0
            }
        }
        Model {
            id: button1
            source: "meshes/button1.mesh"
            materials: DefaultMaterial {
                emissiveColor: "cyan"
                emissiveFactor: th1.pressed ? 0.5 : 0
            }
            z: th1.pressed ? -1 : 0
            pickable: true
            TapHandler {
                id: th1
            }
        }
        Model {
            id: button2
            source: "meshes/button2.mesh"
            materials: DefaultMaterial {
                id: butmat2
                emissiveColor: "cyan"
                SequentialAnimation {
                    id: rightAlarmAnimation
                    loops: Animation.Infinite
                    running: mainScreen.youHaveMail
                    onRunningChanged: if (!running) complete()
                    NumberAnimation {
                        target: butmat2; property: "emissiveFactor"
                        to: 0.8
                        duration: 1000
                        easing.type: Easing.OutBounce
                        easing.overshoot: 2
                    }
                    NumberAnimation {
                        target: butmat2; property: "emissiveFactor"
                        to: 0
                        duration: 100
                    }
                }
            }
            z: th2.pressed ? -1 : 0
            pickable: true
            TapHandler {
                id: th2
                onTapped: mainScreen.goToMail()
            }
            states: [
                State {
                    name: "blinking"
                    PropertyChanges {
                        target: butmat2
                        emissiveFactor: 1
                    }
                }
            ]
        }
        Model {
            source: "#Rectangle"
            pickable: true
            eulerRotation: Qt.vector3d(objEulerX.value, objEulerY.value, objEulerZ.value)
            position: Qt.vector3d(posX.value, posY.value, posZ.value)
            scale: Qt.vector3d(1.6, 1.3, 1)
            materials: DefaultMaterial {
                diffuseMap: Texture {
                    sourceItem: MainScreen {
                        id: mainScreen
                    }
                }
                emissiveColor: "white"
                emissiveFactor: mainScreen.backlightBrightness
            }
        }
    }

    Item {
        id: materialCtrl
        anchors.top: parent.top
        width: 400; height: 100
        z: 10
        Row {
            y: 100
            Column {
                Row {
                    Text { color: "white"; style: Text.Outline; styleColor: "black"; anchors.verticalCenter: parent.verticalCenter;
                        text: "hover enabled" }
                    Switch {
                        id: hoverEnabledSw
                        checked: true
                    }
                }
                Text { color: "white"; style: Text.Outline; styleColor: "black";
                    text: "room spin " + probeOrientX.value.toFixed(2) + " " + probeOrientY.value.toFixed(2) }
                Slider {
                    id: probeOrientX
                    from: -360
                    to: 360
                    value: -35
                }
                Slider {
                    id: probeOrientY
                    from: -360
                    to: 360
                    value: -22
                }
                Text { color: "white"; style: Text.Outline; styleColor: "black";
                    text: "active focus " + Window.activeFocusItem.toString() }
            }
            Column {
                Text { color: "white"; style: Text.Outline; styleColor: "black";
                    text: "model rotation " + eulerX.value.toFixed(2) + " " + eulerY.value.toFixed(2) + " " + eulerZ.value.toFixed(2) }
                Slider {
                    id: eulerX
                    from: -360
                    to: 360
                    value: -64
                }
                Slider {
                    id: eulerY
                    from: -360
                    to: 360
                }
                Slider {
                    id: eulerZ
                    from: -360
                    to: 360
                    value: 248
                }
            }
            Column {
                visible: false
                Text { color: "white"; style: Text.Outline; styleColor: "black";
                    text: "screen pos " + posX.value.toFixed(2) + " " + posY.value.toFixed(2) + " " + posZ.value.toFixed(2) }
                Slider {
                    id: posX
                    from: -360
                    to: 360
                    value: -45
                }
                Slider {
                    id: posY
                    from: -360
                    to: 360
                    value: 90
                }
                Slider {
                    id: posZ
                    from: -360
                    to: 600
                    value: 85.8
                }
                Text { color: "white"; style: Text.Outline; styleColor: "black";
                    text: "screen angle " + objEulerX.value.toFixed(2) + " " + objEulerY.value.toFixed(2) + " " + objEulerZ.value.toFixed(2) }
                Slider {
                    id: objEulerX
                    from: -360
                    to: 360
//                    value: -64
                }
                Slider {
                    id: objEulerY
                    from: 50
                    to: 70
                    value: 62
                }
                Slider {
                    id: objEulerZ
                    from: -360
                    to: 360
                    value: 90
                }
            }
        }
    }
}
