import QtQuick 2.15
import SddmComponents 2.0

FocusScope {
    id: root
    width: 1920
    height: 1080
    focus: true

    readonly property color violet: "#d580ff"
    readonly property color lavender: "#cba6f7"
    readonly property color textColor: "#cdd6f4"
    readonly property color muted: "#a6adc8"
    readonly property color fieldFill: "#c911111b"
    readonly property color fieldBorder: "#b8d580ff"
    readonly property string themeFont: config.font || "Geist Mono Nerd Font"
    property string statusText: ""
    property color statusColor: textColor
    property date now: new Date()

    function submit() {
        if (password.text.length > 0)
            sddm.login(userName.text, password.text, session.index)
    }

    Image {
        anchors.fill: parent
        source: Qt.resolvedUrl(config.background || "assets/dresden-moonlight.jpg")
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
    }

    // Keeps the image contrast close to the lockscreen without making text hard to read.
    Rectangle {
        anchors.fill: parent
        color: "#1f080e20"
    }

    Timer {
        id: clockTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.now = new Date()
    }

    // Hyprlock's positive Y offsets move upward from screen centre; QML's do not.
    // These shadow layers preserve Hyprlock's explicit dark text shadows.
    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 3
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -467
        text: Qt.formatDate(root.now, "ddd, dd MMM").toUpperCase()
        color: "#8c000000"
        font.family: root.themeFont
        font.pixelSize: 22
        font.bold: true
    }

    Text {
        id: dateText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -470
        text: Qt.formatDate(root.now, "ddd, dd MMM").toUpperCase()
        color: root.textColor
        font.family: root.themeFont
        font.pixelSize: 22
        font.bold: true
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: 4
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -366
        text: Qt.formatTime(root.now, "hh:mm")
        color: "#a6000000"
        font.family: root.themeFont
        font.pixelSize: 104
        font.bold: true
    }

    Text {
        id: timeText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -370
        text: Qt.formatTime(root.now, "hh:mm")
        color: root.violet
        font.family: root.themeFont
        font.pixelSize: 104
        font.bold: true
    }

    Text {
        id: userName
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: passwordPill.top
        anchors.bottomMargin: 12
        text: userModel.lastUser
        color: root.muted
        font.family: root.themeFont
        font.pixelSize: 14
        visible: text.length > 0
    }

    Rectangle {
        id: passwordPill
        width: 210
        height: 42
        radius: height / 2
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Math.max(42, parent.height * 0.07)
        color: root.fieldFill
        border.width: password.activeFocus ? 2 : 1
        border.color: password.activeFocus ? root.violet : root.fieldBorder

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 18
            anchors.verticalCenter: parent.verticalCenter
            visible: password.text.length === 0
            text: "Enter password"
            color: root.muted
            font.family: root.themeFont
            font.pixelSize: 14
            font.italic: true
        }

        TextInput {
            id: password
            anchors.fill: parent
            anchors.leftMargin: 18
            anchors.rightMargin: 18
            verticalAlignment: TextInput.AlignVCenter
            color: root.textColor
            font.family: root.themeFont
            font.pixelSize: 15
            echoMode: TextInput.Password
            passwordCharacter: "•"
            focus: true
            clip: true
            onAccepted: root.submit()
        }
    }

    Text {
        anchors.top: passwordPill.bottom
        anchors.topMargin: 9
        anchors.horizontalCenter: parent.horizontalCenter
        text: root.statusText
        color: root.statusColor
        font.family: root.themeFont
        font.pixelSize: 12
        visible: text.length > 0
    }

    ComboBox {
        id: session
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.leftMargin: 26
        anchors.bottomMargin: 22
        width: 175
        height: 30
        model: sessionModel
        index: sessionModel.lastIndex
        font.family: root.themeFont
        font.pixelSize: 12
        color: root.muted
        arrowIcon: Qt.resolvedUrl("")
    }

    Text {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 26
        anchors.bottomMargin: 28
        text: "⏻  Power off     ↻  Restart"
        color: root.muted
        font.family: root.themeFont
        font.pixelSize: 12

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                if (mouse.x < parent.width / 2)
                    sddm.powerOff()
                else
                    sddm.reboot()
            }
        }
    }

    Connections {
        target: sddm
        function onLoginSucceeded() {
            root.statusColor = root.lavender
            root.statusText = "Logging in…"
        }
        function onLoginFailed() {
            password.text = ""
            password.forceActiveFocus()
            root.statusColor = "#f38ba8"
            root.statusText = "Incorrect password"
        }
        function onInformationMessage(message) {
            root.statusColor = "#f38ba8"
            root.statusText = message
        }
    }

    Keys.onPressed: function(event) {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            root.submit()
            event.accepted = true
        }
    }
}
