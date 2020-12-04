import Felgo 3.0
import QtQuick 2.0
import "../scene"
import "../game"
import "../iu"

/*/////////////////////////////////////
  NOTE:
  Additional integration steps are needed to use the plugin, for example to add and link required libraries for Android and iOS.
  Please follow the integration steps described in the plugin documentation: https://felgo.com/doc/plugin-admob/


  EXAMPLE USAGE:
  Add the following piece of code inside your main QML { } to display this example page.

  AdmobItems {

  }

/////////////////////////////////////*/

Rectangle {

    id:myads
    //anchors.fill: parent

    // Plugin Item
    // Admob banner
      AdMobBanner {
          id: adMobBanner
          adUnitId: "ca-app-pub-9866413528426288/8716108591" // replace with your AdMob adUnitId ca-app-pub-3940256099942544/6300978111
          banner: AdMobBanner.Smart
          y: 100
          anchors.horizontalCenter: gameWindow.horizontal
          //anchors.bottom:  gameWindow.bottom
          visible:true
          z : 1

          onAdReceived: {
                if(adMobBanner.visible) {
                console.log("Yes Received............................................................")
                }else
                    console.log("Not Received............................................................")
              }
      }

    // Plugin Item
      // admob Reward Video
        /*  AdMobRewardedVideo {
         //  id: myRewardedVideo

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
         }*/
}
