import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    id: aboutPage
    property bool largeScreen: Screen.sizeCategory === Screen.Large
                               || Screen.sizeCategory === Screen.ExtraLarge
    SilicaFlickable {
        anchors.fill: parent
        contentWidth: parent.width
        contentHeight: col.height

        VerticalScrollDecorator {
        }

        Column {
            id: col
            spacing: Theme.paddingLarge
            width: parent.width
            PageHeader {
                title: qsTr("Over")
            }
            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
                visible: isPortrait || largeScreen
            }
            Label {
                text: "WelkWeer"
                font.pixelSize: Theme.fontSizeExtraLarge
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Image {
                anchors.horizontalCenter: parent.horizontalCenter
                source: isLandscape ? (largeScreen ? "/usr/share/icons/hicolor/256x256/apps/harbour-welkweer.png" : "/usr/share/icons/hicolor/86x86/apps/harbour-welkweer.png") : (largeScreen ? "/usr/share/icons/hicolor/256x256/apps/harbour-welkweer.png" : "/usr/share/icons/hicolor/128x128/apps/harbour-welkweer.png")
            }
            Label {
                text: qsTr("Versie") + " " + version
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryHighlightColor
            }
            Label {
                text: qsTr("Weer gerelateerde info")
                font.pixelSize: Theme.fontSizeSmall
                anchors.horizontalCenter: parent.horizontalCenter
                color: Theme.secondaryColor
            }
            SectionHeader {
                text: qsTr("Auteur")
                visible: isPortrait || largeScreen
            }
            Label {
                text: "© Arno Dekker 2014-2017"
                anchors.horizontalCenter: parent.horizontalCenter
            }
            SectionHeader {
                text: qsTr("Data bronnen")
                visible: isPortrait || largeScreen
            }
            Label {
                x: Theme.paddingLarge
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeExtraSmall
                text: "<a href=\"http://www.buienradar.nl\">BuienRadar.NL</a>" + " en " + "<a href=\"http://www.knmi.nl\">knmi.nl</a>"
                onLinkActivated: Qt.openUrlExternally(link)
                linkColor: Theme.highlightColor
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Separator {
                color: Theme.primaryColor
                width: parent.width
                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Qt.AlignHCenter
                visible: isPortrait || largeScreen
            }
        }
    }
}
