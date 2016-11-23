import QtQuick 2.0
import Sailfish.Silica 1.0
import harbour.welkweer.Launcher 1.0
import harbour.welkweer.Settings 1.0
import org.nemomobile.notifications 1.0
import io.thp.pyotherside 1.3
import "../common"

Page {
    id: mainPage
    allowedOrientations: Orientation.Portrait | Orientation.Landscape
                         | Orientation.LandscapeInverted
    property bool largeScreen: Screen.sizeCategory === Screen.Large
                               || Screen.sizeCategory === Screen.ExtraLarge

    property string weerStation: myset.value("stationcode", "6240")
    property string locHumidity: "Geen data"
    property string locDawn: "Geen data"
    property string locDusk: "Geen data"
    property string locText: "Geen data"
    property string lastUpd: "Laatste update: geen data"

    Component.onCompleted: {
        if (checkNetworkConnection() == true) {
            loadWeather()
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
            return false
        } else {
            return true
        }
    }

    function rainGraph() {
        if (checkNetworkConnection() == true) {
            pageStack.push("RainFall.qml")
        }
    }

    function loadWeather() {
        python.call("call_buienradar.get_lokaal_weerinfo", [weerStation],
                    function (result) {
                        mainapp.locPlace = result[0]
                        lastUpd = "Laatste update buienradar.NL: " + result[1]
                        mainapp.locTemp = result[2] + '°C'
                        locHumidity = result[3] + '%'
                        mainapp.locWind = result[4] + ' ' + result[6] + 'm/s (' + result[5] + ' BF)'
                        locDawn = result[8]
                        locDusk = result[9] + ' (dagduur ' + result[15] + ')'
                        locText = '"' + result[10] + '"'
                        mainapp.iconLocation = "/usr/share/harbour-welkweer/qml/images/icons/"
                                + result[11] + ".png"
                        mainapp.latitude = result[12]
                        mainapp.longitude = result[13]
                        mainapp.locMeetStation = result[14]
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
                onClicked: pageStack.push(Qt.resolvedUrl("SettingPage.qml"))
            }
            MenuItem {
                text: qsTr("Vernieuwen")
                onClicked: {
                    if (checkNetworkConnection() == true) {
                        weerStation = myset.value("stationcode", "6240")
                        locText = "Geen data"
                        loadWeather()
                    }
                }
            }
        }
        PushUpMenu {
            MenuItem {
                text: qsTr("Beschrijving weer NL")
                onClicked: pageStack.push("WeatherText.qml")
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
            spacing: largeScreen ? 50 : 7

            PageHeaderExtended {
                title: mainapp.locPlace === "" ? qsTr("WelkWeer") : mainapp.locPlace
                subTitle: mainapp.locMeetStation
                subTitleOpacity: 0.5
                subTitleBottomMargin: isPortrait ? Theme.paddingSmall : 0
            }

            Row {
                spacing: Theme.paddingSmall
                anchors.horizontalCenter: parent.horizontalCenter
                Button {
                    text: isPortrait ? "Buienradar NL" : "Buien NL"
                    onClicked: pageStack.push("CurrentWeather.qml")
                }
                Button {
                    text: "5 daags NL"
                    onClicked: pageStack.push("Forecast.qml")
                }
                Button {
                    text: "Buien Europa"
                    onClicked: pageStack.push("WeatherEurope.qml")
                    visible: isLandscape
                }
                Button {
                    text: "Lokaal (→3uur)"
                    onClicked: pageStack.push("Weather3hr.qml")
                    visible: isLandscape
                }
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingSmall
                Button {
                    text: "Lokaal (→3uur)"
                    onClicked: pageStack.push("Weather3hr.qml")
                    visible: isPortrait
                }
                Button {
                    text: "Weer NL morgen"
                    onClicked: pageStack.push("WeatherTomorrow.qml")
                }
                Button {
                    text: "Neerslag (→2uur)"
                    onClicked: rainGraph()
                    visible: isLandscape
                }
                Button {
                    text: "Windkracht NL"
                    onClicked: pageStack.push("Wind.qml")
                    visible: isLandscape
                }
                Button {
                    text: "Temperatuur NL"
                    onClicked: pageStack.push("Temperature.qml")
                    visible: isLandscape
                }
            }
            Row {
                visible: isPortrait
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingSmall
                Button {
                    text: "Windkracht NL"
                    onClicked: pageStack.push("Wind.qml")
                }
                Button {
                    text: "Temperatuur NL"
                    onClicked: pageStack.push("Temperature.qml")
                }
            }
            Row {
                visible: isPortrait
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingSmall
                Button {
                    text: "Buien Europa"
                    onClicked: pageStack.push("WeatherEurope.qml")
                }
                Button {
                    text: "Neerslag (→2uur)"
                    onClicked: rainGraph()
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
                    text: locHumidity
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
                    text: "Zonsopkomst"
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: isPortrait ? parent.width * 0.5 : parent.width * 0.5 / 1.5
                    text: locDawn
                    color: Theme.highlightColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }
                IconButton {
                    visible: isLandscape
                    id: weatherIconLandscape
                    icon.source: mainapp.iconLocation
                    highlighted: true
                    icon.height: largeScreen ? 256 : 128
                    icon.width: icon.height
                    height: 1 // to make it small not to cause space in left column
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    width: isPortrait ? parent.width * 0.5 : parent.width * 0.5 / 1.5
                    text: "Zonsondergang"
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    wrapMode: Text.Wrap
                }

                Label {
                    width: isPortrait ? parent.width * 0.5 : parent.width * 0.5 / 1.5
                    text: locDusk
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
                    icon.height: largeScreen ? 256 : 128
                    icon.width: icon.height
                    width: icon.width
                    height: icon.height * 1.3
                }
            }
            Label {
                id: localText
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: isPortrait ? 0 : (parent.width - localText.width) / 4
                text: locText
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
