import Felgo 3.0
import QtQuick 2.0

Item {
  id: textOverlay

  // completely hide if not visible
  visible: opacity > 0
  enabled: opacity > 0

  // overlay is initially hidden
  opacity: 0

  // image source may be set for each overlay
  property alias imageSource: image.source

  property int animationDuration: 500

  property int defaultY: 0

  // signal animation is over
  signal overlayDisappeared()

  Image {
    id: image
    anchors.horizontalCenter: parent.horizontalCenter
  }

  // animation to show overlay
  ParallelAnimation {
    id: showAnimation

    NumberAnimation {
      target: textOverlay
      property: "scale"
      from: 0.75
      to: 1.25
      duration: animationDuration
    }
    NumberAnimation {
      target: textOverlay
      property: "y"
      from: defaultY + 50
      to: defaultY - 50
      duration: animationDuration
    }
    SequentialAnimation {
      NumberAnimation {
        target: textOverlay
        property: "opacity"
        from: 1
        to: 1
        duration: animationDuration * 0.75
      }
      NumberAnimation {
        target: textOverlay
        property: "opacity"
        from: 1
        to: 0
        duration: animationDuration * 0.25
      }
    }
    onStopped: {
      overlayDisappeared()
    }
  }


  // trigger animation
  function show() {
    showAnimation.start()
  }
}
