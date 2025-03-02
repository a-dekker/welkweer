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

    //function get_timestamp() {
    //    //get datetime minus 10 minutes and round down to 10 minutes
    //    var loc_datetime = new Date(Date.now() - 10000 * 60)
    //    return parseInt(
    //                loc_datetime.getFullYear() + ("0" + (loc_datetime.getMonth(
    //                                                         ) + 1)).slice(
    //                    -2) + ("0" + loc_datetime.getDate()).slice(
    //                    -2) + ("0" + loc_datetime.getHours()).slice(
    //                    -2) + ("0" + loc_datetime.getMinutes()).slice(-2) / 10,
    //                10) * 10
    //}

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height

        ListModel {
            id: imageInfoModel
            Component.onCompleted: {
                [{
                    "myText": "Windkaart NL",
                    "myURL": "https://image.buienradar.nl/2.0/image/animation/WeatherMapWindNL",
                    "myHeaderP": "Windkaart NL",
                    "myHeaderL": "Windkaart\nNL"
                }, {
                    "myText": "Windstoten NL",
                    "myURL": "https://image.buienradar.nl/2.0/image/animation/WeatherMapWindGustsNL",
                    "myHeaderP": "Windstoten NL",
                    "myHeaderL": "Windstoten\nNL"
                }, {
                    "myText": "Max. wind NL",
                    "myURL": "https://image-lite.buienradar.nl/3.0/singleimage/WeatherMapMaxWind10mNL",
                    "myHeaderP" : "Max wind NL",
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
