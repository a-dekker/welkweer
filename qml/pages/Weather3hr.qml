import QtQuick 2.5
import Sailfish.Silica 1.0
import harbour.welkweer.Settings 1.0

Page {
    id: threeHourLocalPage

    onStatusChanged: {
        switch (status) {
        case PageStatus.Active:
            pageStack.pushAttached(Qt.resolvedUrl("NL24hours.qml"))
        }
    }

    MySettings {
        id: myset
    }
    property string zoomLevel: myset.value("zoomlevel", "8")

    Column {
        id: col
        spacing: Theme.paddingLarge
        width: parent.width
        PageHeader {
            title: "Lokaal 3 uur"
            visible: isPortrait
        }
    }
    SilicaWebView {
        id: webView
        anchors.top: col.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        url: "https://gadgets.buienradar.nl/gadget/zoommap?lat=" + mainapp.latitude
             + "&lng=" + mainapp.longitude + "&overname=2&zoom=" + zoomLevel
             + "&naam=" + mainapp.locPlace + "&size=3&voor=1"
        experimental {
            transparentBackground: true
        }
        experimental.preferences.fullScreenEnabled: true
        VerticalScrollDecorator {}
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

        HorizontalScrollDecorator {
            // Yeah necessary for larger images and other large sites or zoomed in sites
            parent: threeHourLocalPage
            color: Theme.highlightColor // Otherwise we might end up with white decorator on white background
            height: Theme.paddingSmall // We want to see it properly
            flickable: webView
        }
    }
}
