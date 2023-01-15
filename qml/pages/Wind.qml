import QtQuick 2.5
import Sailfish.Silica 1.0
import "../common"

Page {
    id: page

    function get_pressure_url() {
        var loc_time = new Date()
        var local_time_hour = loc_time.getHours()
        var pressure_url = "https://zeeweer.nl/live/items/weerkaart.jpg"

        if (local_time_hour > 17) {
            pressure_url = "https://zeeweer.nl/live/items/weerkaart18.jpg"
        } else if (local_time_hour > 11) {
            pressure_url = "https://zeeweer.nl/live/items/weerkaart12.jpg"
        }
        return pressure_url
    }

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height

        ListModel {
            id: imageInfoModel
            Component.onCompleted: {
                [{
                    "myText": "Windkaart NL",
                    "myURL": "https://weerdata.weerslag.nl/image/1.0/?size=windkrachtanimatie&type=Freecontent",
                    "myHeaderP": "Windkaart NL",
                    "myHeaderL": "Windkaart\nNL"
                }, {
                    "myText": "Windstoten NL",
                    "myURL": "https://weerdata.weerslag.nl/image/1.0/?size=maxwindkmanimatie&type=Freecontent",
                    "myHeaderP": "Windstoten NL",
                    "myHeaderL": "Windstoten\nNL"
                }, {
                    "myText": "Max. wind NL",
                    "myURL": "https://api.buienradar.nl/image/1.0/weathermapnl/?ext=png&width=500&type=windmax",
                    "myHeaderP": "Max wind NL",
                    "myHeaderL": "Max wind\nNL"
                }, {
                    "myText": "Luchtdruk Europa",
                    "myURL": get_pressure_url(),
                    "myHeaderP": "Luchtdruk",
                    "myHeaderL": "Lucht\ndruk"
                }].forEach(function (e) {
                    append(e)
                })
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
