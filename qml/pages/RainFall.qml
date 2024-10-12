import QtQuick 2.5
import Sailfish.Silica 1.0
import "../qchart/"
import "../qchart/QChart.js" as Charts
import "../common"

Page {
    id: rainfall

    property string headerTxt: mainapp.locPlace
    property string subTxt: mainapp.locMeetStation
    property string placeholderTxt: ""
    property bool rain: false

    function getRaindata2hrs() {
        var rain_intensity = new Array(0)
        var rain_time = new Array(0)
        var req = new XMLHttpRequest()
        req.open("GET", "https://gadgets.buienradar.nl//data/raintext?lat="
                 + mainapp.latitude + "&lon=" + mainapp.longitude)

        req.onreadystatechange = function () {
            if (req.readyState === XMLHttpRequest.DONE) {
                if (req.status && req.status === 200) {
                    // console.log(req.responseText)
                    rain = false
                    var raindata = req.responseText.split('\n')
                    var data
                    for (var i = 0; i < raindata.length - 1; i++) {
                        data = raindata[i].split('|')
                        // should be following formula, but we make a scale 0-100 (no rain - heavy rain (=255))
                        // var mm_rain_hour = Math.pow(10,((rain_mm -109)/32)).toFixed(1)
                        var rain_mm = Math.round(
                                    (1 / 255) * data[0] * 100)
                        var time_rain = data[1]
                        if (rain_mm > 0) {
                            rain = true
                        }
                        rain_intensity.push(rain_mm)
                        rain_time.push(" " + time_rain)  // leading space added to create space in legend
                    }
                    if (rain_time === "") {
                        placeholderTxt = "Geen bruikbare data"
                        headerTxt = "fout"
                    }
                    if (rain) {
                        headerTxt = "Neerslag intensiteit"
                        subTxt = "(leeg=droog vol=zware neerslag)"
                    }
                    placeholderTxt = " "
                }
                tempChart.chartData.datasets[0].data = rain_intensity
                tempChart.chartData.datasets[0].fillColor.push("#25AAE1")
                tempChart.chartData.labels = rain_time
                tempChart.requestPaint()
            }
        }
        req.send()
    }

    Item {
        id: busy
        anchors.fill: parent
        Label {
            id: busyLabel
            anchors.bottom: loadingRainGraph.top
            color: Theme.highlightColor
            font.pixelSize: Theme.fontSizeLarge
            height: Theme.itemSizeLarge
            horizontalAlignment: Text.AlignHCenter
            text: "Wachten op neerslag info"
            verticalAlignment: Text.AlignVCenter
            visible: loadingRainGraph.running
            width: parent.width
        }
        BusyIndicator {
            id: loadingRainGraph
            anchors.centerIn: parent
            running: placeholderTxt === ""
            size: BusyIndicatorSize.Large
        }
    }

    SilicaFlickable {
        anchors.fill: parent

        PullDownMenu {
            id: menu
            MenuItem {
                text: qsTr("Vernieuwen")
                onClicked: {
                    getRaindata2hrs()
                }
            }
            MenuLabel {
                text: mainapp.locMeetStation
                visible: subTxt !== mainapp.locMeetStation
            }
        }

        PageHeader {
            id: pageHeaderEx
            title: headerTxt
            description: subTxt
        }

        ViewPlaceholder {
            id: placeholder
            enabled: !loadingRainGraph.running
            text: (!rain && headerTxt
                   !== "fout") ? "Komende 2 uur geen neerslag verwacht" : placeholderTxt
        }
        Item {
            visible: rain
            anchors {
                top: pageHeaderEx.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            QChart {
                id: tempChart
                width: parent.width - 2 * Theme.horizontalPageMargin
                height: isPortrait ? parent.height - 8 * Theme.horizontalPageMargin : parent.height
                                     - 2 * Theme.horizontalPageMargin
                anchors.centerIn: parent
                property bool scaleOnly: false

                chartAnimated: false
                chartType: Charts.ChartType.BAR

                Component.onCompleted: {
                    chartData = {
                        "labels": [],
                        "datasets": [{
                                "data": [],
                                "fillColor": []
                            }]
                    }
                    chartOptions = ({
                                        "scaleStartValue": 0,
                                        "scaleFontSize": Theme.fontSizeExtraSmall * .8,
                                        "scaleFontFamily": Theme.fontFamily,
                                        "scaleFontColor": Theme.secondaryColor,
                                        "scaleLineColor": Theme.secondaryColor,
                                        "scaleSteps": 100,
                                        "scaleStepWidth": 1,
                                        "scaleOverride": true,
                                        "scaleShowLabels": false,
                                        "scaleGridLineWidth": .2,
                                        "scaleOverlay": scaleOnly
                                    })
                    getRaindata2hrs()
                }
            }
        }
    }
}
