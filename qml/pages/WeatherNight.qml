import QtQuick 2.2
import Sailfish.Silica 1.0
import "../common"

Page {
    id: nightPage

    Column {
        id: col
        spacing: Theme.paddingLarge
        width: parent.width
        PageHeader {
            title: isPortrait ? "Weer vannacht" : "Weer\nvannacht"
        }
    }

    ZoomableImage {
        id: zoomableImage
        anchors.fill: parent
        imagePath: "http://cdn.knmi.nl/knmi/map/current/weather/forecast/kaart_verwachtingen_Morgen_nacht.gif"
    }
}
