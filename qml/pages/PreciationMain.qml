import QtQuick 2.5
import Sailfish.Silica 1.0
import "../common"

Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height
        VerticalScrollDecorator {}

        Column {
            id: content
            width: parent.width

            PageHeader {
                title: "Neerslag"
            }

            MainPageButton {
                text: "Grafiek komende 2 uur " + mainapp.locPlace
                onClicked: pageStack.push(Qt.resolvedUrl("RainFall.qml"))
            }
            MainPageButton {
                text: "Komend uur in NL"
                onClicked: pageStack.push(Qt.resolvedUrl("CurrentWeather.qml"))
            }
            MainPageButton {
                text: "Lokaal komende 3 uur " + mainapp.locPlace
                onClicked: pageStack.push(Qt.resolvedUrl("Weather3hr.qml"))
            }
            MainPageButton {
                text: "Komende 24 uur NL"
                onClicked: pageStack.push(Qt.resolvedUrl("NL24hours.qml"))
            }
            MainPageButton {
                text: "Motregen in NL"
                onClicked: pageStack.push(Qt.resolvedUrl("Drizzle.qml"))
            }
            MainPageButton {
                text: "Sneeuwval in NL"
                onClicked: pageStack.push(Qt.resolvedUrl("Snow.qml"))
            }
            MainPageButton {
                text: "Infrarood Europa"
                onClicked: pageStack.push(Qt.resolvedUrl("CloudsEurope.qml"))
            }
            MainPageButton {
                text: "Onweer in Midden-Europa"
                onClicked: pageStack.push(Qt.resolvedUrl("ThunderEurope.qml"))
            }
            MainPageButton {
                text: "Neerslag in Midden-Europa"
                onClicked: pageStack.push(Qt.resolvedUrl("WeatherEurope.qml"))
            }
        }
    }
}
