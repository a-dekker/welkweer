import QtQuick 2.5
import Sailfish.Silica 1.0
import "../common"

Page {
    id: hour24Page

    onStatusChanged: {
        switch (status) {
        case PageStatus.Active:
            // add the cloud page to the pagestack
            pageStack.pushAttached(Qt.resolvedUrl("Drizzle.qml"))
        }
    }

    Column {
        id: col
        spacing: Theme.paddingLarge
        width: parent.width
        PageHeader {
            title: isPortrait ? "Komende 24 uur NL" : "24 uur NL"
        }
    }

    ZoomableImage {
        id: zoomableImage
        anchors.fill: parent
        imagePath: "https://image.buienradar.nl/2.0/image/animation/RadarMapRain24HourForecastNL"
    }
}
