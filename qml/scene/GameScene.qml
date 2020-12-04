import Felgo 3.0
import QtQuick 2.0
import QtMultimedia 5.12
import "../game"
import "../iu"
import "../admob"

SceneBase {
  id: scene

  // the "logical size" - the scene content is auto-scaled to match the GameWindow size
  width: 320
  height: 480

  // property to hold game score
  property int score

  // property to hold juicy meter percentage
  property double juicyMeterPercentage

  // property to hold remaining game time
  property int remainingTime

  // display of texts from anywhere
  property alias overlayText: overlays
  property alias gameSound: gameSoundItem

  // memorize if vplay msgbox is open
  property bool vPlayMsgBox: false

  // signal for ad
  signal showRewardAd()

  // signal for opening highscore
  signal highscoreClicked()

  // signal for reporting highscore
  signal reportScore(int score)

  // react to native back button
  onBackButtonPressed: backPressed()

  // add entity manager
  EntityManager {
    id: entityManager
    entityContainer: gameArea
    poolingEnabled: true // allow pooling of entities, entities won't be removed from memory, but used later again

    // this property is required to enter all entities that should be loadable dynamically
    // the entities added here are also the ones that can be created with createEntityFromEntityTypeAndVariationType()
    dynamicCreationEntityList: [
      Qt.resolvedUrl("../game/Block.qml")
    ]
  }

  // background image
  BackgroundImage {
    source: "../../assets/img/CoinBackground.png"
    anchors.centerIn: scene.gameWindowAnchorItem
  }


  // holds sounds for game
  GameSound {
    id: gameSoundItem
  }

  // juicy meter
  JuicyMeter {
    percentage: scene.juicyMeterPercentage
    anchors.centerIn: gameArea
    width: gameArea.width+36
    height: gameArea.height
    onJuicyMeterFull: {
      overlays.showOverload()
      whiteScreen.flash()
    }
  }

  // add empty grid
  Image {
    id: grid
    source: "../../assets/img/Grid.png"
    width: 258
    height: 378
    anchors.horizontalCenter: scene.horizontalCenter
    anchors.bottom: scene.bottom
    anchors.bottomMargin: 92
  }

  // add full grid
  Image {
    id: filledGrid
    source: "../../assets/img/testfullgrid.png"
    width: 258
    height: 378
    anchors.horizontalCenter: scene.horizontalCenter
    anchors.bottom: scene.bottom
    anchors.bottomMargin: 92
    opacity: 1
    Behavior on opacity {
      PropertyAnimation { duration: 500 }
    }
  }
  // game area holds game field with blocks
  GameArea {
    id: gameArea
    anchors.horizontalCenter: scene.horizontalCenter
    anchors.verticalCenter: grid.verticalCenter
    blockSize: 30

    // handle game over
   onGameOver: {

        currentGameEnded()
    }


    // show game field when initialization of new game is finished
    onInitFinished: {
      whiteScreen.stopLoading()
      scene.score = 0
      scene.juicyMeterPercentage = 0
      scene.remainingTime = 120 // 120 seconds
      filledGrid.opacity = 0
      gameTimer.start()

      //gAnalytics.logEvent("Game Event", "New Game Initialized")
    }

    // hide game area when on title screen
    opacity: filledGrid.opacity == 1 ? 0 : 1
  }

  // show logo
  Image {
    id: juicyLogo
    source: "../../assets/img/Logo.png"
    width: 119
    height: 59
    anchors.horizontalCenter: scene.horizontalCenter
    anchors.bottom: scene.bottom
    anchors.bottomMargin: 35
  }

  // display score
  Text {
    // set font
    font.family: gameFont.name
    font.pixelSize: 12
    color: "red"
    text: scene.score

    // set position
    anchors.horizontalCenter: parent.horizontalCenter
    y: 442

    MouseArea {
      anchors.centerIn: parent
      width: 150
      height: parent.height + 5
      onClicked: highscoreClicked()
    }
  }

  // display remaining time
  Image {
    width: 80
    height: 46
    source: "../../assets/img/TimeLeft.png"

    anchors.right: scene.gameWindowAnchorItem.right
    anchors.top: juicyLogo.top
    anchors.topMargin: juicyLogo.height / 2

    Text {
      font.family: gameFont.name
      font.pixelSize: 12
      color: "red"
      text: remainingTime + " s"

      y: 25
      x: 15
      width: 80 - 15
      horizontalAlignment: Text.AlignHCenter
    }

    enabled: opacity == 1
    visible: opacity > 0
    opacity: filledGrid.opacity > 0.5 ? 0 : 1

    Behavior on opacity {
      PropertyAnimation { duration: 200 }
    }
  }

  // game timer for remaining time
  Timer {
    id: gameTimer
    repeat: true
    interval: 1000 // trigger every second
    onTriggered: {
      if(scene.remainingTime > 0)
        scene.remainingTime--
      else if(!gameArea.fieldLocked) {
        currentGameEnded()
      }
    }
  }





  // configure title window
  TitleWindow {
    id: titleWindow
    y: 25
    opacity: 1
    anchors.horizontalCenter: scene.horizontalCenter
    onStartClicked: scene.startGame()
    onHighscoreClicked: scene.highscoreClicked()
    onCreditsClicked: {
      //gAnalytics.logEvent("User Action", "Open Credits");
      titleWindow.hide(); creditsWindow.show()
    }
    onVplayClicked: {
     // gAnalytics.logEvent("User Action", "Felgo Clicked", "Title Window")
      vPlayMsgBox = false
     // nativeUtils.displayMessageBox(qsTr("Felgo"),
                                  //  qsTr("This game is built with Felgo. The source code is available in the free Felgo SDK - so you can build your own match-3 game in minutes! Visit Felgo.net now?"), 2)
    }
  }

  // configure gameover window
  GameOverWindow {
    id: gameOverWindow
    y: 90
    opacity: 0 // by default the window is hidden
    anchors.horizontalCenter: scene.horizontalCenter
    onNewGameClicked: scene.startGame()
    onBackClicked: { openTitleWindow() }
  }

  // configure credits window
  CreditsWindow {
    id: creditsWindow
    y: 90
    opacity: 0
    anchors.horizontalCenter: scene.horizontalCenter
    onBackClicked: { openTitleWindow() }
    onVplayClicked: {
      //gAnalytics.logEvent("User Action", "Open Felgo Match-3 Url", "Credits Window")
     // nativeUtils.openUrl("https://felgo.com/doc/felgo-demos-match-3-example/")
    }
  }

  // configure home button
  Image {
    width: 52
    height: 45
    source: "../../assets/img/HomeButton.png"

    MouseArea {
      anchors.fill: parent
      onClicked: backButtonPressed()
    }

    x: 5
    y: 432

    visible: opacity > 0
    enabled: opacity == 1
    opacity: titleWindow.opacity > 0.5 ? 0 : 1

    Behavior on opacity {
      PropertyAnimation { duration: 200 }
    }
  }

  // rectangle for flashing screen
  Rectangle {
    id: whiteScreen
    anchors.fill: gameArea
    anchors.centerIn: gameArea
    color: "white"
    opacity: 0
    visible: opacity > 0
    enabled: opacity > 0

    SequentialAnimation {
      id: flashAnimation
      NumberAnimation {
        target: whiteScreen
        property: "opacity"
        to: 1
        duration: 300
      }
      NumberAnimation {
        target: whiteScreen
        property: "opacity"
        from: 1
        to: 0
        duration: 700
      }
    }

    SequentialAnimation {
      id: loadingAnimation
      loops: Animation.Infinite
      NumberAnimation {
        target: whiteScreen
        property: "opacity"
        to: 1
        duration: 400
      }
      NumberAnimation {
        target: whiteScreen
        property: "opacity"
        from: 1
        to: 0.8
        duration: 1000
      }
    }

    Text {
      id: loadingText

      // set font
      font.family: gameFont.name
      font.pixelSize: 12
      color: "red"
      text: qsTr("preparing coins")

      anchors.centerIn: parent
      opacity: 0

      Behavior on opacity {
        PropertyAnimation { duration: 400 }
      }
    }

    function flash() {
      loadingText.opacity = 0
      loadingAnimation.stop()
      flashAnimation.stop()
      flashAnimation.start()
    }

    function startLoading() {
      loadingAnimation.start()
      loadingText.opacity = 1
    }

    function stopLoading() {
      flash()
    }
  }

  // overlay texts
  Overlays {
    id: overlays
    y: 190
    onOverloadTextDisappeared: {
      scene.juicyMeterPercentage = 0
      gameTimer.stop()
      gameArea.removeAllBlocks()
      whiteScreen.flash()
      scene.remainingTime += 60
      gameTimer.start()
    }
  }

  // listen to the return value of the native MessageBox
  Connections {
    target: nativeUtils
    onMessageBoxFinished: {
      if(!accepted) {
        //gAnalytics.logEvent("User Action", "Message Box Declined")
        vPlayMsgBox = false
        if(!titleWindow.visible && !gameTimer.running)
          gameTimer.start()
        return
      }

      if(vPlayMsgBox) {
        // vplay clicked -> open website
        vPlayMsgBox = false
       // gAnalytics.logEvent("User Action", "Open Felgo Match-3 Url", "Title Window")
       // nativeUtils.openUrl("https://felgo.com/doc/felgo-demos-match-3-example/")
      }
      else if(!titleWindow.visible) {
       // gAnalytics.logEvent("User Action", "Abort Running Game")

        // player aborted game, either show game-over window or go back to title scene
        if(scene.score > 0)

          currentGameEnded()
        else
          openTitleWindow()
      }
      else {
        //quit
       // gAnalytics.logEvent("User Action", "Quit Application")
        Qt.quit()
      }
    }
  }

  // timer for initialization after play was clicked
  Timer {
    id: initTimer
    interval: 400
    onTriggered: {
      // initialize
      gameArea.initializeField()
    }
  }

  AdMobRewardedVideo {
  id: myRewardedVideo

   // test ad for rewarded videos
   // create your own from the AdMob Backend
   adUnitId : "ca-app-pub-9866413528426288/7925453872"

   // if the video is fully watched, we add add score by 200
   onRewardedVideoRewarded: {

       scene.score += 200

   }

   onRewardedVideoClosed: {
     // load a new video every time it got shown, to give the user a fresh ad
     loadRewardedVideo()
   }

    // load interstitial at app start to cache it
   onPluginLoaded: {
     loadRewardedVideo()

   }
 }

  // opens title window
  function openTitleWindow() {
    // show background
    filledGrid.opacity = 1
    scene.juicyMeterPercentage = 0
    gameTimer.stop()

    // show title window
    creditsWindow.hide()
    gameOverWindow.hide()
    titleWindow.show()

    //gAnalytics.logEvent("User Action", "Open Title Window")
  }

  // when game ends, show game-over window and report score
  function currentGameEnded() {
    //gAnalytics.logEvent("Game Event", "Game Ended")

    myRewardedVideo.showRewardedVideoIfLoaded()

    gameArea.gameEnded = true
    gameOverWindow.show()
    gameTimer.stop()
    scene.reportScore(scene.score)
  }

  // initialize game
  function startGame() {
    // hide windows
    titleWindow.hide()
    gameOverWindow.hide()
    creditsWindow.hide()

    // start loading animation
    whiteScreen.startLoading()

    // delay start of initialization
    initTimer.start()

    //gAnalytics.logEvent("User Action", "Start New Game")
  }

  // handle back button pressed
  function backPressed() {
    if(titleWindow.visible) {
      // player is in menu, quit game??
      nativeUtils.displayMessageBox("Really quit the game?", "", 2)
    }
    else if(creditsWindow.visible)  {
      // not in game, directly open title window
      openTitleWindow()
    }
    else if(gameOverWindow.visible) {
      // go back to title
      openTitleWindow()
    }
    else {
      // in game, ask player before switching
      if(gameTimer.running)
        gameTimer.stop()
      nativeUtils.displayMessageBox("Abort current game?", "", 2)
    }
  }
}
