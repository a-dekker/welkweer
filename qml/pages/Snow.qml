import QtQuick 2.5
import Sailfish.Silica 1.0
import "../common"

Page {
    id: snowPage

    Column {
        id: col
        spacing: Theme.paddingLarge
        width: parent.width
        PageHeader {
            title: isPortrait ? "Sneeuw NL" : "Sneeuw\nNL"
        }
    }
    ZoomableImage {
        id: zoomableImage
        anchors.fill: parent
        imagePath: "http://api.buienradar.nl/image/1.0/snowmapnl/gif/?width=550&rndm=1"
    }
}
