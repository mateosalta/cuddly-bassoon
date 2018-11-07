import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Web 0.2

/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "youtube-morphc.mateo-salta"

    width: units.gu(100)
    height: units.gu(75)

    Page {
        header: PageHeader {
            id: pageHeader
            title: i18n.tr("youtube-morphc")
            StyleHints {
                foregroundColor: UbuntuColors.orange
                backgroundColor: UbuntuColors.porcelain
                dividerColor: UbuntuColors.slate
            }
        }
   WebView {
        anchors.fill: parent
        url: "http://www.qt.io"
    }
    }
}
