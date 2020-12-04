import Felgo 3.0
import QtQuick 2.0

Item {
  id: button

  width: 162
  height: 45

  property string text

  // signal when buttons are clicked
  signal clicked()

  // background
  Image {
    source: "../../assets/img/ButtonBG.png"
    anchors.fill: parent
  }

  // text
  Text {
    // set font
    font.family: gameFont.name
    font.pixelSize: 12
    color: "red"
    text: qsTr(button.text)

    // set position
    anchors.horizontalCenter: parent.horizontalCenter
    y: 15
  }

  // signal click event
  MouseArea {
    anchors.fill: parent
    onClicked: button.clicked()
  }
}
