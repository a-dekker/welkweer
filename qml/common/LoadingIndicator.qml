import QtQuick 2.0
import Sailfish.Silica 1.0

Loader {
    anchors.centerIn: parent
    sourceComponent: {
        switch (imagePreview.status) {
        case Image.Loading:
            return loadingIndicator
        case Image.Error:
            return failedLoading
        default:
            return undefined
        }
    }

    Component {
        id: loadingIndicator

        Item {
            height: childrenRect.height

            BusyIndicator {
                id: imageLoadingIndicator
                anchors.horizontalCenter: parent.horizontalCenter
                running: true
            }

            ProgressBar {
                id: progBar
                minimumValue: 0
                maximumValue: 100
                width: parent.width
                value: Math.round(imagePreview.progress * 100)
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: imageLoadingIndicator.bottom
                    topMargin: Theme.paddingLarge
                }
                visible: imageLoadingIndicator.running
            }
            Text {
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: progBar.bottom
                    topMargin: Theme.paddingLarge
                }
                font.pixelSize: Theme.fontSizeSmall
                color: Theme.highlightColor
                text: qsTr("Laden afbeelding... %1").arg(
                          Math.round(imagePreview.progress * 100) + "%")
            }
        }
    }

    Component {
        id: failedLoading
        Text {
            font.pixelSize: constant.fontXSmall
            text: qsTr("Afbeelding kon niet geladen worden")
            color: Theme.highlightColor
        }
    }
}
