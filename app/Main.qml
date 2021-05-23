import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12
import Ubuntu.Components 1.3
import "UCSComponents"
import Morph.Web 0.1
import QtWebEngine 1.10
import QtSystemInfo 5.5

Item {

  //  id: window
    visible: true



    ScreenSaver {
        id: screenSaver
        screenSaverEnabled: !Qt.application.active || !webview.recentlyAudible
    }

    width: units.gu(45)
    height: units.gu(75)


    objectName: "mainView"
    

    property QtObject defaultProfile: WebEngineProfile {
        storageName: "myProfile"
        offTheRecord: false
        id: webContext
           persistentCookiesPolicy: WebEngineProfile.ForcePersistentCookies
       property alias dataPath: webContext.persistentStoragePath

            dataPath: dataLocation

    userScripts: [
           WebEngineScript {
               id: cssinjection
               injectionPoint: WebEngineScript.DocumentReady
               sourceCode: "\n(function() {\nvar css = \"* {font-family: \\\"Ubuntu\\\" !important; font-size: 10pt !important;} ytm-pivot-bar-renderer {display: none !important;} .chip-bar{display: none !important;}\"\n\n;\n\n\nif (typeof GM_addStyle != \"undefined\") {\n\tGM_addStyle(css);\n} else if (typeof PRO_addStyle != \"undefined\") {\n\tPRO_addStyle(css);\n} else if (typeof addStyle != \"undefined\") {\n\taddStyle(css);\n} else {\n\tvar node = document.createElement(\"style\");\n\tnode.type = \"text/css\";\n\tnode.appendChild(document.createTextNode(css));\n\tvar heads = document.getElementsByTagName(\"head\");\n\tif (heads.length > 0) {\n\t\theads[0].appendChild(node); \n\t} else {\n\t\t// no head yet, stick it whereever\n\t\tdocument.documentElement.appendChild(node);\n\t}\n}\n\n})();"
               worldId: WebEngineScript.UserWorld
           }
       ]
    
        httpUserAgent: "Mozilla/5.0 (Linux; Android 9.0; Pixel 4 XL) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.79 Mobile Safari/537.36"
    }

    WebEngineView {

        id: webview
        anchors.fill: parent
                profile: defaultProfile
        settings.fullScreenSupportEnabled: true
        settings.dnsPrefetchEnabled: true

        enableSelectOverride: true

       property var currentWebview: webview
       property ContextMenuRequest contextMenuRequest: null
       settings.pluginsEnabled: true
     //settings.showScrollBars: false
       settings.javascriptCanAccessClipboard: true

       onFullScreenRequested: function(request) {
         nav.visible = !nav.visible
         if (request.toggleOn) {
           window.showFullScreen();
       }
       else {
           window.showNormal();
       }

         request.accept();
     }


        url: "https://m.youtube.com/"

   


        //handle click on links
        onNewViewRequested: function(request) {
            console.log(request.destination, request.requestedUrl)

            var url = request.requestedUrl.toString()
            //handle redirection links
            if (url.startsWith('https://www.youtube.com')) {
                //get query params
                var reg = new RegExp('[?&]q=([^&#]*)', 'i');
                var param = reg.exec(url);
                if (param) {
                    console.log("url to open:", decodeURIComponent(param[1]))
                    Qt.openUrlExternally(decodeURIComponent(param[1]))
                } else {
                    Qt.openUrlExternally(url)
                                    request.action = WebEngineNavigationRequest.IgnoreRequest;
                }
            } else {
                Qt.openUrlExternally(url)
            }
        }

        onContextMenuRequested: function(request) {
            if (!Qt.inputMethod.visible) { //don't open it on when address bar is open
                request.accepted = true;
                contextMenuRequest = request
                contextMenu.x = request.x;
                contextMenu.y = request.y;
                contextMenu.open();
            }
        }


    }

    Menu {
        id: contextMenu

        MenuItem {
            id: copyItem
            text: i18n.tr("Copy link")
            enabled: webview.contextMenuRequest
            onTriggered: {
                console.log(webview.contextMenuRequest.linkUrl.toString())
                var url = ''
                if (webview.contextMenuRequest.linkUrl.toString().length > 0) {
                    url = webview.contextMenuRequest.linkUrl.toString()
                } else {
                    //when clicking on the video
                    url = webview.url
                }

                Clipboard.push(url)
                webview.contextMenuRequest = null;
            }
        }
    }

    RadialBottomEdge {
        id: nav
        visible: window.loaded
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
        target: webview

        onIsFullScreenChanged: {
            console.log('onIsFullScreenChanged:')
            window.setFullscreen(webview.isFullScreen)
            if (webview.isFullScreen) {
                nav.state = "hidden"
            }
            else {
                nav.state = "shown"
            }
        }
    }


        Connections {
            target: UriHandler

            onOpened: {

                if (uris.length > 0) {
                    console.log('Incoming call from UriHandler ' + uris[0]);
                    webview.url = uris[0];
                }
            }
        }

        Component.onCompleted: {
            //Check if opened the app because we have an incoming call
            if (Qt.application.arguments && Qt.application.arguments.length > 0) {
                for (var i = 0; i < Qt.application.arguments.length; i++) {
                    if (Qt.application.arguments[i].match(/^http/)) {
                        console.log(' open video to:', Qt.application.arguments[i])
                        webview.url = Qt.application.arguments[i];
                    }
                }
            }
            else {
            webview.url = myurl;
            }
        }

        function setFullscreen(fullscreen) {
            if (fullscreen) {
                if (window.visibility != ApplicationWindow.FullScreen) {
                    window.visibility = ApplicationWindow.FullScreen
                }
            } else {
                window.visibility = ApplicationWindow.Windowed
            }
        }
        
        
              function toggleApplicationLevelFullscreen() {
                setFullscreen(visibility !== ApplicationWindow.FullScreen)
            }

            Shortcut {
                sequence: StandardKey.FullScreen
                onActivated: window.toggleApplicationLevelFullscreen()
            }

            Shortcut {
                sequence: "F11"
                onActivated: window.toggleApplicationLevelFullscreen()
            }
}
