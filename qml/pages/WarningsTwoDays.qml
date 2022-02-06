import QtQuick 2.5
import Sailfish.Silica 1.0
import "../common"

Page {

    Column {
        id: col
        spacing: Theme.paddingLarge
        width: parent.width
        PageHeader {
            title: isPortrait ? "Waarsch. NL overmorgen" : "Waarschuwingen\nNL overmorgen"
        }
    }

    ZoomableImage {
        id: zoomableImage
        anchors.fill: parent
        imagePath: "https://cdn.knmi.nl/knmi/map/current/weather/warning/waarschuwing_land_2_new.gif?957fb971c0221877c4ab0e3bc19f7663"
    }
}
