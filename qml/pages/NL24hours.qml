import QtQuick 2.2
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
        imagePath: "http://api.buienradar.nl/image/1.0/24HourForecastMapNL/gif/?hist=0&forc=24&width=550&l=1&step=0"
    }
}
