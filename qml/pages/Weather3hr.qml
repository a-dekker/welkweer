import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.welkweer.Settings 1.0

Page {
    id: threeHourLocalPage

    MySettings {
        id: myset
    }
    property string zoomLevel: myset.value("zoomlevel", "8")

    SilicaWebView {
        id: webView
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        url: "http://www.buienradar.nl/lokalebuienradar/?lat=" + mainapp.latitude + "&lng=" + mainapp.longitude
             + "&overname=2&zoom=" + zoomLevel + "&naam=" + mainapp.locPlace + "&size=3&voor=1"
        experimental {
            transparentBackground: true
        }
        experimental.preferences.fullScreenEnabled: true
        VerticalScrollDecorator {
        }
        quickScroll: false
        experimental.userScripts: [Qt.resolvedUrl("devicePixelRatioHack.js")]
        BusyIndicator {
            anchors.centerIn: parent
            running: webView.loading
            size: BusyIndicatorSize.Large
        }
        VerticalScrollDecorator {
            color: Theme.highlightColor // Otherwise we might end up with white decorator on white background
            width: Theme.paddingSmall // We want to see it properly
            flickable: webView
        }

        HorizontalScrollDecorator {  // Yeah necessary for larger images and other large sites or zoomed in sites
            parent: threeHourLocalPage
            color: Theme.highlightColor // Otherwise we might end up with white decorator on white background
            height: Theme.paddingSmall // We want to see it properly
            flickable: webView
        }
    }
}
