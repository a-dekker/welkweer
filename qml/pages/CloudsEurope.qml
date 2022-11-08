import QtQuick 2.5
import Sailfish.Silica 1.0
import "../common"

Page {
    id: cloudsEuropePage

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
        imagePath: "https://image.buienradar.nl/2.0/image/animation/SatInfraRed"
    }
}
