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
            ListElement {
                myText: "Muggen overlast"
                myURL: "https://api.buienradar.nl/image/1.0/mosquitoradarnl/?ext=png&width=500"
                myHeaderP: "Muggen overlast (1 weinig, 10 veel)"
                myHeaderL: "Muggen\noverlast"
            }
            ListElement {
                myText: "Hooikoorts/pollen klachten"
                myURL: "https://api.buienradar.nl/image/1.0/pollenradarnl/?ext=png&w=500"
                myHeaderP: "Pollen en hooikoorts (1-10)"
                myHeaderL: "Pollen\nhooikoorts"
            }
            ListElement {
                myText: "Fijnstof"
                myURL: "https://api.buienradar.nl/image/1.0/airqualitymapnl/?ext=png&width=500&type=pm10"
                myHeaderP: "Fijnstof (0-200)"
                myHeaderL: "Fijnstof"
            }
            ListElement {
                myText: "Luchtkwaliteitsindex"
                myURL: "https://api.buienradar.nl/image/1.0/airqualitymapnl/?ext=png&width=500&type=lki"
                myHeaderP: "Luchtkwaliteit (hoger=slechter)"
                myHeaderL: "Lucht\nkwaliteit"
            }
            ListElement {
                myText: "Stikstofdioxide"
                myURL: "https://api.buienradar.nl/image/1.0/airqualitymapnl/?ext=png&width=500&type=no2"
                myHeaderP: "Stikstofdioxide (0-200 µg/m3)"
                myHeaderL: "Stikstof\ndioxide"
            }
            ListElement {
                myText: "Ozon"
                myURL: "https://api.buienradar.nl/image/1.0/airqualitymapnl/?ext=png&width=500&type=ozon"
                myHeaderP: "Ozon (0-240 µg/m3)"
                myHeaderL: "Ozon\n(0-240 µg/m3)"
            }
        }
        Column {
            id: content
            width: parent.width

            PageHeader {
                title: "(Weer)alarm"
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
