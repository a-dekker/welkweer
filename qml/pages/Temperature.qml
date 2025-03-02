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
                myText: "Temperaturen in NL"
                myURL: "https://image.buienradar.nl/2.0/image/animation/WeatherMapTemperatureActualNL"
                myHeaderP: "Temperatuur NL"
                myHeaderL: "Temperatuur\nNL"
            }
            ListElement {
                myText: "Gevoelstemperatuur NL"
                myURL: "https://cdn.knmi.nl/knmi/map/page/weer/actueel-weer/gevoelstemperatuur.png"
                myHeaderP: "Gevoelstemperatuur NL"
                myHeaderL: "Gevoelstemp\nNL"
            }
            ListElement {
                myText: "Grondtemperatuur NL"
                myURL: "https://image-lite.buienradar.nl/3.0/singleimage/WeatherMapGroundTemperature10mNL"
                myHeaderP: "Grondtemperatuur NL"
                myHeaderL: "Grondtemp\nNL"
            }
            ListElement {
                myText: "Min. grondtemperatuur NL"
                myURL: "https://image-lite.buienradar.nl/3.0/singleimage/WeatherMapMinGroundTemperature10mNL"
                myHeaderP: "Min. grondtemperatuur NL"
                myHeaderL: "Min. Grondtemp\nNL"
            }
            ListElement {
                myText: "Min. temperaturen NL"
                myURL: "https://image-lite.buienradar.nl/3.0/singleimage/WeatherMapMinTemperature10mNL"
                myHeaderP: "Minimumtemperatuur NL"
                myHeaderL: "Mintemp\nNL"
            }
            ListElement {
                myText: "Max. temperaturen NL"
                myURL: "https://image-lite.buienradar.nl/3.0/singleimage/WeatherMapMaxTemperature10mNL"
                myHeaderP: "Maximumtemperatuur NL"
                myHeaderL: "Maxtemp\nNL"
            }
            //ListElement {
            //    myText: "Zeetemperatuur"
            //    myURL: "https://cdn.knmi.nl/knmi/map/page/weer/actueel-weer/sst_nz.png"
            //    myHeaderP: "Zeetemperatuur"
            //    myHeaderL: "Zee\ntemperatuur"
            //}
            ListElement {
                myText: "Temperaturen in Europa"
                myURL: "https://tempsreel.infoclimat.net/temperature/europe_now.png"
                myHeaderP: "Temperaturen Europa"
                myHeaderL: "Temperaturen\nEuropa"
            }
        }

        Column {
            id: content
            width: parent.width

            PageHeader {
                title: "Temperatuur"
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
            MainPageButton {
                text: "Temperatuurgrafiek per uur"
                onClicked: pageStack.push(Qt.resolvedUrl("TemperatureChart.qml"))
            }
        }
    }
}
