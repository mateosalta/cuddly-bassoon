#include <QGuiApplication>
#include <QCoreApplication>
#include <QUrl>
#include <QString>
#include <QQuickStyle>
#include <QQmlEngine>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QVector>
#include <QtWebEngine/qtwebengineglobal.h>




int main(int argc, char** argv) {
    QGuiApplication::setOrganizationName("youtube-web.mateo-salta");
    QGuiApplication::setApplicationName("youtube-web.mateo-salta");
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_ShareOpenGLContexts);
    
    // qputenv("QT_AUTO_SCREEN_SCALE_FACTOR", "true");
       
    if (qgetenv("QT_QPA_PLATFORM") == "wayland") {
        qputenv("QT_WAYLAND_SHELL_INTEGRATION", "wl-shell");
        qputenv("QT_SCALE_FACTOR", "1.7");
        qputenv("QT_WEBENGINE_DISABLE_GPU","1");
    }
    
    const auto chromiumFlags = qgetenv("QTWEBENGINE_CHROMIUM_FLAGS");
    qputenv("QTWEBENGINE_CHROMIUM_FLAGS", chromiumFlags + " --enable-features=OverlayScrollbar,OverlayScrollbarFlashAfterAnyScrollUpdate,OverlayScrollbarFlashWhenMouseEnter --enable-blink-features=NeverSlowMode,BackFowardCache,CanvasHDR,CompositeBGColorAnimation,CompositeBoxShadowAnimation,CanvasImageSmoothing,Canvas2dScrollPathIntoView,BackForwardCacheExperimentHTTPHeader,Accelerated2dCanvas,AcceleratedSmallCanvases --enable-smooth-scrolling  --enable-low-res-tiling --enable-gpu --ignore-gpu-blocklist --enable-gpu-rasterization --force-gpu-rasterization --enable-zero-copy  --adaboost --enable-gpu-memory-buffer-video-frames  --double-buffer-compositing --enable-native-gpu-memory-buffers --font-render-hinting=none --disable-font-subpixel-positioning --disable-new-content-rendering-timeout   --enable-defer-all-script-without-optimization-hints --gles-egl --disable-frame-rate-limit --disable-gpu-vsync  --enable-oop-rasterization --enable-accelerated-video-decode --use-angle=gles --enable-es3-apis --enable-accelerated-2d-canvas");
        
     // qputenv("QTWEBENGINE_CHROMIUM_FLAGS", "--blink-settings=darkMode=3,darkModeImagePolicy=2,darkModeImageStyle=2 --enable-smooth-scrolling --enable-low-res-tiling --enable-low-end-device-mode --enable-natural-scroll-default"); 
    //qputenv("QTWEBENGINE_CHROMIUM_FLAGS", "");

    
    QGuiApplication app(argc, argv);


    //QQmlApplicationEngine engine;
    //engine.load(QUrl(QStringLiteral("qrc:///app/Main.qml")));

    QQuickView view;
    view.setFlags(Qt::Window | Qt::WindowTitleHint);
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setColor(Qt::black);
    view.setSource(QUrl("qrc:///app/Main.qml"));
    view.show(); 

    return app.exec();
}
