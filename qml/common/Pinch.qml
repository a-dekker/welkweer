import QtQuick 2.0
import Sailfish.Silica 1.0

PinchArea {
    id: pinchArea

    property real minScale: 1.0
    property real maxScale: largeScreen ? 6.0 : 3.0

    // anchors.fill: parent
    enabled: imagePreview.status === Image.Ready
    pinch.target: imagePreview
    pinch.minimumScale: minScale * 0.5 // This is to create "bounce back effect"
    pinch.maximumScale: maxScale * 1.5 // when over zoomed

    onPinchFinished: {
        imageFlickable.returnToBounds()
        if (imagePreview.scale < pinchArea.minScale) {
            bounceBackAnimation.to = pinchArea.minScale
            bounceBackAnimation.start()
        }
        else if (imagePreview.scale > pinchArea.maxScale) {
            bounceBackAnimation.to = pinchArea.maxScale
            bounceBackAnimation.start()
        }
    }
    NumberAnimation {
        id: bounceBackAnimation
        target: imagePreview
        duration: 250
        property: "scale"
        from: imagePreview.scale
    }
}
