import QtQuick 2.5
import Sailfish.Silica 1.0

import "../qchart/"
import "../qchart/QChart.js" as Charts
import "../common"

Page {
    id: temperatureChart

    property variant dataPortrait: []
    property variant labelPortrait: []
    property variant dataLandscape: []
    property variant labelLandscape: []

    onOrientationChanged: {
        if (isPortrait) {
            tempChart.chartData.datasets[0].data = dataLandscape
            tempChart.chartData.labels = labelLandscape
            tempChart.requestPaint()
        }
        if (isLandscape) {
            tempChart.chartData.datasets[0].data = dataPortrait
            tempChart.chartData.labels = labelPortrait
            tempChart.requestPaint()
        }
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
            return ("0" + hour).slice(-2)
        }
    }

    function metno_info() {
        var dp = new Array(0)
        var lp = new Array(0)
        var dl = new Array(0)
        var ll = new Array(0)
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
                                for (var timeserie = 0; timeserie < 25; timeserie++) {
                                    dl.push(objectArray[key]["timeseries"][timeserie]["data"]["instant"]["details"]["air_temperature"])
                                    ll.push(getDayMonthOrTime(
                                                objectArray[key]["timeseries"][timeserie]["time"],
                                                "time"))
                                    if (timeserie < 13) {
                                        dp.push(objectArray[key]["timeseries"][timeserie]["data"]["instant"]["details"]["air_temperature"])
                                        lp.push(getDayMonthOrTime(
                                                    objectArray[key]["timeseries"][timeserie]["time"],
                                                    "time"))
                                    }
                                }
                            }
                        }
                    }
                }
                dataPortrait = dp
                labelPortrait = lp
                dataLandscape = dl
                labelLandscape = ll
                if (isPortrait) {
                    tempChart.chartData.datasets[0].data = dataPortrait
                    tempChart.chartData.labels = labelPortrait
                } else {
                    tempChart.chartData.datasets[0].data = dataLandscape
                    tempChart.chartData.labels = labelLandscape
                }
                tempChart.requestPaint()
            }
        }
        req.send()
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            MenuItem {
                text: qsTr("Vernieuwen")
                onClicked: {
                    metno_info()
                }
            }
        }

            PageHeaderExtended {
            id: header
            title: "Temperatuur"
                subTitle: isPortrait ? qsTr("+12 uur") : qsTr(
                                    "+24 uur")
                subTitleOpacity: 0.7
                subTitleBottomMargin: isPortrait ? Theme.paddingSmall : 0
                Label {
                    text: "www.met.no"
                    color: Theme.highlightColor
                    font.family: 'monospace'
                    font.pixelSize: Theme.fontSizeExtraSmall
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.horizontalPageMargin
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

        Item {
            anchors {
                top: header.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            QChart {
                id: tempChart
                width: parent.width - 2 * Theme.horizontalPageMargin
                height: isPortrait ? width : parent.height - 2 * Theme.horizontalPageMargin
                anchors.centerIn: parent
                property bool scaleOnly: false
                property bool asOverview: false

                chartAnimated: false
                chartType: Charts.ChartType.LINE

                Component.onCompleted: {
                    chartData = {
                        "labels": [],
                        "datasets": [{
                                "data": [],
                                "strokeColor": Theme.highlightColor
                            }]
                    }
                    chartOptions = ({
                                        "scaleFontSize": Theme.fontSizeExtraSmall
                                                         * (asOverview ? (4 / 5) : 1),
                                        "scaleFontFamily": Theme.fontFamily,
                                        "scaleFontColor": Theme.secondaryColor,
                                        "scaleLineColor": Theme.secondaryColor,
                                        "scaleOverlay": scaleOnly,
                                        "bezierCurve": false,
                                        "datasetStrokeWidth": 5,
                                        "datasetFill": false,
                                        "pointDot": false
                                    })
                    metno_info()
                }
            }
        }
    }
}
