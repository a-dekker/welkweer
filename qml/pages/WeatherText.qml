import QtQuick 2.2
import Sailfish.Silica 1.0
import io.thp.pyotherside 1.5

Page {
    id: forecast

    property string weerTijd: ""
    property string weerTitel: ""
    property string weerTekst: ""
    property string weerMiddellangKop: ""
    property string weerMiddellang: ""
    property string weerLangKop: ""
    property string weerLang: ""

    Python {
        id: python

        Component.onCompleted: {
            // Add the directory of this .qml file to the search path
            addImportPath(Qt.resolvedUrl('.'))
            // Import the main module
            importModule('call_buienradar', function () {
                console.log('call_buienradar module is now imported')
                call("call_buienradar.get_weer_nederland_info", [],
                     function (result) {
                         weerTijd = result["weertijd"]
                         weerTitel = result["weertitel"]
                         weerTekst = result["weertekst"]
                         weerMiddellangKop = result["weermiddellangkop"]
                         weerMiddellang = result["weermiddellang"]
                         weerLangKop = result["weerlangkop"]
                         weerLang = result["weerlang"]
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
        running: weerTekst === ""
        size: BusyIndicatorSize.Large
    }

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
                title: "Beschrijving weer NL"
            }
            // Uitgebreide tekst
            Label {
                y: Theme.paddingMedium
                text: weerTitel
                horizontalAlignment: Text.AlignRight
                color: Theme.highlightColor
                wrapMode: Text.Wrap
                width: col.width - (2 * Theme.paddingMedium)
            }
            Label {
                x: Theme.paddingMedium
                y: Theme.paddingMedium
                text: weerTekst
                width: col.width - (2 * Theme.paddingMedium)
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
            }
            // weer middellange termijn
            Label {
                y: Theme.paddingMedium
                text: weerMiddellangKop
                horizontalAlignment: Text.AlignRight
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.Wrap
                width: col.width - (2 * Theme.paddingMedium)
            }
            Label {
                x: Theme.paddingMedium
                y: Theme.paddingMedium
                text: weerMiddellang.trim()
                width: col.width - (2 * Theme.paddingMedium)
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
            }
            // weer lange termijn
            Label {
                y: Theme.paddingMedium
                text: weerLangKop
                horizontalAlignment: Text.AlignRight
                color: Theme.highlightColor
                font.pixelSize: Theme.fontSizeSmall
                wrapMode: Text.Wrap
                width: col.width - (2 * Theme.paddingMedium)
            }
            Label {
                x: Theme.paddingMedium
                y: Theme.paddingMedium
                text: weerLang.trim()
                width: col.width - (2 * Theme.paddingMedium)
                wrapMode: Text.Wrap
                font.pixelSize: Theme.fontSizeSmall
            }
            // footer
            Label {
                y: Theme.paddingMedium
                text: "Bron: <a href='#'>BuienRadar.NL.</a><br>" + weerTijd + "<br>"
                color: Theme.secondaryHighlightColor
                font.pixelSize: Theme.fontSizeExtraSmall
                visible: weerTekst !== ""
                horizontalAlignment: Text.AlignRight
                width: col.width - (2 * Theme.paddingMedium)
                linkColor: Theme.secondaryHighlightColor
                onLinkActivated: Qt.openUrlExternally("http://buienradar.nl")
            }
        }
    }
}
