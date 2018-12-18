import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.welkweer.Launcher 1.0
import harbour.welkweer.Settings 1.0
import Nemo.Notifications 1.0
import io.thp.pyotherside 1.5
import "../common"

Page {
    id: mainPage

    property string weerStation: myset.value("stationcode", "6240")
    property string locHumidity: "Geen data"
    property string locDawn: "Geen data"
    property string locDusk: "-"
    property string locText: "Geen data"
    property string lastUpd: "Laatste update: geen data"
    property string maanStand: "Geen data"
    property string locDewPointTemp: "-"
    property string locDewPointName: "-"

    // property string maanStandSymbool: "-"
    Component.onCompleted: {
        if (checkNetworkConnection() === true) {
            getMoonPhase()
            loadWeather()
        }
    }

    onStatusChanged: {
        if (status === PageStatus.Activating) {
            if (mainapp.settingsChanged) {
                // settings changed, reload
                if (checkNetworkConnection() === true) {
                    weerStation = myset.value("stationcode", "6240")
                    locText = "Geen data"
                    loadWeather()
                }
                mainapp.settingsChanged = false
            }
        }
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
        }
    }
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

    function checkNetworkConnection() {
        var networkState = bar.launch(
                    "cat /run/state/providers/connman/Internet/NetworkState")
        if (networkState !== "connected") {
            banner("INFO", qsTr("Geen internet connectie!"))
            locText = "Geen internet connectie"
            return false
        }
        return true
    }

    function loadWeather() {
        python.call("call_buienradar.get_lokaal_weerinfo", [weerStation],
                    function (result) {
                        mainapp.locPlace = result[0]
                        mainapp.lastUpdCover = result[1]
                        lastUpd = "Laatste update buienradar.NL: " + result[1]
                        mainapp.locTemp = result[2] + '°C'
                        locHumidity = result[3] + '%'
                        mainapp.locWind = result[4] + ' ' + result[6] + 'm/s (' + result[5] + ' BF)'
                        locDawn = result[8]
                        locDusk = result[9] + ' (' + result[15] + ' uur)'
                        locText = '"' + result[10] + '"'
                        mainapp.iconLocation = "/usr/share/harbour-welkweer/qml/images/icons/"
                                + result[11] + ".png"
                        mainapp.latitude = result[12]
                        mainapp.longitude = result[13]
                        mainapp.locMeetStation = result[14]
                        locDewPointTemp = result[16] + '°C'
                        locDewPointName = result[17]
                    })
    }

    function getMoonPhase() {
        python.call("call_buienradar.get_moon_phase", [], function (result) {
            maanStand = result
        })
    }

    Component.onDestruction: notification.close()

    BusyIndicator {
        anchors.centerIn: parent
        running: locText === "Geen data"
        size: BusyIndicatorSize.Large
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Over")
                onClicked: pageStack.push(Qt.resolvedUrl("About.qml"))
            }
            MenuItem {
                text: qsTr("Instellingen")
                onClicked: {
                    if (checkNetworkConnection() === true) {
                        pageStack.push(Qt.resolvedUrl("SettingPage.qml"))
                    }
                }
            }
            MenuItem {
                text: qsTr("Vernieuwen")
                onClicked: {
                    if (checkNetworkConnection() === true) {
                        weerStation = myset.value("stationcode", "6240")
                        locText = "Geen data"
                        loadWeather()
                    }
                }
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height
        App {
            id: bar
        }

        MySettings {
            id: myset
        }

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column

            width: mainPage.width
            spacing: mainapp.largeScreen ? 50 : (mainapp.mediumScreen ? 20 : 7)

            PageHeaderExtended {
                title: mainapp.locPlace === "" ? qsTr("WelkWeer") : mainapp.locPlace
                subTitle: mainapp.locMeetStation
                subTitleOpacity: 0.5
                subTitleBottomMargin: isPortrait ? Theme.paddingSmall : 0
                visible: !(isLandscape && mainapp.smallScreen)
            }

            Row {
                Label {
                    text: " "
                }
                visible: isLandscape && mainapp.smallScreen
            }

            Row {
                spacing: Theme.paddingSmall
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    text: "Neerslag NL"
                    width: isPortrait ? (column.width / 2) * 0.95 : (column.width / 4) * 0.95
                    onClicked: {
                        if (checkNetworkConnection() === true) {
                            pageStack.push("CurrentWeather.qml")
                        }
                    }
                }
                Button {
                    text: "5 daags NL"
                    width: isPortrait ? (column.width / 2) * 0.95 : (column.width / 4) * 0.95
                    onClicked: {
                        if (checkNetworkConnection() === true) {
                            pageStack.push("Forecast.qml")
                        }
                    }
                }
                Button {
                    text: "Buien Europa"
                    width: (column.width / 4) * 0.95
                    onClicked: {
                        if (checkNetworkConnection() === true) {
                            pageStack.push("WeatherEurope.qml")
                        }
                    }
                    visible: isLandscape
                }
                Button {
                    text: "Lokaal → 3uur"
                    width: (column.width / 4) * 0.95
                    onClicked: {
                        if (checkNetworkConnection() === true) {
                            pageStack.push("Weather3hr.qml")
                        }
                    }
                    visible: isLandscape
                }
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingSmall
                Button {
                    text: "Lokaal → 3uur"
                    width: (column.width / 2) * 0.95
                    onClicked: {
                        if (checkNetworkConnection() === true) {
                            pageStack.push("Weather3hr.qml")
                        }
                    }
                    visible: isPortrait
                }
                Button {
                    text: "Morgen NL"
                    width: isPortrait ? (column.width / 2) * 0.95 : (column.width / 4) * 0.95
                    onClicked: {
                        if (checkNetworkConnection() === true) {
                            pageStack.push("WeatherTomorrow.qml")
                        }
                    }
                }
                Button {
                    text: "Neerslag → 2uur"
                    width: (column.width / 4) * 0.95
                    onClicked: {
                        if (checkNetworkConnection() === true) {
                            pageStack.push("RainFall.qml")
                        }
                    }
                    visible: isLandscape
                }
                Button {
                    text: "Windkracht NL"
                    width: (column.width / 4) * 0.95
                    onClicked: {
                        if (checkNetworkConnection() === true) {
                            pageStack.push("Wind.qml")
                        }
                    }
                    visible: isLandscape
                }
                Button {
                    text: "Temperatuur NL"
                    width: (column.width / 4) * 0.95
                    onClicked: {
                        if (checkNetworkConnection() === true) {
                            pageStack.push("Temperature.qml")
                        }
                    }
                    visible: isLandscape
                }
            }
            Row {
                visible: isPortrait
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingSmall
                Button {
                    text: "Windkracht NL"
                    width: (column.width / 2) * 0.95
                    onClicked: {
                        if (checkNetworkConnection() === true) {
                            pageStack.push("Wind.qml")
                        }
                    }
                }
                Button {
                    text: "Temperatuur NL"
                    width: (column.width / 2) * 0.95
                    onClicked: {
                        if (checkNetworkConnection() === true) {
                            pageStack.push("Temperature.qml")
                        }
                    }
                }
            }
            Row {
                visible: isPortrait
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingSmall
                Button {
                    text: "Buien Europa"
                    width: (column.width / 2) * 0.95
                    onClicked: {
                        if (checkNetworkConnection() === true) {
                            pageStack.push("WeatherEurope.qml")
                        }
                    }
                }
                Button {
                    text: "Neerslag → 2uur"
                    width: (column.width / 2) * 0.95
                    onClicked: {
                        if (checkNetworkConnection() === true) {
                            pageStack.push("RainFall.qml")
                        }
                    }
                }
            }
            Row {
                id: listRow
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    width: isPortrait ? parent.width * 0.5 : parent.width * 0.5 / 1.5
                    text: "Temperatuur"
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: isPortrait ? parent.width * 0.5 : parent.width * 0.5 / 1.5
                    text: mainapp.locTemp
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    width: isPortrait ? parent.width * 0.5 : parent.width * 0.5 / 1.5
                    text: "Wind"
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: isPortrait ? parent.width * 0.5 : parent.width * 0.5 / 1.5
                    text: mainapp.locWind
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    width: isPortrait ? parent.width * 0.5 : parent.width * 0.5 / 1.5
                    text: "Luchtvochtigheid"
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: isPortrait ? parent.width * 0.5 : parent.width * 0.5 / 1.5
                    text: locHumidity + " (" + locDewPointName + " " + locDewPointTemp + ")"
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    // wrapMode: Text.Wrap
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    width: isPortrait ? parent.width * 0.5 : parent.width * 0.5 / 1.5
                    text: "Periode licht"
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: isPortrait ? parent.width * 0.5 : parent.width * 0.5 / 1.5
                    text: locDawn + "-" + locDusk
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }
                IconButton {
                    visible: isLandscape
                    id: weatherIconLandscape
                    icon.source: mainapp.iconLocation
                    highlighted: true
                    icon.height: screen.width <= 540 ? 128 : 300
                    icon.width: icon.height
                    height: 1 // to make it small not to cause space in left column
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    width: isPortrait ? parent.width * 0.5 : parent.width * 0.5 / 1.5
                    text: "Maanstand"
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }
                Label {
                    width: isPortrait ? parent.width * 0.5 : parent.width * 0.5 / 1.5
                    text: maanStand
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }
            }
            Item {
                visible: isPortrait
                height: weatherIcon.height + Theme.paddingLarge
                anchors.horizontalCenter: parent.horizontalCenter
                width: weatherIcon.width + Theme.paddingLarge * 4
                Rectangle {
                    anchors.fill: parent
                    opacity: 0
                    radius: 8.0
                }
                IconButton {
                    id: weatherIcon
                    anchors.horizontalCenter: parent.horizontalCenter
                    icon.source: mainapp.iconLocation
                    highlighted: true
                    icon.height: screen.width <= 540 ? 128 : 300
                    icon.width: icon.height
                    width: icon.width
                    height: icon.height * 1.3
                }
            }
            ScrollLabel {
                id: localText
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: isPortrait ? 0 : (parent.width
                                                                  - localText.width) / 4
                text: locText === '"undefined"' ? '"fout"' : isLandscape
                                                  && mainapp.smallScreen ? mainapp.locMeetStation + ": " + locText : locText
                width: parent.width
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeSmall
            }
            Label {
                id: lastUpddate
                anchors.horizontalCenter: parent.horizontalCenter
                text: lastUpd
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeTiny
            }
        }
    }
}
