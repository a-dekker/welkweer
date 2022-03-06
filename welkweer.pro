# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-welkweer

CONFIG += sailfishapp

QT += qml dbus

SOURCES += src/welkweer.cpp \
    src/settings.cpp

OTHER_FILES += qml/welkweer.qml \
    qml/cover/CoverPage.qml \
    rpm/welkweer.changes.in \
    rpm/welkweer.spec \
    translations/*.ts \
    harbour-welkweer.desktop \
    python/buienradar.py \
    python/moon.py \
    qml/pages/About.qml \
    qml/pages/MainPage.qml \
    qml/pages/CurrentWeather.qml \
    qml/pages/Wind.qml \
    qml/pages/Flurry.qml \
    qml/pages/WeatherEurope.qml \
    qml/pages/CloudsEurope.qml \
    qml/pages/ThunderEurope.qml \
    qml/pages/Weather3hr.qml \
    qml/pages/WeatherText.qml \
    qml/pages/Temperature.qml \
    qml/pages/Windchill.qml \
    qml/pages/Warnings.qml \
    qml/pages/WarningsTomorrow.qml \
    qml/pages/WarningsTwoDays.qml \
    qml/pages/SettingPage.qml \
    qml/pages/Forecast.qml \
    qml/pages/NL24hours.qml \
    qml/pages/Visibility.qml \
    qml/pages/Drizzle.qml \
    qml/pages/Snow.qml \
    qml/pages/call_buienradar.py \
    qml/pages/Forecast.qml \
    qml/pages/WeatherTomorrow.qml \
    qml/pages/WeatherNight.qml \
    qml/pages/RainFall.qml \
    qml/pages/devicePixelRatioHack.js \
    qml/common/PageHeaderExtended.qml \
    qml/common/ScrollLabel.qml \
    qml/common/ZoomableImage.qml

isEmpty(VERSION) {
    VERSION = $$system( egrep "^Version:\|^Release:" rpm/welkweer.spec |tr -d "[A-Z][a-z]: " | tr "\\\n" "-" | sed "s/\.$//g"| tr -d "[:space:]")
    message("VERSION is unset, assuming $$VERSION")
}
DEFINES += APP_VERSION=\\\"$$VERSION\\\"
DEFINES += BUILD_YEAR=$$system(date '+%Y')

python.files = python/*
python.path = /usr/share/harbour-welkweer/python

icon86.files += icons/86x86/harbour-welkweer.png
icon86.path = /usr/share/icons/hicolor/86x86/apps

icon108.files += icons/108x108/harbour-welkweer.png
icon108.path = /usr/share/icons/hicolor/108x108/apps

icon128.files += icons/128x128/harbour-welkweer.png
icon128.path = /usr/share/icons/hicolor/128x128/apps

icon172.files += icons/172x172/harbour-welkweer.png
icon172.path = /usr/share/icons/hicolor/172x172/apps

icon256.files += icons/256x256/harbour-welkweer.png
icon256.path = /usr/share/icons/hicolor/256x256/apps

INSTALLS += icon86 icon108 icon128 icon172 icon256 python
# to disable building translations every time, comment out the
# following CONFIG line
CONFIG += sailfishapp_i18n

HEADERS += \
    src/notificationhelper.h \
    src/settings.h
