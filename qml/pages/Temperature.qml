import QtQuick 2.5
import Sailfish.Silica 1.0
import "../common"

Page {
    id: temperaturePage

    onStatusChanged: {
        switch (status) {
        case PageStatus.Active:
            // add the windchill page to the pagestack
            pageStack.pushAttached(Qt.resolvedUrl("Windchill.qml"))
        }
    }

    Column {
        id: col
        spacing: Theme.paddingLarge
        width: parent.width
        PageHeader {
            title: isPortrait ? "Temperatuur NL" : "Temperatuur\nNL"
        }
    }

    ZoomableImage {
        id: zoomableImage
        anchors.fill: parent
        imagePath: "https://weerdata.weerslag.nl/image/1.0/?size=temperatuuranimatie&type=Freecontent"
    }
}
