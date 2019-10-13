import QtQuick 2.2
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5
import "../common"

Page {
    id: rainfall

    property string headerTxt: mainapp.locPlace
    property string subTxt: mainapp.locMeetStation
    property string placeholderTxt: ""
    property bool rain: false

    Component.onCompleted: {
        callBuienradar()
    }

    Python {
        id: python

        Component.onCompleted: {
            // Add the directory of this .qml file to the search path
            addImportPath(Qt.resolvedUrl('.'))
            // Import the main module
            importModule('call_buienradar', function () {
                console.log('call_buienradar module is now imported')
            })
        }
        onError: {
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback)
            placeholderTxt = "Geen bruikbare data"
            headerTxt = "fout"
        }
    }

    function callBuienradar() {
        python.call("call_buienradar.get_forecast_rain",
        [mainapp.latitude, mainapp.longitude], function (result) {
                 rain = false
                 var raindata = result.split('\n')
                 var data
                 for (var i = 0; i < raindata.length - 1; i++) {
                     data = raindata[i].split('|')
                     // should be following formula, but we make a scale 0-100 (no rain - heavy rain (=255))
                     // var mm_rain_hour = Math.pow(10,((rain_mm -109)/32)).toFixed(1)
                     var rain_mm = Math.round((1 / 255) * data[0] * 100)
                     var time_rain = data[1]
                     if (rain_mm > 0) {
                         rain = true
                     }
                     model.append({
                                      "value": rain_mm,
                                      "legend": time_rain,
                                      "color": "#25AAE1" // blue
                                  })
                 }
                 if (!model.get(0).legend) {
                     placeholderTxt = "Geen bruikbare data"
                     headerTxt = "fout"
                 }
                 if (rain) {
                     headerTxt = model.get(0).legend + "-" + model.get(
                                 i - 1).legend
                     subTxt = "(0=droog 100=zware regen)"
                 }
                 placeholderTxt = " "
             })
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
            text: "Wachten op regen info"
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
        contentWidth: parent.width
        anchors.verticalCenter: parent.verticalCenter

        PullDownMenu {
            id: menu
            MenuItem {
                text: qsTr("Vernieuwen")
                onClicked: {
                    model.clear()
                    callBuienradar()
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
            text: (!rain
                   && headerTxt !== "fout") ? "Komende 2 uur geen regen verwacht" : placeholderTxt
        }
        Item {
            visible: rain
            id: root
            implicitWidth: parent.width
            implicitHeight: parent.height
            property color backgroundColor: "transparent"
            property color gridColor: Theme.primaryColor
            property color legendColor: "lightgray"
            property bool legendEnabled: false
            property int gridSpacing: 10
            property double maxValue: 110
            property int dataMargin: 2
            property ListModel model: ListModel {
                id: model
            }
            Rectangle {
                id: grid
                anchors.left: root.left
                anchors.right: root.right
                anchors.top: root.top
                anchors.bottom: root.bottom
                anchors.leftMargin: mainapp.mediumScreen ? 70 : 50
                anchors.rightMargin: Theme.paddingLarge
                anchors.topMargin: 30
                anchors.bottomMargin: 10
                color: root.backgroundColor
                Repeater {
                    model: root.maxValue / root.gridSpacing
                    Rectangle {
                        width: grid.width
                        height: 3
                        color: root.gridColor
                        opacity: 0.5
                        y: grid.height - index * grid.height / (root.maxValue / root.gridSpacing)
                    }
                }
                Repeater {
                    model: root.maxValue / root.gridSpacing
                    y: grid.height * grid.height
                       / (root.maxValue / root.gridSpacing) // should be as y: above...

                    Text {
                        text: index * root.gridSpacing
                        y: grid.height - index * grid.height
                           / (root.maxValue / root.gridSpacing) - height / 2
                        anchors.right: grid.left
                        color: Theme.secondaryHighlightColor
                        font.pixelSize: Theme.fontSizeSmall
                    }
                }
                Repeater {
                    id: dataRep
                    model: root.model
                    Rectangle {
                        height: model.value * grid.height / root.maxValue
                        width: grid.width / dataRep.count - 2 * root.dataMargin
                        color: model.color
                        x: index * (width + root.dataMargin * 2) + root.dataMargin
                        y: grid.height - height
                        border.width: 3
                    }
                }
            }
            Rectangle {
                id: legend
                width: root.legendEnabled ? root.width * 0.293 : 0
                color: root.legendColor
                anchors.right: root.right
                anchors.top: root.top
                anchors.topMargin: 10
                height: grid.height
                visible: root.legendEnabled
                Column {
                    anchors.centerIn: legend
                    anchors.left: legend.left
                    Repeater {
                        id: legendRep
                        model: root.model

                        Row {
                            Rectangle {
                                width: height
                                height: legendText.height
                                border.width: 3
                                color: model.color
                            }
                            Text {
                                id: legendText
                                text: model.legend
                            }
                        }
                    }
                }
            }
        }
    }
}
