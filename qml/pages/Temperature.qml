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
                myURL: "https://weerdata.weerslag.nl/image/1.0/?size=temperatuuranimatie&type=Freecontent"
                myHeaderP: "Temperatuur NL"
                myHeaderL: "Temperatuur\nNL"
            }
            ListElement {
                myText: "Gevoelstemperatuur NL"
                myURL: "https://api.buienradar.nl/image/1.0/weathermapnl/?ext=png&width=500&type=gevoelstemperatuur"
                myHeaderP: "Gevoelstemperatuur NL"
                myHeaderL: "Gevoelstemp\nNL"
            }
            ListElement {
                myText: "Grondtemperatuur NL"
                myURL: "https://api.buienradar.nl/image/1.0/weathermapnl/?ext=png&width=500&type=temperatuurgrond"
                myHeaderP: "Grondtemperatuur NL"
                myHeaderL: "Grondtemp\nNL"
            }
            ListElement {
                myText: "Min. grondtemperatuur NL"
                myURL: "https://api.buienradar.nl/image/1.0/weathermapnl/?ext=png&width=500&type=temperatuurgrondmin"
                myHeaderP: "Min. grondtemperatuur NL"
                myHeaderL: "Min. Grondtemp\nNL"
            }
            ListElement {
                myText: "Min. temperaturen NL"
                myURL: "https://api.buienradar.nl/image/1.0/weathermapnl/?ext=png&width=500&type=temperatuurmin"
                myHeaderP: "Minimumtemperatuur NL"
                myHeaderL: "Mintemp\nNL"
            }
            ListElement {
                myText: "Max. temperaturen NL"
                myURL: "https://api.buienradar.nl/image/1.0/weathermapnl/?ext=png&width=500&type=temperatuurmax"
                myHeaderP: "Maximumtemperatuur NL"
                myHeaderL: "Maxtemp\nNL"
            }
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
        }
    }
}
