import QtQuick 2.5
import Sailfish.Silica 1.0
import "../common"

Page {
    id: currentWeatherPage

    onStatusChanged: {
        switch (status) {
        case PageStatus.Active:
            // add the NL24hours page to the pagestack
            pageStack.pushAttached(Qt.resolvedUrl("NL24hours.qml"))
        }
    }

    Column {
        id: col
        spacing: Theme.paddingLarge
        width: parent.width
        PageHeader {
            title: isPortrait ? "Komend uur NL" : "1 uur NL"
        }
    }

    ZoomableImage {
        id: zoomableImage
        anchors.fill: parent
        imagePath: "http://api.buienradar.nl/image/1.0/radarmapnl/gif/?hist=0&forc=12&width=550&l=1&step=1"
    }
}
