# XML data retrieval Buienradar (idea by S. Ebeltjes / domoticx.nl)
#
# Import libraries
import urllib.request
try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET
import re

# SETTINGS
httpadres = "http://xml.buienradar.nl/"


def reformat(txt):
    reformatted = re.sub(r'\.(\w)', '. \\1', txt)
    reformatted = re.sub(r'\!(\w)', '! \\1', reformatted)
    reformatted = reformatted.replace("&eacute;", "é")
    reformatted = reformatted.replace("&Eacute;", "É")
    reformatted = reformatted.replace("  ", " ")
    return reformatted


def globaal_weer():
    """Return the weather texts."""
    try:
        httpdata = urllib.request.Request(httpadres)
    except BaseException:
        # Foutafhandeling als het station niet gevonden is.
        return "", "Fout bij ophalen data", httpadres, "", "", "", "", "", ""
    try:
        xml = ET.parse(urllib.request.urlopen(
            httpdata))  # Parse het XML bestand
    except BaseException:
        # Foutafhandeling als het station niet gevonden is.
        return "", "Fout bij ophalen data", httpadres, "", "", "", "", "", ""

    try:
        weertijd = xml.find(
            "weergegevens/verwachting_vandaag/tijdweerbericht").text
        weertitel = xml.find(
            "weergegevens/verwachting_vandaag/samenvatting").text
        weertekst = xml.find("weergegevens/verwachting_vandaag/tekst").text
        weermiddellangkop = xml.find(
            "weergegevens/verwachting_meerdaags/tekst_middellang").attrib.get('periode')
        weermiddellang = xml.find(
            "weergegevens/verwachting_meerdaags/tekst_middellang").text
        weerlangkop = xml.find(
            "weergegevens/verwachting_meerdaags/tekst_lang").attrib.get('periode')
        weerlang = xml.find(
            "weergegevens/verwachting_meerdaags/tekst_lang").text
        # do some reformatting
        weertitel = reformat(weertitel)
        weertekst = reformat(weertekst)
        weermiddellang = reformat(weermiddellang)
        weerlang = reformat(weerlang)
        weerlangkop = reformat(weerlangkop)
        weermiddellangkop = reformat(weermiddellangkop)

        return weertijd, weertitel, weertekst, weermiddellangkop, weermiddellang, weerlangkop, weerlang
    except BaseException:
        # Foutafhandeling als het station niet gevonden is.
        return "", "Fout bij ophalen data", httpadres, "", "", "", "", "", ""


