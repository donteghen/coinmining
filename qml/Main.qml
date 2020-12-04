import Felgo 3.0
import QtQuick 2.0
import "scene"
import "admob"

   GameWindow {
     id: gameWindow

     licenseKey: "26FEE5833EDFB4C7324F3A1F15A46DEC9C04CDB218429AF4587AE7D04E6C3904570C462E7CEE07927CA6D5C828B9A551E35D126313AD9D5DCCDE1B94AEE5C645FD980164B5CF0C87A08A319B6D163527D39F07E36DFD3E7C364B91F25BA79FB1D48F46146C98B5C166FC83100A9979BA3F394D7F8EEAFEA28180CDCDB3C89CDDC71BA8AB2679B1BB3C2AAF9D08B44C499C0ED8AB4E0EF6A399C84C76E4CA108593FFAC077C096AA435959BF72963D757939C18B637A40FFB786C2971851213A7BFB14289002126C51EE68993718226B7058220138D7DCEB21A67905398E828A6E25EE5202A0E145D832474C12BF537476F92711ADB9F1E403F166435FD085E2102335E8785D38BAD53A84E5F51C343EE968AD0A3EC8EAEED429A82A516F4D93422E9D182AB38F59327E6A0BC423571CF166ACFFB4C4BBEDFCD70AB773DBDFFF5E0EECC1786B4B9C879691DC91B824CEF5CB5D80F640290C97AC34FBBCAE29F4F14FD7F38B3801444D86D4A5F1186E52BF97B03AA903870CF0C4CFF9E0E2B6746"
     // You get free licenseKeys from https://felgo.com/licenseKey
     // With a licenseKey you can:
     //  * Publish your games & apps for the app stores
     //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
     //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
     //licenseKey: "<generate one from https://felgo.com/licenseKey>"

     // the size of the Window can be changed at runtime by pressing Ctrl (or Cmd on Mac) + the number keys 1-8
     // the content of the logical scene size (480x320 for landscape mode by default) gets scaled to the window size based on the scaleMode
     // you can set this size to any resolution you would like your project to start with, most of the times the one of your main target device
     // this resolution is for iPhone 4 & iPhone 4S
     screenWidth: 640
     screenHeight: 960

     // custom font loading of ttf fonts
     FontLoader {
       id: gameFont
       source: "../assets/fonts/akaDylan Plain.ttf"
     }

     // add google analytics plugin
     //GoogleAnalytics {
      // id: gAnalytics
    // }

     // background music
     BackgroundMusic {
       source: "../assets/snd/POL-jungle-hideout-short.wav"
       //autoPlay: bool
     }

     // Admob Region for managing our banner ads
     AdmobItems {
         id: myAdmob

       }



     // loading screen
     Rectangle {
       id: loadScreen
       width: gameWindow.width
       height: gameWindow.height
       color: "white"
       z: 1

       opacity: 0
       enabled: opacity == 1 ? true : false
       visible: opacity > 0 ? true : false

       // signal when load screen is fully visible
       signal fullyVisible()

       // background and text
       Text {
         // set font
         font.family: gameFont.name
         font.pixelSize: gameWindow.width / 640 * 24
         color: "red"
         text: "Loading ..."
         anchors.centerIn: parent
       }

       // animate loading screen
       Behavior on opacity {
         PropertyAnimation {
           duration: 300
           onRunningChanged: {
             if(!running && opacity == 1)
               loadScreen.fullyVisible()
           }
         }
       }
     }

     // add spashscreen scene (first scene to show)
     SplashScreenScene {
       id: splashScene
       onSplashScreenFinished: gameWindow.state = "game" // show game screen after splash screen
     }

     // use loader to load game-scene when necessary
     Loader {
       id: gameSceneLoader
       onLoaded: loadScreen.opacity = 0
     }

     // use loader to load gamenetwork-scene when necessary
     Loader {
       id: gameNetworkSceneLoader
       onLoaded: loadScreen.opacity = 0
     }

     // set start state
     state: "splash"

     states: [
       State {
         name: "splash"
         PropertyChanges {target: splashScene; opacity: 1}
         PropertyChanges {target: gameWindow; activeScene: splashScene}
       },
       State {
         name: "gameNetwork"
         StateChangeScript {
           script: {
             showGameNetworkScene()
             //gAnalytics.logScreen("GameNetwork")
           }
         }
       },
       State {
         name: "game"
         StateChangeScript {
           script: {
             showGameScene()
             //gAnalytics.logScreen("Game")
           }
         }
       }
     ]

     // Show reward ads
    /* function onShowRewardAd(){
         console.log("i am here again..................................................................")
        // myAdmob.showRewardedVideoIfLoaded()
        //myRewardedVideo.showRewardedVideoIfLoaded()
     }*/

     // show game scene
     function showGameScene() {
       // if game scene not loaded -> load first
       if(gameSceneLoader.item === null) {
         gameSceneLoader.loaded.connect(showGameScene)
         loadGameScene()
         return
       }

       // scene is definitely loaded at this point
       // show game scene
       gameWindow.activeScene = gameSceneLoader.item
       gameSceneLoader.item.opacity = 1

       // hide gamenetwork scene
       if(gameNetworkSceneLoader.item !== null)
         gameNetworkSceneLoader.item.opacity = 0
     }

     // show gamenetwork scene
     function showGameNetworkScene() {
       // if gamenetwork scene not loaded -> load first
       if(gameNetworkSceneLoader.item === null) {
         gameNetworkSceneLoader.loaded.connect(showGameNetworkScene)
         loadGameNetworkScene()
         return
       }

       // scene is definitely loaded at this point
       // show gamenetwork scene
       gameWindow.activeScene = gameNetworkSceneLoader.item
       gameNetworkSceneLoader.item.opacity = 1

       // hide game scene
       if(gameSceneLoader.item !== null)
         gameSceneLoader.item.opacity = 0
     }

     // show loading screen and start loading game scene
     function loadGameScene() {
       loadScreen.opacity = 1
       loadScreen.fullyVisible.connect(fetchAndInitializeGameScene)
     }

     // show loading screen and start loading gamenetwork scene
     function loadGameNetworkScene() {
       loadScreen.opacity = 1
       loadScreen.fullyVisible.connect(fetchAndInitializeGameNetworkScene)
     }

     // fetch game scene from qml and connect signals
     function fetchAndInitializeGameScene() {
       gameSceneLoader.source = "scene/GameScene.qml"
       gameSceneLoader.item.highscoreClicked.connect(onHighscoreClicked)
       gameSceneLoader.item.reportScore.connect(onReportScore)

       loadScreen.fullyVisible.disconnect(fetchAndInitializeGameScene)
     }

     // fetch gamenetwork scene from qml and connect signals
     function fetchAndInitializeGameNetworkScene() {
       gameNetworkSceneLoader.source = "scene/GameNetworkScene.qml"
       gameNetworkSceneLoader.item.backButtonPressed.connect(onBackButtonPressed)

       loadScreen.fullyVisible.disconnect(fetchAndInitializeGameNetworkScene)
     }

     // report score event
     function onReportScore(score) {
       if(gameNetworkSceneLoader.item === null) {
         // if not loaded -> load gamenetwork -> then report score again
         gameNetworkSceneLoader.loaded.connect(function() { onReportScore(score)} )
         loadGameNetworkScene()
         return
       }

       gameNetworkSceneLoader.item.gameNetwork.reportScore(score)
     }

     // switch state events
     function onHighscoreClicked() {
       gameWindow.state = "gameNetwork"
     }

     function onBackButtonPressed() {
       gameWindow.state = "game"
     }
   }


