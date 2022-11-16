import QtQuick 2.5
import Sailfish.Silica 1.0
import "../common"

Page {
    id: page
    property string imageURL
    property string headerTXTPortrait
    property string headerTXTLandscape

    Column {
        id: col
        spacing: Theme.paddingLarge
        width: parent.width
        PageHeader {
            title: isPortrait ? headerTXTPortrait : headerTXTLandscape
        }
    }

    ZoomableImage {
        id: zoomableImage
        anchors.fill: parent
        imagePath: imageURL
    }
}
