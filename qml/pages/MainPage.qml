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
    property string alert_txt: ""
    ListModel {
        id: mainMenuModel
    }

    Component.onCompleted: {
        mainMenuModel.append({
                                 "name": qsTr("Neerslag"),
                                 "ident": "neerslag",
                                 "icon": "/usr/share/harbour-welkweer/qml/images/icons/neerslag.png"
                             })
        mainMenuModel.append({
                                 "name": qsTr("Temperatuur"),
                                 "ident": "temperatuur",
                                 "icon": "/usr/share/harbour-welkweer/qml/images/icons/temperatuur.png"
                             })
        mainMenuModel.append({
                                 "name": qsTr("Wind"),
                                 "ident": "wind",
                                 "icon": "/usr/share/harbour-welkweer/qml/images/icons/wind.png"
                             })
        mainMenuModel.append({
                                 "name": qsTr("Zicht"),
                                 "ident": "zicht",
                                 "icon": "/usr/share/harbour-welkweer/qml/images/icons/zicht.png"
                             })
        mainMenuModel.append({
                                 "name": qsTr("Voorspelling"),
                                 "ident": "voorspelling",
                                 "icon": "/usr/share/harbour-welkweer/qml/images/icons/voorspelling.png"
                             })
        mainMenuModel.append({
                                 "name": qsTr("Alarm"),
                                 "ident": "alarm",
                                 "icon": "/usr/share/harbour-welkweer/qml/images/icons/alarm.png"
                             })
        getMoonPhase()
        timer.start()
    }

    function parseClickedMainMenu(ident) {
        if (ident === "alarm") {
            pageStack.push(Qt.resolvedUrl("Warnings.qml"))
        } else if (ident === "wind") {
            pageStack.push(Qt.resolvedUrl("Wind.qml"))
        } else if (ident === "zicht") {
            pageStack.push(Qt.resolvedUrl("Visibility.qml"))
        } else if (ident === "temperatuur") {
            pageStack.push(Qt.resolvedUrl("Temperature.qml"))
        } else if (ident === "neerslag") {
            pageStack.push(Qt.resolvedUrl("Precipitation.qml"))
        } else if (ident === "voorspelling") {
            pageStack.push(Qt.resolvedUrl("Predictions.qml"))
        }
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
            weercode = result["weercode"]
            alert_txt = result["tekst"]
            weatherAlert()
        })
    }

    function translateWeatherCodeToDutch() {
        switch (weercode) {
        case "yellow":
            return "GEEL"
        case "orange":
            return "ORANJE"
        case "red":
            return "ROOD"
        default:
            return "GROEN"
        }
    }

    function weatherAlert() {
        if (myset.value("display_weather_alert",
                        "false") === "true" && weercode !== "transparent") {
            notification.summary = "Weerwaarschuwing [code " + translateWeatherCodeToDutch() + "]"
            notification.body = alert_txt
            notification.publish()
        }
        if (myset.value("display_weather_alert",
                        "false") === "false" && weercode !== "transparent") {
            notification.icon = "icon-lock-warning"
            notification.previewBody = "Code " + translateWeatherCodeToDutch() + " " + alert_txt
            notification.publish()
        }
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

            Item {
                id: myItem
                height: mainGrid.height
                width: parent.width
                Grid {
                    id: mainGrid

                    columns: isPortrait ? 3 : 6

                    anchors.horizontalCenter: parent.horizontalCenter
                    Repeater {
                        model: mainMenuModel
                        delegate: Component {
                            BackgroundItem {
                                id: gridItem
                                width: Theme.itemSizeHuge
                                height: Theme.itemSizeHuge
                                Rectangle {
                                    anchors.fill: parent
                                    anchors.margins: Theme.paddingSmall
                                    color: Theme.rgba(
                                               Theme.highlightBackgroundColor,
                                               Theme.highlightBackgroundOpacity)
                                }
                                Column {
                                    anchors.centerIn: parent
                                    HighlightImage {
                                        id: itemIcon
                                        source: icon
                                        width: Theme.itemSizeHuge / 2
                                        height: width
                                        color: (ident === "alarm" && weercode
                                                !== "transparent") ? weercode : Theme.primaryColor
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                    Label {
                                        id: itemLabel
                                        anchors {
                                            horizontalCenter: parent.horizontalCenter
                                        }
                                        font.pixelSize: Theme.fontSizeMedium
                                        width: gridItem.width - (2 * Theme.paddingSmall)
                                        horizontalAlignment: "AlignHCenter"
                                        scale: paintedWidth > width ? (width / paintedWidth) : 1
                                        text: name
                                        color: Theme.highlightColor
                                    }
                                }

                                onClicked: {
                                    parseClickedMainMenu(ident)
                                }
                            }
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
