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
                myText: "Zicht in kilometers"
                myURL: "https://image.buienradar.nl/2.0/image/animation/WeatherMapVisibilityNL?width=700&height=765"
                myHeaderP: "Zicht NL km"
                myHeaderL: "Zicht NL km"
            }
            ListElement {
                myText: "Zicht in meters"
                myURL: "https://cdn.knmi.nl/knmi/map/page/weer/actueel-weer/zicht.png"
                myHeaderP: "Zicht NL mtr"
                myHeaderL: "Zicht NL mtr"
            }
            ListElement {
                myText: "Zonkracht (UV)"
                myURL: "https://image-lite.buienradar.nl/3.0/singleimage/WeatherMapUv1dNL"
                myHeaderP: "Zonkracht UV"
                myHeaderL: "Zonkracht\nUV"
            }
            ListElement {
                myText: "Zonsopkomst/ondergang"
                myURL: "https://image-lite.buienradar.nl/3.0/singleimage/SatMapVisual15m?subtype=nl"
                myHeaderP: "Satelliet"
                myHeaderL: "Satelliet"
            }
            ListElement {
                myText: "Totaal aantal zonuren"
                myURL: "https://image-lite.buienradar.nl/3.0/singleimage/WeatherMapSunHours10mNL"
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
