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
                title: "Temperatuur"
            }

            MainPageButton {
                text: "Temperaturen in NL"
                onClicked: pageStack.push(Qt.resolvedUrl("Temperature.qml"))
            }

            MainPageButton {
                text: "Gevoelstemperatuur NL"
                onClicked: pageStack.push(Qt.resolvedUrl("Windchill.qml"))
            }
        }
    }
}
