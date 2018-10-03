# XML data retrieval Buienradar (idea by S. Ebeltjes / domoticx.nl)
#
# Import libraries
import urllib.request
try:
    import xml.etree.cElementTree as ET
except ImportError:
    import xml.etree.ElementTree as ET
import re
import math

# SETTINGS
HTTPADRES = "http://xml.buienradar.nl/"


def reformat(txt):
    """Fix some html strings and common syntax issues"""
    reformatted = re.sub(r'\.(\w)', '. \\1', txt)
    reformatted = re.sub(r'\!(\w)', '! \\1', reformatted)
    reformatted = reformatted.replace("&euml;", "ë")
    reformatted = reformatted.replace("&eacute;", "é")
    reformatted = reformatted.replace("&Eacute;", "É")
    reformatted = reformatted.replace("  ", " ")
    reformatted = reformatted.replace("&lsquo;", "‘")
    reformatted = reformatted.replace("&rsquo;", "’")
    reformatted = reformatted.replace("&ldquo;", "“")
    reformatted = reformatted.replace("&rdquo;", "”")
    reformatted = reformatted.replace("&bdquo;", "„")
    reformatted = reformatted.replace("&agrave;", "à")
    reformatted = reformatted.replace("&aacute;", "á")
    reformatted = reformatted.replace("&auml;", "ä")
    reformatted = reformatted.replace("&ordm;", "º")
    return reformatted


def globaal_weer():
    """Return the weather texts."""
    try:
        httpdata = urllib.request.Request(HTTPADRES)
    except BaseException:
        # Foutafhandeling als het station niet gevonden is.
        return "", "Fout bij ophalen data", HTTPADRES, "", "", "", "", "", ""
    try:
        xml = ET.parse(urllib.request.urlopen(
            httpdata))  # Parse het XML bestand
    except BaseException:
        # Foutafhandeling als het station niet gevonden is.
        return "", "Fout bij ophalen data", HTTPADRES, "", "", "", "", "", ""

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
        return "", "Fout bij ophalen data", HTTPADRES, "", "", "", "", "", ""


def get_dew_point_c(t_air_c, rel_humidity):
    """Compute the dew point in degrees Celsius

    :param t_air_c: current ambient temperature in degrees Celsius
    :type t_air_c: float
    :param rel_humidity: relative humidity in %
    :type rel_humidity: float
    :return: the dew point in degrees Celsius
    :rtype: float
    """
    a = 17.27
    b = 237.7
    alpha = ((a * float(t_air_c)) / (b + float(t_air_c))) + math.log(float(rel_humidity) / 100.0)
    return (b * alpha) / (a - alpha)


def lokaal_weer(stationnr):
    """Return weather station specific info."""
    import datetime
    try:
        httpdata = urllib.request.Request(HTTPADRES)
    except BaseException:
        # Foutafhandeling als het station niet gevonden is.
        return "", "Fout bij ophalen data", HTTPADRES, "", "", "", "", "", "", ""
    try:
        xml = ET.parse(urllib.request.urlopen(
            httpdata))  # Parse het XML bestand
    except BaseException:
        # Foutafhandeling als het station niet gevonden is.
        return "", "Fout bij ophalen data", HTTPADRES, "", "", "", "", "", "", ""
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
            temperatuur_gc = xml.find(
                "weergegevens/actueel_weer/weerstations/weerstation[" +
                str(x) +
                "]/temperatuurGC").text
            windsnelheid_ms = xml.find(
                "weergegevens/actueel_weer/weerstations/weerstation[" +
                str(x) +
                "]/windsnelheidMS").text
            windsnelheid_bf = xml.find(
                "weergegevens/actueel_weer/weerstations/weerstation[" +
                str(x) +
                "]/windsnelheidBF").text
            windrichting_gr = xml.find(
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
            try:
                tdelta = datetime.datetime.strptime(
                    zononder, '%H:%M') - datetime.datetime.strptime(zonopkomst, '%H:%M')
            except ValueError:
                zononder = "?:??"
                zonopkomst = "?:??"
                tdelta = 0
            # temperatuur10cm = xml.find("weergegevens/actueel_weer/weerstations/weerstation[" + str(x) + "]/temperatuur10cm").text
            # luchtdruk = xml.find("weergegevens/actueel_weer/weerstations/weerstation[" + str(x) + "]/luchtdruk").text
            # zichtmeters = xml.find("weergegevens/actueel_weer/weerstations/weerstation[" + str(x) + "]/zichtmeters").text
            # windstotenMS = xml.find("weergegevens/actueel_weer/weerstations/weerstation[" + str(x) + "]/windstotenMS").text
            # regenMMPU = xml.find("weergegevens/actueel_weer/weerstations/weerstation[" + str(x) + "]/regenMMPU").text
            if len(windrichting) == 1:
                windrichting = windrichting.replace("O", "Oost←")
                windrichting = windrichting.replace("W", "West→")
                windrichting = windrichting.replace("N", "Noord↓")
                windrichting = windrichting.replace("Z", "Zuid↑")
            else:
                windrichting = windrichting.replace("ZW", "ZW↗")
                windrichting = windrichting.replace("ZO", "ZO↖")
                windrichting = windrichting.replace("NW", "NW↘")
                windrichting = windrichting.replace("NO", "NO↙")
            dauwpunt_temp = math.floor(get_dew_point_c(temperatuur_gc, luchtvochtigheid)*10)/10
            return regio, datum, temperatuur_gc, luchtvochtigheid, windrichting, windsnelheid_bf, windsnelheid_ms, windrichting_gr, \
                zonopkomst, zononder, zin, iconactueel, lat, lon, meetstation, ':'.join(
                    str(tdelta).split(':')[:2]), dauwpunt_temp


def get_stations():
    """Return all available weather stations."""
    try:
        httpdata = urllib.request.Request(HTTPADRES)
    except BaseException:
        return "", "Fout bij ophalen data (request)", HTTPADRES, "", "", "", "", "", ""
    try:
        xml = ET.parse(urllib.request.urlopen(httpdata))  # Parse XML file
    except BaseException:
        return "", "Fout bij ophalen data (open)", HTTPADRES, "", "", "", "", "", ""

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
    """Shorten name of month"""
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
        httpdata = urllib.request.Request(HTTPADRES)
    except BaseException:
        # Foutafhandeling als het station niet gevonden is.
        return "", "Fout bij ophalen data", HTTPADRES, "", "", "", "", "", ""
    try:
        xml = ET.parse(urllib.request.urlopen(httpdata))  # Parse XML file
    except BaseException:
        # Foutafhandeling als het station niet gevonden is.
        return "", "Fout bij ophalen data", HTTPADRES, "", "", "", "", "", ""

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
    httpadres = "https://gadgets.buienradar.nl"
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
