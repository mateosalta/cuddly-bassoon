import QtQuick 2.9
import Ubuntu.Components 1.3
import QtQuick.Window 2.2
import Morph.Web 0.1
import "UCSComponents"
import QtWebEngine 1.7
import Qt.labs.settings 1.0
import QtSystemInfo 5.5

MainView {
id:mainview

ScreenSaver {
id: screenSaver
screenSaverEnabled: !(Qt.application.active)
}
    objectName: "mainView"
        theme.name: "Ubuntu.Components.Themes.SuruDark"

    applicationName: "youtube-web.mateo-salta"


    signal fullScreenRequested(bool toggleOn)

    

        
   WebEngineView {
   id: webview
    anchors{ fill: parent}


 
              settings.fullScreenSupportEnabled: true
       property var currentWebview: webview
         //  settings.pluginsEnabled: true
           
           
                    onFullScreenRequested: function(request) {
       mainview.fullScreenRequested(request.toggleOn);
       nav.visible = !nav.visible

       request.accept();
   }


       
profile:  WebEngineProfile{
id: oxideContext
    persistentCookiesPolicy: WebEngineProfile.ForcePersistentCookies
    
        httpUserAgent: "Mozilla/5.0 (Linux; Android 8.0.0; Pixel Build/OPR3.170623.007) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/61.0.3163.98 Mobile Safari/537.36"
    }

        anchors{fill:parent
    centerIn: parent.verticalCenter}

              
       
       url: "http://www.youtube.com"
 userScripts: [
WebEngineScript {
  injectionPoint: WebEngineScript.DocumentCreation
worldId: WebEngineScript.MainWorld
name: "QWebChannel"
sourceUrl: "ubuntutheme.js"
}
]

    
    }
       RadialBottomEdge {
            id: nav
            visible: true
            actions: [
                RadialAction {
                    id: reload
                    iconName: "reload"
                    onTriggered: {
                        webview.reload()
                    }
                    text: qsTr("Reload")
                },
                
                RadialAction {
                    id: forward
                    enabled: webview.canGoForward
                    iconName: "go-next"
                    onTriggered: {
                        webview.goForward()
                    }
                   text: qsTr("Forward")
                 },
                    RadialAction {
                    id: account
                    iconName: "account"
                    onTriggered: {
                        webview.url = 'https://m.youtube.com/feed/account'
                    }
                    text: qsTr("Account")
                    
                },
                    RadialAction {
                    id: subscriptions
                    iconName: "media-playlist"
                    onTriggered: {
                        webview.url = 'https://m.youtube.com/feed/subscriptions'
                    }
                    text: qsTr("Subscriptions")
                    
                },
                  RadialAction {
                    id: trending
                    iconName: "weather-chance-of-storm"
                    onTriggered: {
                        webview.url = 'https://m.youtube.com/feed/trending'
                    }
                    text: qsTr("Trending")
                },
               
                RadialAction {
                    id: home
                    iconName: "home"
                    onTriggered: {
                        webview.url = 'http://m.youtube.com'
                    }
                    text: qsTr("Home")
                },
             

            
                  RadialAction {
                    id: back
                    enabled: webview.canGoBack
                    iconName: "go-previous"
                    onTriggered: {
                        webview.goBack()
                    }
                    text: qsTr("Back")
                }
            ]
            
    
   
   
        }
         Connections {
        target: Qt.inputMethod
        onVisibleChanged: nav.visible = !nav.visible
    }
   
    
    }

