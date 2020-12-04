import Felgo 3.0
import QtQuick 2.0

Item {
  id: titleWindow

  width: 304
  height: 263

  // hide when opacity = 0
  visible: opacity > 0

  // disable when opacity < 1
  enabled: opacity == 1

  // signal when buttons are clicked
  signal startClicked()
  signal highscoreClicked()
  signal creditsClicked()
  signal vplayClicked()

  Image {
    source: "../../assets/img/CoinTitleWindow.png"
    anchors.fill: parent
  }

  // play button
  Text {
    id: playButton
    // set font
    font.family: gameFont.name
    font.pixelSize: 20
    color: "red"
    text: qsTr("play!")

    // set position
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 70

    // signal click event
    MouseArea {
      anchors.fill: parent
      onClicked: startClicked()
    }

    // this animation sequence changes the color of text between red and orange infinitely
    SequentialAnimation on color {
      loops: Animation.Infinite
      PropertyAnimation {
        to: "#ff8800"
        duration: 1000 // 1 second for fade to orange
      }
      PropertyAnimation {
        to: "red"
        duration: 1000 // 1 second for fade to red
      }
    }
  }

  // highscore score button
  JuicyButton {
    id: highscoreButton
    text: "show highscore"

    // set position
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.bottom
    anchors.topMargin: -10

    onClicked: highscoreClicked()
  }

  // credits button
  JuicyButton {
    text: "credits"

    // set position
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: highscoreButton.bottom
    anchors.topMargin: 0
    onClicked: creditsClicked()
  }

  // click area for vplay text
  MouseArea {
    // set area to cover Felgo ad
    width: parent.width - 130
    height: 25
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 25
    anchors.leftMargin: 75

    onClicked: vplayClicked()
  }

  // click area for vplay logo
  MouseArea {
    // set area to cover Felgo ad
    width: 60
    height: 60
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 15
    anchors.leftMargin: 15

    onClicked: vplayClicked()
  }

  // fade in/out animation
  Behavior on opacity {
    NumberAnimation { duration: 400 }
  }

  // shows the window
  function show() {
    titleWindow.opacity = 1
  }

  // hides the window
  function hide() {
    titleWindow.opacity = 0
  }
}
