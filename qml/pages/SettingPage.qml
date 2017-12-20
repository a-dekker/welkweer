import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.welkweer.Launcher 1.0
import harbour.welkweer.Settings 1.0
import io.thp.pyotherside 1.5
import org.nemomobile.notifications 1.0

Page {
    id: settingsPage
    property string regio
    property string stationcode
    property var dataModel: ListModel {
    }
    property int itemIndex: 0
    property bool isRunning: waitIndicator.running

    Notification {
        id: notification
        appName: "welkweer"
    }

    function banner(category, message) {
        notification.close()
        notification.previewBody = message
        notification.previewSummary = "welkweer"
        notification.publish()
    }

    Component.onCompleted: {
        // without an update we have the previous time
        var networkState = bar.launch(
                    "cat /run/state/providers/connman/Internet/NetworkState")
        if (networkState !== "connected") {
            banner("INFO", qsTr("Geen internet connectie!"))
            pageStack.pop()
        }
    }

    objectName: "SettingPage"

    BusyIndicator {
        id: waitIndicator
        anchors.centerIn: parent
        running: dataModel.count === 0
        size: BusyIndicatorSize.Large
    }

    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        App {
            id: bar
        }
        MySettings {
            id: myset
        }

        clip: true

        ScrollDecorator {
        }

        Column {
            id: col
            spacing: Theme.paddingLarge
            width: parent.width
            PageHeader {
                title: qsTr("Instellingen")
            }

            ComboBox {
                label: "Locatie"
                visible: !isRunning
                Python {
                    id: py
                    Component.onCompleted: {
                        // Add the directory of this .qml file to the search path
                        addImportPath(Qt.resolvedUrl('.'))
                        // Import the main module and load the data
                        importModule('call_buienradar', function () {
                            py.call('call_buienradar.get_stations_weerinfo',
                                    [], function (result) {
                                        // Load the received data into the list model
                                        for (var i = 0; i < result.length; i++) {
                                            dataModel.append(result[i])
                                            if (dataModel.get(
                                                        i).stationcode === myset.value(
                                                        "stationcode")) {
                                                itemIndex = i
                                            }
                                        }
                                    })
                        })
                    }
                    onError: {
                        // when an exception is raised, this error handler will be called
                        console.log('python error: ' + traceback)
                    }
                }
                menu: ContextMenu {
                    Repeater {
                        model: dataModel
                        MenuItem {
                            text: model.regio + (model.meetstation === model.regio ? "" : " (" + model.meetstation + ")")
                        }
                    }
                }
                currentIndex: itemIndex

                onCurrentIndexChanged: {
                    if (myset.value("stationcode") !== dataModel.get(
                                currentIndex).stationcode) {
                        mainapp.settingsChanged = true
                        myset.setValue("stationcode",
                                       dataModel.get(currentIndex).stationcode)
                    }
                }
            }
            ComboBox {
                id: zoomlevel
                visible: !isRunning
                width: col.width
                label: qsTr("Zoomniveau lokaal")
                currentIndex: {
                    switch (myset.value("zoomlevel")) {
                    case "6":
                        0
                        break
                    case "8":
                        1
                        break
                    case "11":
                        2
                        break
                    case "13":
                        3
                        break
                    default:
                        1
                        break
                    }
                }
                menu: ContextMenu {
                    MenuItem {
                        text: qsTr("Land") // zoom =  6
                    }
                    MenuItem {
                        text: qsTr("Provincie") // zoom =  8
                    }
                    MenuItem {
                        text: qsTr("Regio") // zoom = 11
                    }
                    MenuItem {
                        text: qsTr("Stad/dorp") // zoom = 13
                    }
                }
                onCurrentIndexChanged: {
                    switch (zoomlevel.currentIndex) {
                    case 0:
                        if (myset.value("zoomlevel") !== "6") {
                            myset.setValue("zoomlevel", "6")
                            mainapp.settingsChanged = true
                        }
                        break
                    case 1:
                        if (myset.value("zoomlevel") !== "8") {
                            myset.setValue("zoomlevel", "8")
                            mainapp.settingsChanged = true
                        }
                        break
                    case 2:
                        if (myset.value("zoomlevel") !== "11") {
                            myset.setValue("zoomlevel", "11")
                            mainapp.settingsChanged = true
                        }
                        break
                    case 3:
                        if (myset.value("zoomlevel") !== "13") {
                            myset.setValue("zoomlevel", "13")
                            mainapp.settingsChanged = true
                        }
                        break
                    default:
                        if (myset.value("zoomlevel") !== "8") {
                            myset.setValue("zoomlevel", "8")
                            mainapp.settingsChanged = true
                        }
                        break
                    }
                }
            }
        }
    }
}
