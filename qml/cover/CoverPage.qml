/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {

    signal loadWeather

    Column {
        width: parent.width
        spacing: Theme.paddingMedium
        Label {
            id: coverHeader
            text: mainapp.locPlace
            width: parent.width - Theme.paddingLarge
            anchors.horizontalCenter: parent.horizontalCenter
            horizontalAlignment: Text.Center
            color: Theme.highlightColor
        }
        Image {
            source: mainapp.iconLocation
            anchors.horizontalCenter: parent.horizontalCenter
            height: mainapp.mediumScreen ? 256 : 128
            width: mainapp.mediumScreen ? 256 : 128
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: mainapp.locTemp
        }
        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: mainapp.locWind
                  === "Geen data" ? "" : mainapp.locWind.split(
                                        " ")[0] + " " + mainapp.locWind.split(
                                        " ")[2] + " " + mainapp.locWind.split(
                                        " ")[3]
        }
    }
    Label {
        anchors.bottomMargin: 0
        anchors.bottom: parent.bottom
        font.pixelSize: Theme.fontSizeTiny
        anchors.horizontalCenter: parent.horizontalCenter
        text: mainapp.lastUpdCover
    }
    CoverActionList {
        id: coverAction

        CoverAction {
            iconSource: "image://theme/icon-cover-refresh"
            onTriggered: loadWeather()
        }
    }
}
