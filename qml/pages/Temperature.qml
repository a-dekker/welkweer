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
                myText: "Temperaturen in NL"
                myURL: "https://weerdata.weerslag.nl/image/1.0/?size=temperatuuranimatie&type=Freecontent"
                myHeaderP: "Temperatuur NL"
                myHeaderL: "Temperatuur\nNL"
            }
            ListElement {
                myText: "Gevoelstemperatuur NL"
                myURL: "http://www.weerplaza.nl/gdata/10min/GMT_WCHILL_latest.png"
                myHeaderP: "Gevoelstemperatuur NL"
                myHeaderL: "Gevoelstemp\nNL"
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