def lokaal_weer(stationnr):
    """Return weather station specific info."""
    import datetime
    try:
        httpdata = urllib.request.Request(httpadres)
    except BaseException:
        # Foutafhandeling als het station niet gevonden is.
        return "", "Fout bij ophalen data", httpadres, "", "", "", "", "", ""
    try:
        xml = ET.parse(urllib.request.urlopen(
            httpdata))  # Parse het XML bestand
    except BaseException:
        # Foutafhandeling als het station niet gevonden is.
        return "", "Fout bij ophalen data", httpadres, "", "", "", "", "", ""
    zononder = xml.find(
        "weergegevens/actueel_weer/buienradar/zononder").text.split(' ', 1)[1][:-3]
    zonopkomst = xml.find(
        "weergegevens/actueel_weer/buienradar/zonopkomst").text.split(' ', 1)[1][:-3].lstrip('0')
    for x in range(1, 1000):
        stationscan = xml.find(
            "weergegevens/actueel_weer/weerstations/weerstation[" +
            str(x) +
            "]").attrib.get('id')
        if stationscan == stationnr:
            # Weather station found, continue
            regio = xml.find(
                "weergegevens/actueel_weer/weerstations/weerstation[" +
                str(x) +
                "]/stationnaam").attrib.get('regio')
            datum = xml.find(
                "weergegevens/actueel_weer/weerstations/weerstation[" + str(x) + "]/datum").text[:-3]
            try:
                datum = datetime.datetime.strptime(
                    datum, '%m/%d/%Y %H:%M').strftime('%d/%m/%y %H:%M')
            except BaseException:
                datum = datetime.datetime.strptime(
                    datum, '%m-%d-%Y %H:%M').strftime('%d-%m-%y %H:%M')
            luchtvochtigheid = xml.find(
                "weergegevens/actueel_weer/weerstations/weerstation[" +
                str(x) +
                "]/luchtvochtigheid").text
            temperatuurGC = xml.find(
                "weergegevens/actueel_weer/weerstations/weerstation[" +
                str(x) +
                "]/temperatuurGC").text
            windsnelheidMS = xml.find(
                "weergegevens/actueel_weer/weerstations/weerstation[" +
                str(x) +
                "]/windsnelheidMS").text
            windsnelheidBF = xml.find(
                "weergegevens/actueel_weer/weerstations/weerstation[" +
                str(x) +
                "]/windsnelheidBF").text
            windrichtingGR = xml.find(
                "weergegevens/actueel_weer/weerstations/weerstation[" +
                str(x) +
                "]/windrichtingGR").text
            windrichting = xml.find(
                "weergegevens/actueel_weer/weerstations/weerstation[" +
                str(x) +
                "]/windrichting").text
            zin = xml.find(
                "weergegevens/actueel_weer/weerstations/weerstation[" +
                str(x) +
                "]/icoonactueel").attrib.get('zin')
            iconactueel = xml.find(
                "weergegevens/actueel_weer/weerstations/weerstation[" +
                str(x) +
                "]/icoonactueel").attrib.get('ID')
            lat = xml.find(
                "weergegevens/actueel_weer/weerstations/weerstation[" + str(x) + "]/lat").text
            lon = xml.find(
                "weergegevens/actueel_weer/weerstations/weerstation[" + str(x) + "]/lon").text
            meetstation = xml.find(
                "weergegevens/actueel_weer/weerstations/weerstation[" +
                str(x) +
                "]/stationnaam").text
            tdelta = datetime.datetime.strptime(
                zononder, '%H:%M') - datetime.datetime.strptime(zonopkomst, '%H:%M')
            # temperatuur10cm = xml.find("weergegevens/actueel_weer/weerstations/weerstation[" + str(x) + "]/temperatuur10cm").text
            # luchtdruk = xml.find("weergegevens/actueel_weer/weerstations/weerstation[" + str(x) + "]/luchtdruk").text
            # zichtmeters = xml.find("weergegevens/actueel_weer/weerstations/weerstation[" + str(x) + "]/zichtmeters").text
            # windstotenMS = xml.find("weergegevens/actueel_weer/weerstations/weerstation[" + str(x) + "]/windstotenMS").text
            # regenMMPU = xml.find("weergegevens/actueel_weer/weerstations/weerstation[" + str(x) + "]/regenMMPU").text
            if len(windrichting) == 1:
                windrichting = windrichting.replace("O", "Oost")
                windrichting = windrichting.replace("W", "West")
                windrichting = windrichting.replace("N", "Noord")
                windrichting = windrichting.replace("Z", "Zuid")
            return regio, datum, temperatuurGC, luchtvochtigheid, windrichting, windsnelheidBF, windsnelheidMS, windrichtingGR, \
                zonopkomst, zononder, zin, iconactueel, lat, lon, meetstation, ':'.join(
                    str(tdelta).split(':')[:2])
            break  # End the loop


