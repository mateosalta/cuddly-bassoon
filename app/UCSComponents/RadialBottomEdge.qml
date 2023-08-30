import QtQuick 2.4
import QtFeedback 5.0
import Lomiri.Components 1.3
import QtQuick.Window 2.1

Item {
    id: bottomEdge

    property int hintSize: units.gu(8)
    property color hintColor: "#FF0000"
    property string hintIconName: "youtube-symbolic"
    property alias hintIconSource: hintIcon.source
    property color hintIconColor: "#ffffff"
    property bool bottomEdgeEnabled: true

    property int expandAngle : Screen.orientation == Qt.LandscapeOrientation ? 600 : 250
    property real expandedPosition: (0.85 - 0.25 * expandAngle/360) * height
    property real collapsedPosition: height - hintSize/2

    property list<RadialAction> actions
    property real actionButtonSize: units.gu(7)
    property real actionButtonDistance: 1.6* hintSize

    anchors.fill: parent

    HapticsEffect {
        id: clickEffect
        attackIntensity: 0.0
        attackTime: 100
        intensity: 2.0
        duration: 20
        fadeTime: 50
        fadeIntensity: 0.0
    }

    Rectangle {
        id: bgVisual

        z: 1
        visible: bottomEdgeHint.y !== collapsedPosition
        color: "black"
        anchors.fill: parent
        opacity: 0.9 * (((bottomEdge.height - bottomEdgeHint.y) / bottomEdge.height) * 2)/((expandAngle * .003))

        MouseArea {
            anchors.fill: parent
            enabled: bgVisual.visible
            onClicked: bottomEdgeHint.state = "collapsed"
            z: 1
        }

    }

    Rectangle {
        id: bottomEdgeHint

        color: hintColor
        width: hintSize
        height: width
        radius: width
        visible: bottomEdgeEnabled

        anchors.horizontalCenter: parent.horizontalCenter
        y: collapsedPosition
        z: parent.z + 1

        Rectangle {
            id: dropShadow
            width: parent.width
            height: parent.height
            border.color: "#000000"
            color: "Transparent"
            radius: parent.radius + 1
            z: -1
            anchors {
                centerIn: parent
                verticalCenterOffset: -1 //units.gu(-0.3)
            }
        }

        Icon {
            id: hintIcon
            width: hintSize/4
            height: width
            name: hintIconName
            color: hintIconColor
            anchors {
                centerIn: parent
                verticalCenterOffset: width * ((bottomEdgeHint.y - expandedPosition)
                                               /(expandedPosition - collapsedPosition))
            }
        }

        property real actionListDistance: -actionButtonDistance * ((bottomEdgeHint.y - collapsedPosition)
                                                                   /(collapsedPosition - expandedPosition))

        Repeater {
            id: actionList
            model: actions
            delegate: Rectangle {
                id: actionDelegate
                readonly property real radAngle: (index % actionList.count * (360/actionList.count)) * Math.PI / 180
                property real distance: bottomEdgeHint.actionListDistance
                z: -1
                width: actionButtonSize
                height: width
                radius: width/2
                anchors.centerIn: parent
                color: modelData.backgroundColor
                opacity: modelData.enabled ? 1.0 : 0.7
                transform: Translate {
                    x: distance * Math.sin(radAngle)
                    y: -distance * Math.cos(radAngle)
                }

                Icon {
                    id: icon
                    anchors.centerIn: parent
                    width: parent.width/2
                    height: width
//                    name: !modelData.iconSource ? modelData.iconName : undefined
//                    source: modelData.iconSource ? Qt.resolvedUrl(modelData.iconSource) : undefined
                    color: modelData.iconColor
                    opacity: modelData.enabled ? 1.0 : 0.2
                    Component.onCompleted: modelData.iconSource ? source = Qt.resolvedUrl(modelData.iconSource) : name = modelData.iconName
                }

                Label {
                    visible: text && bottomEdgeHint.state == "expanded"
                    text: modelData.text
                    anchors {
                        top: !modelData.top ? icon.bottom : undefined
                        topMargin: !modelData.top ? units.gu(3) : undefined
                        bottom: modelData.top ? icon.top : undefined
                        bottomMargin: modelData.top ? units.gu(3) : undefined
                        horizontalCenter: icon.horizontalCenter
                    }
                    color: "#ffffff"
                    font.bold: true
                    fontSize: "medium"

                }

                MouseArea {
                    anchors.fill: parent
                    enabled: modelData.enabled
                    onClicked: {
                        clickEffect.start()
                        bottomEdgeHint.state = "collapsed"
                        modelData.triggered(null)
                    }
                }
            }
        }

        MouseArea {
            id: mouseArea

            property real previousY: -1
            property string dragDirection: "None"

            z: 1
            anchors.fill: parent
            visible: bottomEdgeEnabled

            preventStealing: true
            drag {
                axis: Drag.YAxis
                target: bottomEdgeHint
                minimumY: expandedPosition
                maximumY: collapsedPosition
            }

            onReleased: {
                if ((dragDirection === "BottomToTop") &&
                        bottomEdgeHint.y < collapsedPosition) {
                    bottomEdgeHint.state = "expanded"
                } else {
                    if (bottomEdgeHint.state === "collapsed") {
                        bottomEdgeHint.y = collapsedPosition
                    }
                    bottomEdgeHint.state = "collapsed"
                }
                previousY = -1
                dragDirection = "None"
            }

            onClicked: {
                if (bottomEdgeHint.y === collapsedPosition)
                    bottomEdgeHint.state = "expanded"
                else
                    bottomEdgeHint.state = "collapsed"
            }

            onPressed: {
                previousY = bottomEdgeHint.y

            }

            onMouseYChanged: {
                var yOffset = previousY - bottomEdgeHint.y
                if (Math.abs(yOffset) <= units.gu(2)) {
                    return
                }
                previousY = bottomEdgeHint.y
                dragDirection = yOffset > 0 ? "BottomToTop" : "TopToBottom"
            }
        }

        state: "collapsed"
        states: [
            State {
                name: "collapsed"
                PropertyChanges {
                    target: bottomEdgeHint
                    y: collapsedPosition
                }
            },
            State {
                name: "expanded"
                PropertyChanges {
                    target: bottomEdgeHint
                    y: expandedPosition
                }
            },

            State {
                name: "floating"
                when: mouseArea.drag.active
            }
        ]

        transitions: [
            Transition {
                to: "expanded"
                SpringAnimation {
                    target: bottomEdgeHint
                    property: "y"
                    spring: 2
                   damping: .2
                 // epsilon: .05
                }
            },

            Transition {
                to: "collapsed"
                SmoothedAnimation {
                    target: bottomEdgeHint
                    property: "y"
                    duration: UbuntuAnimation.BriskDuration
                }
            }
        ]
    }
}
