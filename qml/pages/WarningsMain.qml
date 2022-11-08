import QtQuick 2.5
import Sailfish.Silica 1.0
import "../common"

Page {
    id: page

    SilicaFlickable {
        anchors.fill: parent
        contentHeight: content.height

        Column {
            id: content
            width: parent.width

            PageHeader {
                title: "Weeralarm"
            }

            MainPageButton {
                text: "Weeralarm vandaag"
                onClicked: pageStack.push(Qt.resolvedUrl("WarningsToday.qml"))
            }

            MainPageButton {
                text: "Weeralarm morgen"
                onClicked: pageStack.push(Qt.resolvedUrl("WarningsTomorrow.qml"))
            }

            MainPageButton {
                text: "Weeralarm overmorgen"
                onClicked: pageStack.push(Qt.resolvedUrl("WarningsTwoDays.qml"))
            }
        }
    }
}
