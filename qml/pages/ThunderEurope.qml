import QtQuick 2.2
import Sailfish.Silica 1.0
import "../common"

Page {
    id: thunderEuropePage

    Column {
        id: col
        spacing: Theme.paddingLarge
        width: parent.width
        PageHeader {
            title: isPortrait ? "Onweer/wolken Europa" : "Onweer/\nwolken\nEuropa"
        }
    }

    ZoomableImage {
        id: zoomableImage
        anchors.fill: parent
        imagePath: "http://api.buienradar.nl/image/1.0/radarcloudseu"
    }
}
