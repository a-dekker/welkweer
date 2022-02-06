import QtQuick 2.5
import Sailfish.Silica 1.0
import "../common"

Page {

    onStatusChanged: {
        switch (status) {
        case PageStatus.Active:
            pageStack.pushAttached(Qt.resolvedUrl("WarningsTwoDays.qml"))
        }
    }

    Column {
        id: col
        spacing: Theme.paddingLarge
        width: parent.width
        PageHeader {
            title: isPortrait ? "Waarschuwingen NL morgen" : "Waarschuwingen\nNL morgen"
        }
    }

    ZoomableImage {
        id: zoomableImage
        anchors.fill: parent
        imagePath: "https://cdn.knmi.nl/knmi/map/current/weather/warning/waarschuwing_land_1_new.gif?957fb971c0221877c4ab0e3bc19f7663"
    }
}
