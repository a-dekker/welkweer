import QtQuick 2.0
import Sailfish.Silica 1.0
import "../common"

Page {
    id: windchillPage

    Flickable {
        id: imageFlickable
        anchors.fill: parent
        contentWidth: imageContainer.width; contentHeight: imageContainer.height
        clip: true
        onHeightChanged: if (imagePreview.status === Image.Ready) imagePreview.fitToScreen();

        Column {
            id: col
            spacing: Theme.paddingLarge
            width: parent.width
            PageHeader {
                title: "Gevoelstemperatuur NL"
                visible: isPortrait
            }
        }

        Item {
            id: imageContainer
            width: Math.max(imagePreview.width * imagePreview.scale, imageFlickable.width)
            height: Math.max(imagePreview.height * imagePreview.scale, imageFlickable.height)

            Image {
                id: imagePreview

                property real prevScale

                function fitToScreenInit() {
                    // function is just a workaround to make image show in portrait at startup
                    scale = Math.min(parent.width / width, parent.height / height, 1)
                    pinch.minScale = Math.min(imageFlickable.width / width, imageFlickable.height / height)
                    prevScale = Math.min(imageFlickable.width / width, imageFlickable.height / height)
                }
                function fitToScreen() {
                    scale = Math.min(imageFlickable.width / width, imageFlickable.height / height)
                    pinch.minScale = scale
                    prevScale = scale
                }

                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
                cache: false
                asynchronous: true
                source: "http://www.weerplaza.nl/gdata/10min/GMT_WCHILL_latest.png"
                // source: "http://cdn.knmi.nl/knmi/map/page/weer/actueel-weer/gevoelstemperatuur.png"
                sourceSize.height: 1000;
                smooth: !imageFlickable.moving

                onStatusChanged: {
                    if (status == Image.Ready) {
                        fitToScreenInit()
                        fitToScreen()
                        loadedAnimation.start()
                    }
                }

                NumberAnimation {
                    id: loadedAnimation
                    target: imagePreview
                    property: "opacity"
                    duration: 250
                    from: 0; to: 1
                    easing.type: Easing.InOutQuad
                }

                onScaleChanged: {
                    if ((width * scale) > imageFlickable.width) {
                        var xoff = (imageFlickable.width / 2 + imageFlickable.contentX) * scale / prevScale;
                        imageFlickable.contentX = xoff - imageFlickable.width / 2
                    }
                    if ((height * scale) > imageFlickable.height) {
                        var yoff = (imageFlickable.height / 2 + imageFlickable.contentY) * scale / prevScale;
                        imageFlickable.contentY = yoff - imageFlickable.height / 2
                    }
                    prevScale = scale
                }
            }
        }

        Pinch {
            id: pinch
            anchors.fill: parent
        }
    }

    LoadingIndicator {
        width: parent.width
    }

    VerticalScrollDecorator {  // Yeah necessary for larger images and other large sites or zoomed in sites
        color: Theme.highlightColor // Otherwise we might end up with white decorator on white background
        width: Theme.paddingSmall // We want to see it properly
        flickable: imageFlickable
    }

    HorizontalScrollDecorator {  // Yeah necessary for larger images and other large sites or zoomed in sites
        color: Theme.highlightColor // Otherwise we might end up with white decorator on white background
        height: Theme.paddingSmall // We want to see it properly
        flickable: imageFlickable
    }
}
