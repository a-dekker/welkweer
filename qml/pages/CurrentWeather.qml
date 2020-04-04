import QtQuick 2.2
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
            title: isPortrait ? "Komende 3 uur NL" : "3 uur NL"
        }
    }

    ZoomableImage {
        id: zoomableImage
        anchors.fill: parent
        imagePath: "http://api.buienradar.nl/image/1.0/radarmapnl/gif/?hist=0&forc=36&width=550&l=1&step=1"
    }
}
