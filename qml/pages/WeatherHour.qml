import QtQuick 2.5
import Sailfish.Silica 1.0

// https://api.met.no/weatherapi/locationforecast/2.0/complete?lat=51.17416597&lon=6.870996516&altitude=44
Page {
    id: page

    property var measureMoment
    property var firstMeasureHour

    ListModel {
        id: dataModel
    }

    function degToCompass(num) {
        var val = Math.floor((num / 22.5) + 0.5)
        var arr = ["↓ N", "↙ NNO", "↙ NO", "↙ ONO", "← O", "↖ OZO", "↖ ZO", "↖ ZZO", "↑ Z", "↗ ZZW", "↗ ZW", "↗ WZW", "→ W", "↘ WNW", "↘ NW", "↘ NNW"]
        return arr[(val % 16)]
    }

    function addHoursToDateNow(datum, n) {
        const d = new Date(datum)
        d.setTime(d.getTime() + n * 3600000)
        const hour = d.getHours()
        return ("0" + hour).slice(-2) + ":00"
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
                                var first_hour_timestamp
                                var update_timestamp
                                first_hour_timestamp = objectArray[key]["timeseries"][0]["time"]
                                update_timestamp = objectArray[key]["meta"]["updated_at"]
                                for (var timeserie = 0; timeserie < 15; timeserie++) {
                                    dataModel.append(
                                                objectArray[key]["timeseries"][timeserie]["data"]["instant"]["details"])
                                }
                            }
                        }
                    }
                }
                var measureDateTime = new Date(update_timestamp)
                var firstMeasureDateTime = new Date(first_hour_timestamp)
                measureMoment = measureDateTime
                firstMeasureHour = firstMeasureDateTime
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

        VerticalScrollDecorator {}

        Column {
            id: col
            spacing: isPortrait ? Theme.paddingLarge : mainapp.smallScreen ? Theme.paddingSmall : Theme.paddingMedium
            width: parent.width
            PageHeader {
                title: isPortrait ? "Voorspelling per uur" : "Voorspelling per uur lokaal"
            }
            Row {
                id: koppenGrid
                width: parent.width - Theme.paddingLarge
                x: Theme.paddingLarge
                y: Theme.paddingMedium
                Label {
                    width: parent.width / 5
                    font.pixelSize: mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: qsTr("Tijd")
                    color: Theme.highlightColor
                }
                Label {
                    width: parent.width / 4
                    font.pixelSize: mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: qsTr("Temp")
                    color: Theme.highlightColor
                }
                Label {
                    width: parent.width / 4
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
                Row {
                    id: row2
                    width: parent.width - Theme.paddingLarge
                    x: Theme.paddingLarge
                    y: Theme.paddingMedium
                    Label {
                        width: parent.width / 5
                        font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeExtraSmall
                        text: addHoursToDateNow(firstMeasureHour, index)
                        color: Theme.secondaryColor
                    }
                    Label {
                        width: parent.width / 4
                        font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeExtraSmall
                        text: model.air_temperature.toFixed(1) + '°C'
                    }
                    Label {
                        width: parent.width / 4
                        font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                        text: model.wind_speed.toFixed(1) + " (" + msToBeaufort(
                                  model.wind_speed) + " BF)"
                    }
                    Label {
                        width: parent.width / 4
                        font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                        text: degToCompass(model.wind_from_direction)
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
