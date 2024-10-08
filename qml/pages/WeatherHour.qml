import QtQuick 2.5
import Sailfish.Silica 1.0
import harbour.welkweer.Settings 1.0
import "../common"

// https://api.met.no/weatherapi/locationforecast/2.0/complete?lat=51.17416597&lon=6.870996516&altitude=44
Page {
    id: page

    MySettings {
        id: myset
    }
    property string forecastHours: myset.value("forecast_hours", "14")
    property var measureMoment

    ListModel {
        id: dataModel
    }

    function degToCompass(num) {
        var val = Math.floor((num / 22.5) + 0.5)
        var arr = ["↓ N", "↙ NNO", "↙ NO", "↙ ONO", "← O", "↖ OZO", "↖ ZO", "↖ ZZO", "↑ Z", "↗ ZZW", "↗ ZW", "↗ WZW", "→ W", "↘ WNW", "↘ NW", "↘ NNW"]
        return arr[(val % 16)]
    }

    function getDayMonthOrTime(datum, date_or_time) {
        const d = new Date(datum)
        if (date_or_time === "date") {
            const month = d.getMonth()
            const day = d.getDate()
            const year = d.getFullYear()
            return (("0" + day).slice(-2) + "/" + ("0" + month).slice(
                        -2) + "/" + ("" + year).slice(-2))
        }
        if (date_or_time === "time") {
            const hour = d.getHours()
            return ("0" + hour).slice(-2) + ":00"
        }
    }

    function msToBeaufort(ms) {
        ms = Math.abs(ms)
        if (ms <= 0.2) {
            return 0
        }
        if (ms <= 1.5) {
            return 1
        }
        if (ms <= 3.3) {
            return 2
        }
        if (ms <= 5.4) {
            return 3
        }
        if (ms <= 7.9) {
            return 4
        }
        if (ms <= 10.7) {
            return 5
        }
        if (ms <= 13.8) {
            return 6
        }
        if (ms <= 17.1) {
            return 7
        }
        if (ms <= 20.7) {
            return 8
        }
        if (ms <= 24.4) {
            return 9
        }
        if (ms <= 28.4) {
            return 10
        }
        if (ms <= 32.6) {
            return 11
        }
        return 12
    }

    function metno_info() {
        var req = new XMLHttpRequest()
        // console.log("https://api.met.no/weatherapi/locationforecast/2.0/complete?lat="
        //             + mainapp.latitude + "&lon=" + mainapp.longitude)
        req.open("GET",
                 "https://api.met.no/weatherapi/locationforecast/2.0/complete?lat="
                 + mainapp.latitude + "&lon=" + mainapp.longitude)

        req.onreadystatechange = function () {
            if (req.readyState === XMLHttpRequest.DONE) {
                if (req.status && req.status === 200) {
                    var objectArray = JSON.parse(req.responseText)
                    if (objectArray.errors !== undefined) {
                        console.log("Error fetching: " + objectArray.errors[0].message)
                    } else {
                        for (var key in objectArray) {
                            if (key === "properties") {
                                var update_timestamp
                                update_timestamp = objectArray[key]["meta"]["updated_at"]
                                for (var timeserie = 0; timeserie < forecastHours; timeserie++) {
                                    dataModel.append(
                                                JSON.parse("{" + (JSON.stringify(objectArray[key]["timeseries"][timeserie]["data"]["next_1_hours"]["details"]) + "," + JSON.stringify(objectArray[key]["timeseries"][timeserie]["data"]["next_1_hours"]["summary"]) + "," + JSON.stringify(objectArray[key]["timeseries"][timeserie]["data"]["instant"]["details"]) + ",\"time\":" + JSON.stringify(objectArray[key]["timeseries"][timeserie]["time"])).replace(/{/g, "").replace(/}/g, "") + "}"))
                                }
                            }
                        }
                    }
                }
                var measureDateTime = new Date(update_timestamp)
                measureMoment = measureDateTime
            }
        }
        req.send()
    }

    BusyIndicator {
        id: waitIndicator
        anchors.centerIn: parent
        running: dataModel.count === 0
        size: BusyIndicatorSize.Large
    }

    Component.onCompleted: {
        metno_info()
    }

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        PullDownMenu {
            MenuItem {
                text: qsTr("Vernieuwen")
                onClicked: {
                    dataModel.clear()
                    metno_info()
                }
            }
        }

        VerticalScrollDecorator {}

        Column {
            id: col
            spacing: isPortrait ? Theme.paddingLarge : mainapp.smallScreen ? Theme.paddingSmall : Theme.paddingMedium
            width: parent.width
            PageHeaderExtended {
            id: header
            title: isPortrait ? "Voorspelling per uur" : "Voorspelling per uur lokaal"
                subTitle: "www.met.no"
                subTitleOpacity: 0.6
                subTitleBottomMargin: isPortrait ? Theme.paddingSmall : 0
            }
            Row {
                width: parent.width - Theme.paddingLarge
                x: Theme.paddingLarge
                y: Theme.paddingMedium
                Label {
                    width: parent.width / 7
                    font.pixelSize: mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: qsTr("")
                    color: Theme.highlightColor
                }
                Label {
                    width: parent.width / 6
                    font.pixelSize: mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: qsTr("Tijd")
                    color: Theme.highlightColor
                }
                Label {
                    width: parent.width / 6
                    font.pixelSize: mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: qsTr("Temp")
                    color: Theme.highlightColor
                }
                Label {
                    width: parent.width / 4.5
                    font.pixelSize: mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: qsTr("Wind m/s")
                    color: Theme.highlightColor
                }
                Label {
                    width: parent.width / 4
                    font.pixelSize: mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: qsTr("Windrichting")
                    color: Theme.highlightColor
                }
            }
            Repeater {
                model: dataModel
                delegate: ListItem {
                    menu: contextMenu
                    Row {
                        width: parent.width - Theme.paddingLarge
                        x: Theme.paddingMedium
                        y: Theme.paddingMedium
                        Image {
                            id: weatherimage
                            source: "/usr/share/harbour-welkweer/qml/images/icons-metno/"
                                    + symbol_code + ".png"
                            height: mainapp.mediumScreen ? 110 : mainapp.largeScreen ? 125 : 40
                            width: mainapp.mediumScreen ? 110 : mainapp.largeScreen ? 125 : 40
                            anchors.verticalCenter: windDirection.verticalCenter
                        }
                        Rectangle {
                            // some whitespace
                            width: (parent.width / 7) - weatherimage.width
                            height: 1
                            opacity: 0
                            id: itemWhitespace
                        }
                        Rectangle {
                            // some whitespace reservered for time and date
                            width: parent.width / 6
                            height: 1
                            opacity: 0
                        }
                        Item {
                            anchors.verticalCenter: weatherimage.top
                            width: parent.width / 6
                            id: hourtxt
                            anchors.left: itemWhitespace.right
                            Label {
                                id: timeLabel
                                font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeExtraSmall
                                text: getDayMonthOrTime(model.time, "time")
                            }
                            Label {
                                anchors.top: timeLabel.bottom
                                text: getDayMonthOrTime(model.time, "date")
                                font.pixelSize: Theme.fontSizeExtraSmall
                                color: Theme.secondaryColor
                            }
                        }
                        Label {
                            width: parent.width / 5
                            font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeExtraSmall
                            text: model.air_temperature.toFixed(1) + '°C'
                        }
                        Label {
                            width: parent.width / 4
                            font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                            text: model.wind_speed.toFixed(
                                      1) + " (" + msToBeaufort(
                                      model.wind_speed) + " BF)"
                        }
                        Label {
                            id: windDirection
                            width: parent.width / 4
                            font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                            text: degToCompass(model.wind_from_direction)
                        }
                        Component {
                            id: contextMenu
                            ContextMenu {
                                MenuItem {
                                    text: "kans op  🌧  is "
                                          + model.probability_of_precipitation.toString(
                                              ).replace(".", ",") + " %"
                                }
                                MenuItem {
                                    text: "🌧 min: " + model.precipitation_amount_min.toString(
                                              ) + " mm   🌧 max: "
                                          + model.precipitation_amount_max.toString(
                                              ) + " mm"
                                }
                                MenuItem {
                                    text: "kans op 🗲is " + model.probability_of_thunder.toString(
                                              ).replace(".", ",") + " %"
                                }
                            }
                        }
                    }
                }
            }
            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Data api.met.no: " + measureMoment
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeTiny
                visible: !waitIndicator.running
            }
        }
    }
}
