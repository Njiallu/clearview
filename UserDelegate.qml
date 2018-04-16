import QtQuick 2.0
import QtQuick.Window 2.0
import QtGraphicalEffects 1.0

Item {

  width: 400
  height: (config.enableHDPI == "true") ? 350 : 250

  property string name: model.name
  property string realName: (model.realName === "") ? model.name : model.realName
  property string icon: model.icon

  //User's Name
  Text {
    id: usersName

    color: "white"
    font {
      family: config.fontFamily
      pointSize: (config.enableHDPI == "true") ? 18 : 22
    }
    text: realName
    anchors.horizontalCenter: parent.horizontalCenter
  }

  //User's Profile Pic
  Image {
    id: usersPic

    width: (config.enableHDPI == "true") ? 192 : 128
    height: (config.enableHDPI == "true") ? 192 : 128
    source: icon
    anchors {
      top: usersName.bottom
      topMargin: 50
      horizontalCenter: parent.horizontalCenter
    }
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

  MouseArea {
    anchors.fill: parent
    onClicked: {
      listView.currentIndex = index;
      page.state = "login";
      loginFrame.name = name
      loginFrame.realName = realName
      loginFrame.icon = icon
      listView.focus = false

	  if (config.autoFocusPassword == "true")
		focusDelay.start();
	  else
        loginFrame.focus = true;
    }
  }

}
