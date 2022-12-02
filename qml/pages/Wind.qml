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
                myText: "Windkaart NL"
                myURL: "https://weerdata.weerslag.nl/image/1.0/?size=windkrachtanimatie&type=Freecontent"
                myHeaderP: "Windkaart NL"
                myHeaderL: "Windkaart\nNL"
            }
            ListElement {
                myText: "Windstoten NL"
                myURL: "https://weerdata.weerslag.nl/image/1.0/?size=maxwindkmanimatie&type=Freecontent"
                myHeaderP: "Windstoten NL"
                myHeaderL: "Windstoten\nNL"
            }
            ListElement {
                myText: "Max. wind NL"
                myURL: "https://api.buienradar.nl/image/1.0/weathermapnl/?ext=png&width=500&type=windmax"
                myHeaderP: "Max wind NL"
                myHeaderL: "Max wind\nNL"
            }
        }

        Column {
            id: content
            width: parent.width

            PageHeader {
                title: "Wind"
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
