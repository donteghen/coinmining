import Felgo 3.0
import QtQuick 2.0

Item {
  id: juicyMeter
  property double percentage
  property string color1: "#ffff00"
  property string color2: "#ffaa00"

  signal juicyMeterFull()
  signal juicyMeterEmpty()

  Behavior on percentage {
    NumberAnimation {
      duration: 1000
    }
  }

  onPercentageChanged: {
    if(percentage <= 0)
      juicyMeterEmpty()
    else if(percentage >= 100) {
      juicyMeterFull()
    }
  }

  Rectangle {
    id: juicyMeterBorder
    width: juicyMeterBG.width + 2
    height: juicyMeterBG.height + 4
    anchors.centerIn: juicyMeterBG
    color: "white"
  }

  Rectangle {
    id: juicyMeterBG
    width:  parent.width
    height: parent.height
    anchors.centerIn: parent
    color: "#cccccc"
  }

  Rectangle {
    id: juicyMeterLevel
    width: juicyMeterBG.width
    height: juicyMeterBG.height * (juicyMeter.percentage / 100)
    anchors.horizontalCenter: juicyMeterBG.horizontalCenter
    anchors.bottom: juicyMeterBG.bottom
    color: juicyMeter.color2
  }

  // juciy meter animation
  SequentialAnimation {
    id: juicyMeterAnimation
    running: true
    loops: Animation.Infinite
    PropertyAnimation {
      target: juicyMeterLevel
      property: "color"
      from: juicyMeter.color1
      to: juicyMeter.color2
      duration: 1000
    }
    PropertyAnimation {
      target: juicyMeterLevel
      property: "color"
      duration: 1000
      from: juicyMeter.color2
      to: juicyMeter.color1
    }
  }
}
