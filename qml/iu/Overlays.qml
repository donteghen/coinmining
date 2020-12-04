import Felgo 3.0
import QtQuick 2.0
import QtMultimedia 5.0


Item {
  id: overlays

  scale: 0.25
  anchors.horizontalCenter: parent.horizontalCenter

  property string textsImgPath: "../../assets/img/texts/"

  // signal when overloadText disappeared
  signal overloadTextDisappeared()

  // configure overlays
  TextOverlay {
    id: fruityText
    anchors.horizontalCenter: parent.horizontalCenter
    imageSource: textsImgPath+"Riches.png"
  }

  TextOverlay {
    id: sweetText
    anchors.horizontalCenter: parent.horizontalCenter
    imageSource: textsImgPath+"Sweet.png"
  }

  TextOverlay {
    id: refreshingText
    anchors.horizontalCenter: parent.horizontalCenter
    imageSource: textsImgPath+"Amazing.png"
  }

  TextOverlay {
    id: yummyText
    anchors.horizontalCenter: parent.horizontalCenter
    imageSource: textsImgPath+"OhhYess.png"
  }

  TextOverlay {
    id: overloadText
    anchors.horizontalCenter: parent.horizontalCenter
    imageSource: textsImgPath+"CoinOverload.png"
    animationDuration: 1000
    defaultY: -150
    onOverlayDisappeared: {
      overloadTextDisappeared()
    }
  }

  TextOverlay {
    id: deliciousText
    anchors.horizontalCenter: parent.horizontalCenter
    imageSource: textsImgPath+"Fantastic.png"
    animationDuration: 1000
  }

  TextOverlay {
    id: smoothText
    anchors.horizontalCenter: parent.horizontalCenter
    imageSource: textsImgPath+"Smooth.png"
    animationDuration: 1000
  }

  function showFruity() { fruityText.show(); scene.gameSound.playFruitySound() }
  function showSweet() { sweetText.show(); scene.gameSound.playSweetSound() }
  function showRefreshing() { refreshingText.show(); scene.gameSound.playRefreshingSound() }
  function showOverload() { overloadText.show(); scene.gameSound.playOverloadSound() }
  function showYummy() { yummyText.show(); scene.gameSound.playYummySound() }
  function showDelicious() { deliciousText.show(); scene.gameSound.playDeliciousSound() }
  function showSmooth() { smoothText.show(); scene.gameSound.playSmoothSound() }
}
