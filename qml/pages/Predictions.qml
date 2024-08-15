import QtQuick 2.5
import Sailfish.Silica 1.0
import "../common"

Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height

        ListModel {
            id: imageInfoModel
            ListElement {
                myText: "Morgen in NL"
                myURL: "http://cdn.knmi.nl/knmi/map/current/weather/forecast/kaart_verwachtingen_Morgen_dag.gif"
                myHeaderP: "Weer morgen"
                myHeaderL: "Weer\nmorgen"
            }
            ListElement {
                myText: "Vannacht in NL"
                myURL: "http://cdn.knmi.nl/knmi/map/current/weather/forecast/kaart_verwachtingen_Morgen_nacht.gif"
                myHeaderP: "Weer vannacht"
                myHeaderL: "Weer\nvannacht"
            }
            ListElement {
                myText: "Neerslag komende 24 uur NL"
                myURL: "https://image.buienradar.nl/2.0/image/animation/RadarMapRain24HourForecastNL"
                myHeaderP: "Komende 24 uur NL"
                myHeaderL: "24 uur NL"
            }
        }

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
                text: "Temperatuur en wind per uur"
                onClicked: pageStack.push(Qt.resolvedUrl("WeatherHour.qml"))
            }
            Repeater {
                id: imageRepeater
                model: imageInfoModel
                delegate: MainPageButton {
                    text: model.myText
                    onClicked: pageStack.push(Qt.resolvedUrl("ImagePage.qml"), {
                                                  "imageURL": model.myURL,
                                                  "headerTXTPortrait": model.myHeaderP,
                                                  "headerTXTLandscape": model.myHeaderL
                                              })
                }
            }
        }
    }
}
