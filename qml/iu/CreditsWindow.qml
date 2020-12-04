import Felgo 3.0
import QtQuick 2.0


Item {
  id: creditsWindow

  width: 243
  height: 180

  // hide when opacity = 0
  visible: opacity > 0

  // disable when opacity < 1
  enabled: opacity == 1

  // signal when new game button is clicked
  signal backClicked()
  signal vplayClicked()

  Image {
    source: "../../assets/img/CoinCreditsWindow.png"
    anchors.fill: parent
  }

  // back button
  JuicyButton {
    text: qsTr("back to menu")

    // set position
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.bottom
    anchors.topMargin: 0

    onClicked: backClicked()
  }

  // click area for vplay logo
  MouseArea {
    // set area to cover Felgo ad
    width: parent.width - 70
    height: 40
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 18

    onClicked: vplayClicked()
  }

  // fade in/out animation
  Behavior on opacity {
    NumberAnimation { duration: 400 }
  }

  // shows the window
  function show() {
    creditsWindow.opacity = 1
  }

  // hides the window
  function hide() {
    creditsWindow.opacity = 0
  }
}
