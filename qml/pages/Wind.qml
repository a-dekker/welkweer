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
