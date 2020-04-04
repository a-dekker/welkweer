import QtQuick 2.2
import Sailfish.Silica 1.0
import "../common"

Page {
    id: windchillPage

    Column {
        id: col
        spacing: Theme.paddingLarge
        width: parent.width
        PageHeader {
            title: isPortrait ? "Gevoelstemperatuur NL" : "Gevoelstemp\nNL"
        }
    }

    ZoomableImage {
        id: zoomableImage
        anchors.fill: parent
        imagePath: "http://www.weerplaza.nl/gdata/10min/GMT_WCHILL_latest.png"
    }
}
