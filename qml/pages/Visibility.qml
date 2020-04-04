import QtQuick 2.2
import Sailfish.Silica 1.0
import "../common"

Page {
    id: visibilityPage

    Column {
        id: col
        spacing: Theme.paddingLarge
        width: parent.width
        PageHeader {
            title: "Zicht NL"
        }
    }

    ZoomableImage {
        id: zoomableImage
        anchors.fill: parent
        imagePath: "https://weerdata.weerslag.nl/image/1.0/?size=zichtanimatie&type=Freecontent"
    }
}
