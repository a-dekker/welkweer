import QtQuick 2.5
import Sailfish.Silica 1.0
import "../common"

Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height
        VerticalScrollDecorator {}

        ListModel {
            id: imageInfoModel
            ListElement {
                myText: "Komende 24 uur NL"
                myURL: "https://image.buienradar.nl/2.0/image/animation/RadarMapRain24HourForecastNL"
                myHeaderP: "Komende 24 uur NL"
                myHeaderL: "24 uur NL"
            }
            ListElement {
                myText: "Motregen in NL"
                myURL: "https://image.buienradar.nl/2.0/image/animation/RadarMapDrizzleNL"
                myHeaderP: "Motregen NL"
                myHeaderL: "Motregen\nNL"
            }
            ListElement {
                myText: "Sneeuwval in NL"
                myURL: "http://api.buienradar.nl/image/1.0/snowmapnl/gif/?width=550&rndm=1"
                myHeaderP: "Sneeuw NL"
                myHeaderL: "Sneeuw\nNL"
            }
            ListElement {
                myText: "Neerslag afgelopen uur NL"
                myURL: "https://api.buienradar.nl/image/1.0/weathermapnl/?ext=png&width=500&type=neerslaguur"
                myHeaderP: "Neerslag uur NL"
                myHeaderL: "Neerslag u.\nNL"
            }
            ListElement {
                myText: "Neerslag afgelopen 24 uur NL"
                myURL: "https://api.buienradar.nl/image/1.0/weathermapnl/?ext=png&width=500&type=neerslag24uur"
                myHeaderP: "Neerslag 24 uur NL"
                myHeaderL: "Neerslag 24 u.\nNL"
            }
            ListElement {
                myText: "Luchtvochtigheid NL"
                myURL: "https://api.buienradar.nl/image/1.0/weathermapnl/?ext=png&width=500&type=luchtvochtigheid"
                myHeaderP: "Luchtvochtigheid NL"
                myHeaderL: "Luchtvocht.\nNL"
            }
            ListElement {
                myText: "Infrarood Europa"
                myURL: "https://image.buienradar.nl/2.0/image/animation/SatInfraRed"
                myHeaderP: "Infrarood Europa"
                myHeaderL: "Infrarood\nEuropa"
            }
            ListElement {
                myText: "Onweer in Midden-Europa"
                myURL: "https://image.buienradar.nl/2.0/image/animation/RadarMapCloudEU"
                myHeaderP: "Onweer/wolken Europa"
                myHeaderL: "Onweer/\nwolken\nEuropa"
            }
            ListElement {
                myText: "Neerslag in Midden-Europa"
                myURL: "https://image.buienradar.nl/2.0/image/animation/RadarMapRainEU"
                myHeaderP: "Midden-Europa"
                myHeaderL: "Midden-\nEuropa"
            }
        }

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
