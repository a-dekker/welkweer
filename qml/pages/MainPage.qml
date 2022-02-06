import QtQuick 2.5
import Sailfish.Silica 1.0
import harbour.welkweer.Settings 1.0
import Nemo.Notifications 1.0
import org.freedesktop.contextkit 1.0
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
    property string maanStandSymbool: "-"
    property string networkState: "waiting"
    property string weercode: "transparent"

    Component.onCompleted: {
        getMoonPhase()
        timer.start()
    }

    ContextProperty {
        id: contextProperty
        key: "Internet.NetworkState"
        onValueChanged: networkState = value
        value: "waiting"
    }
    ContextProperty {
        id: contextPropertyType
        key: "Internet.NetworkType"
        // onValueChanged: console.log(value)
    }

    Timer {
        id: timer
        interval: 1000
        running: networkState !== "waiting"
        repeat: false
        onTriggered: {
            if (checkNetworkConnection() === true) {
                loadWeather()
                getWeatherCode()
            }
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
        if (networkState !== "connected" && myset.value(
                    "display_connectivity_error", "true") === "true") {
            banner("INFO", qsTr("Geen internet connectie!"))
            locText = "Geen internet connectie"
            return false
        }
        return true
    }

    function loadWeather() {
        python.call("call_buienradar.get_lokaal_weerinfo", [weerStation],
                    function (result) {
                        mainapp.locPlace = result["regio"]
                        mainapp.lastUpdCover = result["datum"]
                        lastUpd = "Laatste update buienradar.NL: " + result["datum"]
                        mainapp.locTemp = result["temperatuur_gc"] + '°C'
                        locHumidity = result["luchtvochtigheid"] + '%'
                        mainapp.locWind = result["windrichting"] + ' ' + result["windsnelheid_ms"]
                                + 'm/s (' + result["windsnelheid_bf"] + ' BF)'
                        mainapp.locWindArrow = result["windpijl"]
                        locDawn = result["zonopkomst"]
                        locDusk = result["zononder"] + ' (' + result["tdelta"] + ' uur)'
                        locText = '"' + result["zin"] + '"'
                        mainapp.iconLocation = "/usr/share/harbour-welkweer/qml/images/icons/"
                                + result["iconactueel"] + ".png"
                        mainapp.latitude = result["lat"]
                        mainapp.longitude = result["lon"]
                        mainapp.locMeetStation = result["meetstation"]
                        locDewPointTemp = result["dauwpunt_temp"] + '°C'
                        locDewPointName = result["dauwpunt_tekst"]
                    })
    }

    function getMoonPhase() {
        python.call("call_buienradar.get_moon_phase", [], function (result) {
            maanStand = result["text"]
            maanStandSymbool = result["symbol"]
        })
    }

    function getWeatherCode() {
        python.call("call_buienradar.get_weercode", [], function (result) {
            weercode = result
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
                text: qsTr("Locatie meetstation")
                onClicked: {
                    if (checkNetworkConnection() === true) {
                        Qt.openUrlExternally(
                                    "https://www.openstreetmap.org/?mlat="
                                    + mainapp.latitude + "&mlon=" + mainapp.longitude)
                    }
                }
            }
            MenuItem {
                text: qsTr("Instellingen")
                onClicked: {
                    pageStack.push(Qt.resolvedUrl("SettingPage.qml"), {
                                       "isOnline": checkNetworkConnection()
                                   })
                }
            }
            MenuItem {
                text: qsTr("Vernieuwen")
                onClicked: {
                    if (checkNetworkConnection() === true) {
                        weerStation = myset.value("stationcode", "6240")
                        locText = "Geen data"
                        getMoonPhase()
                        loadWeather()
                        getWeatherCode()
                    }
                }
            }
            MenuLabel {
                text: mainapp.locMeetStation
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height
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
                subTitle: ""
                subTitleOpacity: 0.5
                subTitleBottomMargin: isPortrait ? Theme.paddingSmall : 0
                Label {
                    text: mainapp.locTemp
                    color: Theme.highlightColor
                    font.bold: true
                    font.pixelSize: Theme.fontSizeLarge
                    anchors.left: parent.left
                    anchors.leftMargin: Theme.horizontalPageMargin
                    anchors.verticalCenter: parent.verticalCenter
                }
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
                    text: "Waarschuwingen"
                    icon.source: weercode
                                 !== "transparent" ? "image://theme/icon-system-warning" : ""
                    icon.color: weercode
                    width: (column.width / 4) * 0.95
                    onClicked: {
                        if (checkNetworkConnection() === true) {
                            pageStack.push("Warnings.qml")
                        }
                    }
                    visible: isLandscape
                }
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingSmall
                Button {
                    text: "Waarschuwingen"
                    icon.source: weercode
                                 !== "transparent" ? "image://theme/icon-system-warning" : ""
                    icon.color: weercode
                    width: (column.width / 2) * 0.95
                    onClicked: {
                        if (checkNetworkConnection() === true) {
                            pageStack.push("Warnings.qml")
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
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    width: isPortrait ? parent.width * 0.33 : parent.width * 0.33 / 1.5
                    text: mainapp.locWindArrow
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeMedium
                    wrapMode: Text.Wrap
                }

                Label {
                    width: isPortrait ? parent.width * 0.66 : parent.width * 0.66 / 1.5
                    text: mainapp.locWind
                    font.pixelSize: Theme.fontSizeMedium
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    width: isPortrait ? parent.width * 0.33 : parent.width * 0.33 / 1.5
                    text: "💧"
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeMedium
                    wrapMode: Text.Wrap
                }

                Label {
                    width: isPortrait ? parent.width * 0.66 : parent.width * 0.33 / 1.5
                    text: locHumidity + " (" + locDewPointName + " " + locDewPointTemp + ")"
                    font.pixelSize: Theme.fontSizeMedium
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    width: isPortrait ? parent.width * 0.33 : parent.width * 0.33 / 1.5
                    text: "☼"
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeMedium
                    wrapMode: Text.Wrap
                }

                Label {
                    width: isPortrait ? parent.width * 0.66 : parent.width * 0.66 / 1.5
                    text: locDawn + "-" + locDusk
                    font.pixelSize: Theme.fontSizeMedium
                }
                IconButton {
                    visible: isLandscape
                    id: weatherIconLandscape
                    icon.source: mainapp.iconLocation
                    icon.height: screen.width <= 540 ? 128 : 300
                    icon.width: icon.height
                    icon.color: undefined
                    height: 1 // to make it small not to cause space in left column
                }
            }
            Row {
                width: parent.width
                spacing: Theme.paddingSmall

                Label {
                    width: isPortrait ? parent.width * 0.33 : parent.width * 0.33 / 1.5
                    text: maanStandSymbool
                    horizontalAlignment: Text.AlignRight
                    color: Theme.primaryColor
                    font.pixelSize: Theme.fontSizeMedium
                    wrapMode: Text.Wrap
                }
                Label {
                    width: isPortrait ? parent.width * 0.66 : parent.width * 0.66 / 1.5
                    text: maanStand
                    font.pixelSize: Theme.fontSizeMedium
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
                    icon.height: screen.width <= 540 ? 128 : 300
                    // icon.height: 128 * Theme.pixelRatio
                    icon.width: icon.height
                    width: icon.width
                    height: icon.height * 1.3
                    icon.color: undefined
                }
            }
            ScrollLabel {
                id: localText
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.horizontalCenterOffset: isPortrait ? 0 : (parent.width
                                                                  - localText.width) / 4
                text: locText === '"undefined"' ? '"fout"' : locText
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