def get_stations():
    """Return all available weather stations."""
    try:
        httpdata = urllib.request.Request(httpadres)
    except BaseException:
        return "", "Fout bij ophalen data (request)", httpadres, "", "", "", "", "", ""
    try:
        xml = ET.parse(urllib.request.urlopen(httpdata))  # Parse XML file
    except BaseException:
        return "", "Fout bij ophalen data (open)", httpadres, "", "", "", "", "", ""

    lst = []
    for x in range(1, 1000):
        d = {}
        try:
            xml.find(
                "weergegevens/actueel_weer/weerstations/weerstation[" +
                str(x) +
                "]").attrib.get('id')
        except BaseException:
            break
        d['stationcode'] = xml.find(
            "weergegevens/actueel_weer/weerstations/weerstation[" +
            str(x) +
            "]/stationcode").text
        d['regio'] = xml.find(
            "weergegevens/actueel_weer/weerstations/weerstation[" +
            str(x) +
            "]/stationnaam").attrib.get('regio')
        d['meetstation'] = xml.find(
            "weergegevens/actueel_weer/weerstations/weerstation[" +
            str(x) +
            "]/stationnaam").text.replace(
            "Meetstation ",
            "")
        lst.append(d)
    sortedlist = sorted(lst, key=lambda k: k['regio'])
    return sortedlist


def strip_date(full_date):
    _months_year = {
        'januari': 'jan',
        'februari': 'feb',
        'maart': 'mar',
        'april': 'apr',
        'mei': 'mei',
        'juni': 'jun',
        'juli': 'jul',
        'augustus': 'aug',
        'september': 'sep',
        'oktober': 'okt',
        'november': 'nov',
        'december': 'dec'
    }
    full_date_split = full_date.split()

    try:
        # full monthname fetched, use abbreviation
        return str(full_date_split[1]) + " " + _months_year[full_date_split[2]]
    except BaseException:
        return str(full_date_split[1]) + " " + str(full_date_split[2])


def forecast_weer():
    """Return 5 day weather forecast."""
    try:
        httpdata = urllib.request.Request(httpadres)
    except BaseException:
        # Foutafhandeling als het station niet gevonden is.
        return "", "Fout bij ophalen data", httpadres, "", "", "", "", "", ""
    try:
        xml = ET.parse(urllib.request.urlopen(httpdata))  # Parse XML file
    except BaseException:
        # Foutafhandeling als het station niet gevonden is.
        return "", "Fout bij ophalen data", httpadres, "", "", "", "", "", ""

    lst = []
    for x in range(1, 6):
        d = {}
        d['icoon'] = xml.find(
            "weergegevens/verwachting_meerdaags/dag-plus" +
            str(x) +
            "/icoon").attrib.get('ID')
        d['dagweek'] = xml.find(
            "weergegevens/verwachting_meerdaags/dag-plus" +
            str(x) +
            "/dagweek").text
        d['datum'] = strip_date(
            xml.find(
                "weergegevens/verwachting_meerdaags/dag-plus" +
                str(x) +
                "/datum").text)
        d['mintemp'] = xml.find(
            "weergegevens/verwachting_meerdaags/dag-plus" +
            str(x) +
            "/mintemp").text
        d['maxtemp'] = xml.find(
            "weergegevens/verwachting_meerdaags/dag-plus" +
            str(x) +
            "/maxtemp").text
        d['windrichting'] = xml.find(
            "weergegevens/verwachting_meerdaags/dag-plus" +
            str(x) +
            "/windrichting").text
        d['windkracht'] = xml.find(
            "weergegevens/verwachting_meerdaags/dag-plus" +
            str(x) +
            "/windkracht").text
        d['kansregen'] = xml.find(
            "weergegevens/verwachting_meerdaags/dag-plus" +
            str(x) +
            "/kansregen").text.replace(
            '-',
            '0')
        if d['mintemp'] == "-":
            d['mintemp'] = "0"
        if d['maxtemp'] == "-":
            d['maxtemp'] = "0"
        lst.append(d)
    return lst


def forecast_rain(latitude, longitude):
    """Return expected rain expectations"""
    httpadres = "http://gadgets.buienradar.nl"
    try:
        httpdata = urllib.request.Request(
            httpadres +
            "/data/raintext?lat=" +
            latitude +
            "&lon=" +
            longitude)
    except BaseException:
        return "", "Fout bij ophalen data (request)", httpadres, "", "", "", "", "", ""
    try:
        rainresult = urllib.request.urlopen(httpdata)
    except BaseException:
        return "", "Fout bij ophalen data (open)", httpadres, "", "", "", "", "", ""
    return rainresult.read().decode("utf-8")
