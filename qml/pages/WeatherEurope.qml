import QtQuick 2.2
import Sailfish.Silica 1.0
import "../common"

Page {
    id: temperaturePage

    onStatusChanged: {
        switch (status) {
        case PageStatus.Active:
            // add the cloud page to the pagestack
            pageStack.pushAttached(Qt.resolvedUrl("CloudsEurope.qml"))
        }
    }

    Column {
        id: col
        spacing: Theme.paddingLarge
        width: parent.width
        PageHeader {
            title: isPortrait ? "Midden-Europa" : "Midden-\nEuropa"
        }
    }

    ZoomableImage {
        id: zoomableImage
        anchors.fill: parent
        imagePath: "http://api.buienradar.nl/image/1.0/RadarMapEU"
    }
}
