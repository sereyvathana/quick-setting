
/****************************************************************************

 Copyright (C) 2017 The Qt Company Ltd.
 Contact: https://www.qt.io/licensing/

 This file is part of the examples of the Qt Toolkit.

 $QT_BEGIN_LICENSE:BSD$
 Commercial License Usage
 Licensees holding valid commercial Qt licenses may use this file in
 accordance with the commercial license agreement provided with the
 Software or, alternatively, in accordance with the terms contained in
 a written agreement between you and The Qt Company. For licensing terms
 and conditions see https://www.qt.io/terms-conditions. For further
 information use the contact form at https://www.qt.io/contact-us.

 BSD License Usage
 Alternatively, you may use this file under the terms of the BSD license
 as follows:

 "Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are
 met:
   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
   * Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in
     the documentation and/or other materials provided with the
     distribution.
   * Neither the name of The Qt Company Ltd nor the names of its
     contributdow
qml: you clickors may be used to endorse or promote products derived
     from this software without specific prior written permission.


 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."

 $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.14

ApplicationWindow {
    readonly property bool inPortrait: window.width < window.height
    property bool state1: true

    id: window
    width: screen.width
    height: screen.height
    visible: true
    title: qsTr("Side Panel")
    flags: Qt.WA_TranslucentBackground | Qt.WA_TransparentForMouseEvents
           | Qt.FramelessWindowHint | Qt.X11BypassWindowManagerHint
    color: "transparent"

    x: 0
    y: 0

    ToolBar {
        id: overlayHeader
        width: parent.width
        parent: window.overlay
        Button {
            id: clickbtn
            anchors.right: parent.right
            text: "show menu"
            onClicked: {
                window.state1 = !window.state1
                window.state1 ? drawer.open() : drawer.close()
            }
        }
    }
    Rectangle {
        id: rectid
        MouseArea {
            id: windowMouse
            anchors.fill: parent
            propagateComposedEvents: true
            enabled: true
            onClicked: {

                //                window.flags = Qt.WA_TranslucentBackground
                //                        | Qt.WA_TransparentForMouseEvents | Qt.FramelessWindowHint
                //                        | Qt.MaximizeUsingFullscreenGeometryHint | Qt.WindowTransparentForInput
                //                drawer.close()
                console.log("Press window")
            }
            onExited: {
                drawer.close()
                console.log("you click outside")
            }
        }
        Drawer {
            id: drawer
            edge: Qt.RightEdge
            y: overlayHeader.height
            width: 400
            height: Screen.desktopAvailableHeight
            visible: !inPortrait
            modal: inPortrait
            interactive: inPortrait
            position: inPortrait ? 0 : 1

            ListView {
                id: listView
                anchors.fill: parent
                headerPositioning: ListView.OverlayHeader
                header: Pane {
                    id: header
                    z: 2
                    width: parent.width

                    contentHeight: logo.height

                    MenuSeparator {
                        parent: header
                        width: parent.width
                        anchors.verticalCenter: parent.bottom
                        visible: !listView.atYBeginning
                    }
                }
                footer: ItemDelegate {
                    id: footer
                    text: qsTr("Footer")
                    width: parent.width

                    MenuSeparator {
                        parent: footer
                        width: parent.width
                        anchors.verticalCenter: parent.top
                    }
                }

                model: 10

                delegate: ItemDelegate {
                    text: qsTr("Title %1").arg(index + 1)
                    width: parent.width
                }

                ScrollIndicator.vertical: ScrollIndicator {}
            }
        }
    }
    Component.onCompleted: {
        screen: Qt.application.screens[0]
        window.visible = true
        // This is available in all editors.
        console.log(Screen.virtualX + "\t" + Screen.virtualY)
        window.x = Screen.virtualX
        window.y = Screen.virtualY
        console.log(screen.name)
    }
}
