import QtQuick 2.5
import Sailfish.Silica 1.0
import Sailfish.WebView 1.0
import Sailfish.WebEngine 1.0
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
            id: pageHeader
            title: "Lokaal 3 uur"
            visible: isPortrait
        }
    }
    WebView {
        id: webView
        active: visible
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        height: isPortrait ? parent.height - (2 * pageHeader.height) : parent.height
        url: "https://gadgets.buienradar.nl/gadget/zoommap/?lat="
             + mainapp.latitude + "&lng=" + mainapp.longitude + "&overname=2&zoom="
             + zoomLevel + "&naam=" + mainapp.locPlace + "&size=3&voor=1"
        privateMode: true
        Component.onCompleted: {
            WebEngineSettings.cookieBehavior = WebEngineSettings.BlockAll
        }
    }
}
