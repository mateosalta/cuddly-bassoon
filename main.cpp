#include <QGuiApplication>
#include <QCoreApplication>
#include <QUrl>
#include <QString>
#include <QQuickStyle>
#include <QQmlEngine>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QVector>


int main(int argc, char** argv) {
    QGuiApplication::setOrganizationName("youtube-web.mateo-salta");
    QGuiApplication::setApplicationName("youtube-web.mateo-salta");
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
   
        qputenv("QTWEBENGINE_CHROMIUM_FLAGS", "--blink-settings=darkMode=3,darkModeImagePolicy=2,darkModeImageStyle=2");
    
    qputenv("QT_AUTO_SCREEN_SCALE_FACTOR", "true");
         qputenv("QT_WEBENGINE_DISABLE_GPU","1");
    
             if (qgetenv("QT_QPA_PLATFORM") == "wayland")
         {
             qputenv("QT_WAYLAND_SHELL_INTEGRATION", "wl-shell");
         }
    

    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Suru");

    QQmlApplicationEngine engine(QUrl(QStringLiteral("app/Main.qml")));
    return app.exec();
}
