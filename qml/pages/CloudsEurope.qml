import QtQuick 2.2
import Sailfish.Silica 1.0
import "../common"

Page {
    id: cloudsEuropePage

    onStatusChanged: {
        switch (status) {
        case PageStatus.Active:
            // add the thunder page to the pagestack
            pageStack.pushAttached(Qt.resolvedUrl("ThunderEurope.qml"))
        }
    }

    Column {
        id: col
        spacing: Theme.paddingLarge
        width: parent.width
        PageHeader {
            title: isPortrait ? "Infrarood Europa" : "Infrarood\nEuropa"
        }
    }

    ZoomableImage {
        id: zoomableImage
        anchors.fill: parent
        imagePath: "http://api.buienradar.nl/image/1.0/satinfrared/?hist=8&type=o_eu"
    }
}
