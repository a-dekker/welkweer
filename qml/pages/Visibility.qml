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
                myText: "Zicht in meters"
                myURL: "https://weerdata.weerslag.nl/image/1.0/?size=zichtanimatie&type=Freecontent"
                myHeaderP: "Zicht NL mtrs"
                myHeaderL: "Zicht NL mtrs"
            }
            ListElement {
                myText: "Zicht in kilometers"
                myURL: "https://image.buienradar.nl/2.0/image/animation/WeatherMapVisibilityNL?width=700&height=765"
                myHeaderP: "Zicht NL km"
                myHeaderL: "Zicht NL km"
            }
            ListElement {
                myText: "Zonsopkomst/ondergang"
                myURL: "https://api.buienradar.nl/image/1.0/satvisual/?ext=gif&type=NL"
                myHeaderP: "Satelliet"
                myHeaderL: "Satelliet"
            }
            ListElement {
                myText: "Totaal aantal zonuren"
                myURL: "https://api.buienradar.nl/image/1.0/weathermapnl/?ext=png&width=500&type=zonneschijn"
                myHeaderP: "Zonuren"
                myHeaderL: "Zonuren"
            }
        }

        Column {
            id: content
            width: parent.width

            PageHeader {
                title: "Zicht NL"
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
