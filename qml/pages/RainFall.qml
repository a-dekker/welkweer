import QtQuick 2.0
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.3

Page {
    id: rainfall
    property bool largeScreen: Screen.sizeCategory === Screen.Large
                               || Screen.sizeCategory === Screen.ExtraLarge
    allowedOrientations: Orientation.Portrait | Orientation.Landscape
                         | Orientation.LandscapeInverted

    property string headerTxt: "loading"
    property string placeholderTxt: "Komende 2 uur geen regen verwacht"
    property bool rain: false

    Python {
        id: python

        Component.onCompleted: {
            // Add the directory of this .qml file to the search path
            addImportPath(Qt.resolvedUrl('.'))
            // Import the main module
            importModule('call_buienradar', function () {
                console.log('call_buienradar module is now imported')
                call("call_buienradar.get_forecast_rain", [mainapp.latitude, mainapp.longitude],
                function (result) {
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
                            value: rain_mm,
                            legend: time_rain,
                            color: "lightblue"
                        })
                    }
                    if ( ! model.get(0).legend) {
                        placeholderTxt = "Geen bruikbare data"
                        headerTxt = "fout"
                    }
                    headerTxt = model.get(0).legend + "-" + model.get(i - 1).legend + "(100=zware regen)"
                })
            })
        }
        onError: {
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback)
            placeholderTxt = "Geen bruikbare data"
            headerTxt = "fout"
        }
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: headerTxt === "loading"
        size: BusyIndicatorSize.Large
    }

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        anchors.verticalCenter: parent.verticalCenter
        PageHeader {
            visible: rain || headerTxt === "fout" || headerTxt === "loading"
            title: headerTxt
        }
        ViewPlaceholder {
            id: placeholder
            enabled: !rain
            text: placeholderTxt
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
                anchors.leftMargin: 50
                anchors.rightMargin: 50 + legend.width
                anchors.topMargin: 10
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
