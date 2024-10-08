import QtQuick 2.5
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5

Page {
    id: forecast

    property string icoon1: "0"
    property string dag1: "-"
    property string mintemp1: "-"
    property string maxtemp1: "-"
    property string wind1: "-"
    property string kansregen1: "-"
    property string icoon2: "0"
    property string dag2: "-"
    property string mintemp2: "-"
    property string maxtemp2: "-"
    property string wind2: "-"
    property string kansregen2: "-"
    property string icoon3: "0"
    property string dag3: "-"
    property string mintemp3: "-"
    property string maxtemp3: "-"
    property string wind3: "-"
    property string kansregen3: "-"
    property string icoon4: "0"
    property string dag4: "-"
    property string mintemp4: "-"
    property string maxtemp4: "-"
    property string wind4: "-"
    property string kansregen4: "-"
    property string icoon5: "0"
    property string dag5: "-"
    property string mintemp5: "-"
    property string maxtemp5: "-"
    property string wind5: "-"
    property string kansregen5: "-"
    property string weerMiddellang: ""
    property var dataModel: ListModel {}

    Python {
        id: python

        Component.onCompleted: {
            // Add the directory of this .qml file to the search path
            addImportPath(Qt.resolvedUrl('.'))
            // Import the main module
            importModule('call_buienradar', function () {
                console.log('call_buienradar module is now imported')
                call("call_buienradar.get_forecast_weer", [],
                     function (result) {
                         for (var i = 0; i < result.length; i++) {
                             dataModel.append(result[i])
                             if (i === 0) {
                                 icoon1 = dataModel.get(i).icoon
                                 dag1 = dataModel.get(
                                             i).dagweek + " " + dataModel.get(
                                             i).datum
                                 mintemp1 = dataModel.get(i).mintemp
                                 maxtemp1 = dataModel.get(i).maxtemp
                                 wind1 = dataModel.get(
                                             i).windrichting + " " + dataModel.get(
                                             i).windkracht
                                 kansregen1 = dataModel.get(i).kansregen + "%"
                             }
                             if (i === 1) {
                                 icoon2 = dataModel.get(i).icoon
                                 dag2 = dataModel.get(
                                             i).dagweek + " " + dataModel.get(
                                             i).datum
                                 mintemp2 = dataModel.get(i).mintemp
                                 maxtemp2 = dataModel.get(i).maxtemp
                                 wind2 = dataModel.get(
                                             i).windrichting + " " + dataModel.get(
                                             i).windkracht
                                 kansregen2 = dataModel.get(i).kansregen + "%"
                             }
                             if (i === 2) {
                                 icoon3 = dataModel.get(i).icoon
                                 dag3 = dataModel.get(
                                             i).dagweek + " " + dataModel.get(
                                             i).datum
                                 mintemp3 = dataModel.get(i).mintemp
                                 maxtemp3 = dataModel.get(i).maxtemp
                                 wind3 = dataModel.get(
                                             i).windrichting + " " + dataModel.get(
                                             i).windkracht
                                 kansregen3 = dataModel.get(i).kansregen + "%"
                             }
                             if (i === 3) {
                                 icoon4 = dataModel.get(i).icoon
                                 dag4 = dataModel.get(
                                             i).dagweek + " " + dataModel.get(
                                             i).datum
                                 mintemp4 = dataModel.get(i).mintemp
                                 maxtemp4 = dataModel.get(i).maxtemp
                                 wind4 = dataModel.get(
                                             i).windrichting + " " + dataModel.get(
                                             i).windkracht
                                 kansregen4 = dataModel.get(i).kansregen + "%"
                             }
                             if (i === 4) {
                                 icoon5 = dataModel.get(i).icoon
                                 dag5 = dataModel.get(
                                             i).dagweek + " " + dataModel.get(
                                             i).datum
                                 mintemp5 = dataModel.get(i).mintemp
                                 maxtemp5 = dataModel.get(i).maxtemp
                                 wind5 = dataModel.get(
                                             i).windrichting + " " + dataModel.get(
                                             i).windkracht
                                 kansregen5 = dataModel.get(i).kansregen + "%"
                             }
                         }
                     })
                call("call_buienradar.get_weer_nederland_info", [],
                     function (result) {
                         weerMiddellang = result["weermiddellang"]
                     })
            })
        }

        onError: {
            // when an exception is raised, this error handler will be called
            console.log('python error: ' + traceback)
        }
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: dag1 === "-"
        size: BusyIndicatorSize.Large
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
                title: isPortrait ? "5 daagse voorspelling" : "5 daagse voorspelling Nederland"
            }
            Label {
                x: Theme.paddingLarge
                y: Theme.paddingLarge
                text: "Nederland"
                font.pixelSize: Theme.fontSizeLarge
                horizontalAlignment: Text.AlignRight
                visible: isPortrait
                width: col.width - (2 * Theme.paddingLarge)
            }
            Row {
                id: koppenGrid
                width: parent.width - Theme.paddingLarge
                x: Theme.paddingMedium
                y: Theme.paddingMedium
                Label {
                    width: parent.width / 7
                    font.pixelSize: mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: qsTr("")
                    color: Theme.highlightColor
                }
                Label {
                    width: parent.width / 4
                    font.pixelSize: mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: qsTr("Datum")
                    color: Theme.highlightColor
                }
                Label {
                    width: parent.width / 7
                    font.pixelSize: mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: qsTr("Max")
                    color: Theme.highlightColor
                }
                Label {
                    width: parent.width / 7
                    font.pixelSize: mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: qsTr("Min")
                    color: Theme.highlightColor
                }
                Label {
                    width: parent.width / 6
                    font.pixelSize: mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: qsTr("Wind")
                    color: Theme.highlightColor
                }
                Label {
                    width: parent.width / 6
                    font.pixelSize: mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: qsTr("Neerslag kans")
                    color: Theme.highlightColor
                    wrapMode: Text.WordWrap
                }
            }
            Row {
                id: row1
                width: parent.width - 2 * Theme.paddingMedium
                x: Theme.paddingMedium
                y: Theme.paddingMedium
                Image {
                    id: image1
                    source: "/usr/share/harbour-welkweer/qml/images/icons/" + icoon1 + ".png"
                    height: mainapp.mediumScreen ? 110 : mainapp.largeScreen ? 125 : 40
                    width: mainapp.mediumScreen ? 110 : mainapp.largeScreen ? 125 : 40
                    anchors.verticalCenter: dag1txt.verticalCenter
                }
                Rectangle {
                    // some whitespace
                    width: (parent.width / 7) - image1.width
                    height: 1
                    opacity: 0
                }
                Label {
                    id: dag1txt
                    width: parent.width / 4
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeExtraSmall
                    text: dag1
                }
                Label {
                    width: parent.width / 7
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: maxtemp1
                }
                Label {
                    width: parent.width / 7
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: mintemp1
                }
                Label {
                    width: parent.width / 6
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: wind1
                }
                Label {
                    width: parent.width / 6
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: kansregen1
                }
            }
            Row {
                id: row2
                width: parent.width - Theme.paddingLarge
                x: Theme.paddingMedium
                y: Theme.paddingMedium
                Image {
                    id: image2
                    source: "/usr/share/harbour-welkweer/qml/images/icons/" + icoon2 + ".png"
                    height: mainapp.mediumScreen ? 110 : mainapp.largeScreen ? 125 : 40
                    width: mainapp.mediumScreen ? 110 : mainapp.largeScreen ? 125 : 40
                    anchors.verticalCenter: dag2txt.verticalCenter
                }
                Rectangle {
                    // some whitespace
                    width: (parent.width / 7) - image2.width
                    height: 1
                    opacity: 0
                }
                Label {
                    id: dag2txt
                    width: parent.width / 4
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeExtraSmall
                    text: dag2
                }
                Label {
                    width: parent.width / 7
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: maxtemp2
                }
                Label {
                    width: parent.width / 7
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: mintemp2
                }
                Label {
                    width: parent.width / 6
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: wind2
                }
                Label {
                    width: parent.width / 6
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: kansregen2
                }
            }
            Row {
                id: row3
                width: parent.width - Theme.paddingLarge
                x: Theme.paddingMedium
                y: Theme.paddingMedium
                Image {
                    id: image3
                    source: "/usr/share/harbour-welkweer/qml/images/icons/" + icoon3 + ".png"
                    height: mainapp.mediumScreen ? 110 : mainapp.largeScreen ? 125 : 40
                    width: mainapp.mediumScreen ? 110 : mainapp.largeScreen ? 125 : 40
                    anchors.verticalCenter: dag3txt.verticalCenter
                }
                Rectangle {
                    // some whitespace
                    width: (parent.width / 7) - image3.width
                    height: 1
                    opacity: 0
                }
                Label {
                    id: dag3txt
                    width: parent.width / 4
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeExtraSmall
                    text: dag3
                }
                Label {
                    width: parent.width / 7
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: maxtemp3
                }
                Label {
                    width: parent.width / 7
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: mintemp3
                }
                Label {
                    width: parent.width / 6
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: wind3
                }
                Label {
                    width: parent.width / 6
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: kansregen3
                }
            }
            Row {
                id: row4
                width: parent.width - Theme.paddingLarge
                x: Theme.paddingMedium
                y: Theme.paddingMedium
                Image {
                    id: image4
                    source: "/usr/share/harbour-welkweer/qml/images/icons/" + icoon4 + ".png"
                    height: mainapp.mediumScreen ? 110 : mainapp.largeScreen ? 125 : 40
                    width: mainapp.mediumScreen ? 110 : mainapp.largeScreen ? 125 : 40
                    anchors.verticalCenter: dag4txt.verticalCenter
                }
                Rectangle {
                    // some whitespace
                    width: (parent.width / 7) - image4.width
                    height: 1
                    opacity: 0
                }
                Label {
                    id: dag4txt
                    width: parent.width / 4
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeExtraSmall
                    text: dag4
                }
                Label {
                    width: parent.width / 7
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: maxtemp4
                }
                Label {
                    width: parent.width / 7
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: mintemp4
                }
                Label {
                    width: parent.width / 6
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: wind4
                }
                Label {
                    width: parent.width / 6
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: kansregen4
                }
            }
            Row {
                id: row5
                width: parent.width - Theme.paddingLarge
                x: Theme.paddingMedium
                y: Theme.paddingMedium
                Image {
                    id: image5
                    source: "/usr/share/harbour-welkweer/qml/images/icons/" + icoon5 + ".png"
                    height: mainapp.mediumScreen ? 110 : mainapp.largeScreen ? 125 : 40
                    width: mainapp.mediumScreen ? 110 : mainapp.largeScreen ? 125 : 40
                    anchors.verticalCenter: dag5txt.verticalCenter
                }
                Rectangle {
                    // some whitespace
                    width: (parent.width / 7) - image5.width
                    height: 1
                    opacity: 0
                }
                Label {
                    id: dag5txt
                    width: parent.width / 4
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeExtraSmall
                    text: dag5
                }
                Label {
                    width: parent.width / 7
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: maxtemp5
                }
                Label {
                    width: parent.width / 7
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: mintemp5
                }
                Label {
                    width: parent.width / 6
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: wind5
                }
                Label {
                    width: parent.width / 6
                    font.pixelSize: mainapp.mediumScreen ? Theme.fontSizeMedium : mainapp.largeScreen ? Theme.fontSizeLarge : Theme.fontSizeSmall
                    text: kansregen5
                }
            }
            // weer middellange termijn
            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
                visible: weerMiddellang.trim().length > 0
            }
            Row {
                width: parent.width - Theme.paddingLarge
                x: mainapp.mediumScreen ? Theme.paddingMedium : Theme.paddingSmall
                y: Theme.paddingMedium
                visible: weerMiddellang.trim().length > 0
                Image {
                    id: infoIcon
                    source: "image://theme/icon-m-about"
                    anchors.verticalCenter: parent.verticalCenter
                    visible: !mainapp.largeScreen
                }
                Label {
                    text: weerMiddellang.trim()
                    width: col.width - (Theme.paddingMedium + Theme.paddingSmall + infoIcon.width)
                    wrapMode: Text.Wrap
                    font.pixelSize: largeScreen ? Theme.fontSizeMedium : Theme.fontSizeSmall
                    color: Theme.secondaryColor
                }
            }
            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
                visible: weerMiddellang.trim().length > 0
            }
        }
    }
}
