import QtQuick 2.5
import Sailfish.Silica 1.0
import "../common"

Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height

        Column {
            id: content
            width: parent.width

            PageHeader {
                title: "Wind"
            }

            MainPageButton {
                text: "Windkaart NL"
                onClicked: pageStack.push(Qt.resolvedUrl("Wind.qml"))
            }

            MainPageButton {
                text: "Windstoten NL"
                onClicked: pageStack.push(Qt.resolvedUrl("Flurry.qml"))
            }
        }
    }
}
