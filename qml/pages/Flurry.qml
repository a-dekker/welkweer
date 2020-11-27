import QtQuick 2.5
import Sailfish.Silica 1.0
import "../common"

Page {
    id: windstotenPage

    onStatusChanged: {
        switch (status) {
        case PageStatus.Active:
            // add the visibility page to the pagestack
            pageStack.pushAttached(Qt.resolvedUrl("Visibility.qml"))
        }
    }

    Column {
        id: col
        spacing: Theme.paddingLarge
        width: parent.width
        PageHeader {
            title: isPortrait ? "Windstoten NL" : "Windstoten\nNL"
        }
    }

    ZoomableImage {
        id: zoomableImage
        anchors.fill: parent
        imagePath: "https://weerdata.weerslag.nl/image/1.0/?size=maxwindkmanimatie&type=Freecontent"
    }
}
