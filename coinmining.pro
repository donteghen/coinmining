# allows to add DEPLOYMENTFOLDERS and links to the Felgo library and QtCreator auto-completion
CONFIG += felgo
#FELGO_PLUGINS += admob

# uncomment this line to add the Live Client Module and use live reloading with your custom C++ code
# for the remaining steps to build a custom Live Code Reload app see here: https://felgo.com/custom-code-reload-app/
# CONFIG += felgo-live

# Project identifier and version
# More information: https://felgo.com/doc/felgo-publishing/#project-configuration
PRODUCT_IDENTIFIER = com.donaldteghengames.wizardEVP.Coinmining
PRODUCT_VERSION_NAME = 1.0.0
PRODUCT_VERSION_CODE = 1

# Optionally set a license key that is used instead of the license key from
# main.qml file (App::licenseKey for your app or GameWindow::licenseKey for your game)
# Only used for local builds and Felgo Cloud Builds (https://felgo.com/cloud-builds)
# Not used if using Felgo Live
PRODUCT_LICENSE_KEY = "26FEE5833EDFB4C7324F3A1F15A46DEC9C04CDB218429AF4587AE7D04E6C3904570C462E7CEE07927CA6D5C828B9A551E35D126313AD9D5DCCDE1B94AEE5C645FD980164B5CF0C87A08A319B6D163527D39F07E36DFD3E7C364B91F25BA79FB1D48F46146C98B5C166FC83100A9979BA3F394D7F8EEAFEA28180CDCDB3C89CDDC71BA8AB2679B1BB3C2AAF9D08B44C499C0ED8AB4E0EF6A399C84C76E4CA108593FFAC077C096AA435959BF72963D757939C18B637A40FFB786C2971851213A7BFB14289002126C51EE68993718226B7058220138D7DCEB21A67905398E828A6E25EE5202A0E145D832474C12BF537476F92711ADB9F1E403F166435FD085E2102335E8785D38BAD53A84E5F51C343EE968AD0A3EC8EAEED429A82A516F4D93422E9D182AB38F59327E6A0BC423571CF166ACFFB4C4BBEDFCD70AB773DBDFFF5E0EECC1786B4B9C879691DC91B824CEF5CB5D80F640290C97AC34FBBCAE29F4F14FD7F38B3801444D86D4A5F1186E52BF97B03AA903870CF0C4CFF9E0E2B6746"

qmlFolder.source = qml
DEPLOYMENTFOLDERS += qmlFolder # comment for publishing

assetsFolder.source = assets
DEPLOYMENTFOLDERS += assetsFolder

# Add more folders to ship with the application here

 RESOURCES += resources.qrc # uncomment for publishing

# NOTE: for PUBLISHING, perform the following steps:
# 1. comment the DEPLOYMENTFOLDERS += qmlFolder line above, to avoid shipping your qml files with the application (instead they get compiled to the app binary)
# 2. uncomment the resources.qrc file inclusion and add any qml subfolders to the .qrc file; this compiles your qml files and js files to the app binary and protects your source code
# 3. change the setMainQmlFile() call in main.cpp to the one starting with "qrc:/" - this loads the qml files from the resources
# for more details see the "Deployment Guides" in the Felgo Documentation

# during development, use the qmlFolder deployment because you then get shorter compilation times (the qml files do not need to be compiled to the binary but are just copied)
# also, for quickest deployment on Desktop disable the "Shadow Build" option in Projects/Builds - you can then select "Run Without Deployment" from the Build menu in Qt Creator if you only changed QML files; this speeds up application start, because your app is not copied & re-compiled but just re-interpreted


# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp


android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
    OTHER_FILES += android/AndroidManifest.xml       android/build.gradle
}

ios {
    QMAKE_INFO_PLIST = ios/Project-Info.plist
    OTHER_FILES += $$QMAKE_INFO_PLIST
}

# set application icons for win and macx
win32 {
    RC_FILE += win/app_icon.rc
}
macx {
    ICON = macx/app_icon.icns
}

DISTFILES += \
    qml/admob/AdmobItems.qml \
    qml/game/Block.qml \
    qml/game/GameArea.qml \
    qml/game/GameSound.qml \
    qml/game/JuicyMeter.qml \
    qml/iu/CreditsWindow.qml \
    qml/iu/GameOverWindow.qml \
    qml/iu/JuicyButton.qml \
    qml/iu/Overlays.qml \
    qml/iu/SplashScreen.qml \
    qml/iu/TextOverlay.qml \
    qml/iu/TitleWindow.qml \
    qml/scene/GameNetworkScene.qml \
    qml/scene/GameScene.qml \
    qml/scene/SceneBase.qml \
    qml/scene/SplashScreenScene.qml
