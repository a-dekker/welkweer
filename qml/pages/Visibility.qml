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
