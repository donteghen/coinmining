import Felgo 3.0
import QtQuick 2.0

Item {
  id: splashScreen

  z: 1000

  property int duration: 4000

  signal splashScreenFinished()

  Rectangle {
    id: splashImage
    anchors.fill: parent
    gradient: Gradient {
      GradientStop { position: 0.0; color: "#142A3C" }
      GradientStop { position: 1.0; color: "#080F16" }
    }

    Column {
      id: splashColumn
      anchors.centerIn: parent
      spacing: 10
      Image {
        fillMode: Image.PreserveAspectFit
        width: splashScreen.width * 0.5
        source: "../../assets/img/HomeButton.png"
        anchors.horizontalCenter: parent.horizontalCenter
      }

      Text {
        color: "white"
        text: qsTr("Collect Coins")
        font.family: gameFont.name
        font.pixelSize: splashScreen.height*0.05
        anchors.horizontalCenter: parent.horizontalCenter
      }
      Text {
        color: "white"
        text: qsTr("Become the best!")
        font.family: gameFont.name
        font.pixelSize: splashScreen.height*0.04
        anchors.horizontalCenter: parent.horizontalCenter
      }
    }

   /* MouseArea {
      anchors.fill: parent
      enabled: !system.publishBuild && splashImage.visible
      // use this to highlight the benefits of Felgo Pro: no splash screen, all plugins included
      onClicked: {
       // gAnalytics.logEvent("User Action", "Open Felgo Url", "Splash Screen")
        //nativeUtils.openUrl("https://felgo.com")
     }
    }*/

    visible: true

    z: 1 // put on top of all others here

    Timer {
      // how long the splash will be shown
      // make it 4 seconds (reduced from initial 5 seconds)
      interval: splashScreen.duration
      running: true
      onTriggered: {
        splashImage.opacity = 0
      }
    }

    Behavior on opacity {
      NumberAnimation {
        duration: 300 // faster fade, makes it look more performant
      }
    }

    onOpacityChanged: {
      if(opacity === 0) {
        splashScreen.splashScreenFinished()
        splashImage.visible = false
      }
    }

  }// Splash
} // item
