import QtQuick 2.5
import Sailfish.Silica 1.0
import "../common"

Page {
    id: windPage

    onStatusChanged: {
        switch (status) {
        case PageStatus.Active:
            // add the flurry page to the pagestack
            pageStack.pushAttached(Qt.resolvedUrl("Flurry.qml"))
        }
    }

    Column {
        id: col
        spacing: Theme.paddingLarge
        width: parent.width
        PageHeader {
            title: isPortrait ? "Windkaart NL" : "Windkaart\nNL"
        }
    }

    ZoomableImage {
        id: zoomableImage
        anchors.fill: parent
        imagePath: "https://weerdata.weerslag.nl/image/1.0/?size=windkrachtanimatie&type=Freecontent"
    }
}
