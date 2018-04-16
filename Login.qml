import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0

Item {
  id: loginFrame

  width: page.width
  height: page.height
  anchors.horizontalCenter: page.horizontalCenter
  anchors.verticalCenter: page.verticalCenter

  property string name
  property string realName
  property string icon
  focus: false

  Behavior on opacity {
    NumberAnimation { duration: 150; easing.type: Easing.InOutQuad }
  }

  //Functions:

  //Logins in with current details
  function login() {
    loginFrame.opacity = 0;
    sddm.login(loginFrame.name, passwordInput.text, sessionSelect.currentIndex);
  }

  //Goes back to user select
  function back() {
    page.state = "";
    listView.focus = true;
  }

  function focusPassword() {
    passwordInput.focus = true;
  }

  KeyNavigation.tab: passwordInput
  Keys.onEscapePressed: back()

  Connections {
    target: sddm
    onLoginSucceeded: {
    }

    onLoginFailed: {
      loginFrame.opacity = 1;
      passwordInput.text = ""
      passwordStatus.opacity = 1;
      passwordTimer.start();
    }
  }

  states: State {
      name: "active"
      when: passwordInput.activeFocus == true || passwordInput.text != ""

      PropertyChanges {
        target: defaultPasswordText
        opacity: 0
      }

      PropertyChanges {
        target: submitPassword
        opacity: 1
      }

      PropertyChanges {
        target: passwordUnderline
        height: 50
      }
  }

  transitions: Transition {
    from: ""
    to: "active"
    reversible: true

    PropertyAnimation {
      properties: "opacity"
      easing.type: Easing.InOutQuad
      duration: 350
    }

    PropertyAnimation {
      properties: "height"
      easing.type: Easing.InOutQuad
      duration: 350
    }
  }

  //Back Button
  Image {

    anchors {
      right: userProfile.left
      rightMargin: 30
    }
    y: parent.height / 2 - 40
    width: 32
    height: 32
    source: "Assets/Selector.png"
    transform: Rotation { origin.x : 16; origin.y: 16; angle: 270}

    MouseArea {
      anchors.fill: parent
      onClicked: {
        loginFrame.back();
      }
    }
  }

  Item {
    id: userProfile

    width: (config.enableHDPI == "true") ? 450 : 350
    height: (config.enableHDPI == "true") ? 450 : 350

    y:0
	visible: true
    anchors {
      horizontalCenter: parent.horizontalCenter
      verticalCenter: parent.verticalCenter
    }

    //User's Name
    Text {
      id: usersName

      color: "white"
      font {
        family: config.fontFamily
        pointSize: (config.enableHDPI == "true") ? 22 : 32
      }
      text: loginFrame.realName
      anchors.horizontalCenter: parent.horizontalCenter
    }

    //User's Profile Pic
    Image {
      id: usersPic

      source: loginFrame.icon
      width: (config.enableHDPI == "true") ? 192 : 128
      height: (config.enableHDPI == "true") ? 192 : 128
      anchors {
        top: usersName.bottom
        topMargin: 50
        horizontalCenter: parent.horizontalCenter
      }
      fillMode: Image.PreserveAspectCrop
      layer.enabled: true
      layer.effect: OpacityMask {
        maskSource: mask
      }
    }

    Rectangle {
      id: mask
      width: (config.enableHDPI == "true") ? 192 : 128
      height: (config.enableHDPI == "true") ? 192 : 128
      radius: (config.enableHDPI == "true") ? 96 : 64
      visible: false
    }

  }

  Text {
    id: passwordStatus

    text: "Incorrect Password!"
    color: "gray"
    font {
      pointSize: 10
      family: config.fontFamily
    }

    anchors {
      horizontalCenter: parent.horizontalCenter
      bottom: passwordBox.top
      bottomMargin: 20
    }

    opacity: 0

    Timer {
      id: passwordTimer
      interval: 1000
      running: false
      repeat: false
      onTriggered: {
        passwordStatus.opacity= 0
      }
    }

    Behavior on opacity {
      NumberAnimation{
        duration: 500
        easing.type: Easing.InOutQuad
      }
    }

  }

  Item {
    id: passwordBox

    width: 300
    height: 50
    anchors {
      horizontalCenter: parent.horizontalCenter
      top: userProfile.bottom
      topMargin: -75
    }

    Text {
      id: defaultPasswordText

      anchors {
        fill: parent
        topMargin: 15
        leftMargin: 15
      }
      text: "Password..."
      color: "white"
      font {
        pointSize: (config.enableHDPI == "true") ? 11 : 14
        family: config.fontFamily
      }
      opacity: 0.15
    }

    TextInput {
      id: passwordInput

      verticalAlignment: TextInput.AlignVCenter
      anchors {
        fill: parent
        leftMargin: 15
        rightMargin: 50
      }
      font {
        pointSize: (config.enableHDPI == "true") ? 13 : 14
        family: config.fontFamily
        letterSpacing: 2
      }
      color: "white"
      echoMode:TextInput.Password
      clip: true

      onAccepted: {
        loginFrame.login()
      }

    }

    Image {
      id: submitPassword

      x: 260
      y: 10
      width: 30
      height: 30
      opacity: 0
      source: "Assets/RightArrow.png"

      MouseArea {
        anchors.fill: parent
        onClicked: {
          loginFrame.login()
        }
      }
    }

  }

  Rectangle {
    id: passwordUnderline

    width: passwordBox.width
    height: 1
    anchors {
      bottom: passwordBox.bottom
      left: passwordBox.left
    }
    color: "white"
    opacity: 0.15
    radius: 4
  }

}
