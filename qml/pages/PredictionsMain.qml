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
                title: "Voorspellingen"
            }

            MainPageButton {
                text: "5 daagse voorspelling NL"
                onClicked: pageStack.push(Qt.resolvedUrl("Forecast.qml"))
            }
            MainPageButton {
                text: "Beschrijving komend weer NL"
                onClicked: pageStack.push(Qt.resolvedUrl("WeatherText.qml"))
            }
            MainPageButton {
                text: "Morgen in NL"
                onClicked: pageStack.push(Qt.resolvedUrl("WeatherTomorrow.qml"))
            }
            MainPageButton {
                text: "Vannacht in NL"
                onClicked: pageStack.push(Qt.resolvedUrl("WeatherNight.qml"))
            }
        }
    }
}
