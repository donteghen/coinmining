import Felgo 3.0
import QtQuick 2.0

SceneBase {
  id: scene

  property alias gameNetwork: gameNetwork

  GameNetworkView {
    id: gameNetworkView
    anchors.fill: scene.gameWindowAnchorItem

    // no achievements used yet, so do not show the achievements icon
    showAchievementsHeaderIcon: false

    onBackClicked: {
      scene.backButtonPressed()
    }
  }

  FelgoGameNetwork {
    id: gameNetwork
    // received from the GameNetwork dashboard at https://cloud.felgo.com
    gameId: 927
    secret: "abc123ffabc123ff"
    gameNetworkView: gameNetworkView

    onNewHighscore: {
      if(!isUserNameSet(userName)) {
        nativeUtils.displayTextInput(qsTr("Congratulations!"), qsTr("You achieved a new highscore. What is your player name for comparing your juicy scores?"), "")
      }
      else {
        nativeUtils.displayMessageBox(qsTr("Congratulations!"), qsTr("You achieved a new highscore of ")+gameScene.score+qsTr(" points."), 1)
      }
    }
  }

  Connections {
    target: nativeUtils
    onTextInputFinished: {
      if(accepted) {
        var validUserName = gameNetwork.updateUserName(enteredText)
      }
    }
  }
} // item
