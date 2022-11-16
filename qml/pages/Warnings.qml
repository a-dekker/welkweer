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
                myText: "Weeralarm vandaag"
                myURL: "https://cdn.knmi.nl/knmi/map/current/weather/warning/waarschuwing_land_0_new.gif?957fb971c0221877c4ab0e3bc19f7663"
                myHeaderP: "Waarschuwingen NL"
                myHeaderL: "Waarschuwingen\nNL"
            }
            ListElement {
                myText: "Weeralarm morgen"
                myURL: "https://cdn.knmi.nl/knmi/map/current/weather/warning/waarschuwing_land_1_new.gif?957fb971c0221877c4ab0e3bc19f7663"
                myHeaderP: "Waarschuwingen NL morgen"
                myHeaderL: "Waarschuwingen\nNL morgen"
            }
            ListElement {
                myText: "Weeralarm overmorgen"
                myURL: "https://cdn.knmi.nl/knmi/map/current/weather/warning/waarschuwing_land_2_new.gif?957fb971c0221877c4ab0e3bc19f7663"
                myHeaderP: "Waarsch. NL overmorgen"
                myHeaderL: "Waarschuwingen\nNL overmorgen"
            }
        }
        Column {
            id: content
            width: parent.width

            PageHeader {
                title: "Weeralarm"
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
