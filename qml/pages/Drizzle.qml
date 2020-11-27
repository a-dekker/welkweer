import QtQuick 2.5
import Sailfish.Silica 1.0
import "../common"

Page {
    id: drizzlePage

    onStatusChanged: {
        switch (status) {
        case PageStatus.Active:
            // add the thunder page to the pagestack
            pageStack.pushAttached(Qt.resolvedUrl("Snow.qml"))
        }
    }

    Column {
        id: col
        spacing: Theme.paddingLarge
        width: parent.width
        PageHeader {
            title: isPortrait ? "Motregen NL" : "Motregen\nNL"
        }
    }

    ZoomableImage {
        id: zoomableImage
        anchors.fill: parent
        imagePath: "https://image.buienradar.nl/2.0/image/animation/RadarMapDrizzleNL"
    }
}
