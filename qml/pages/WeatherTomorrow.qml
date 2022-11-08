import QtQuick 2.5
import Sailfish.Silica 1.0
import "../common"

Page {
    id: tomorrowPage

    Column {
        id: col
        spacing: Theme.paddingLarge
        width: parent.width
        PageHeader {
            title: isPortrait ? "Weer morgen" : "Weer\nmorgen"
        }
    }

    ZoomableImage {
        id: zoomableImage
        anchors.fill: parent
        imagePath: "http://cdn.knmi.nl/knmi/map/current/weather/forecast/kaart_verwachtingen_Morgen_dag.gif"
    }
}
