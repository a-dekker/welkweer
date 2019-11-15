import os
import xml.etree.ElementTree as ET

import pytest

from buienradar import (
    bepaal_lokale_weergegevens,
    bepaal_nl_weerteksten,
    bepaal_voorspellingen,
    calc_dew_point,
    get_dew_point_c,
    redefine_windrichting,
    reformat_date,
    reformat_text,
    strip_date,
    verwerk_station_data,
)


def test_get_dew_point_regular():
    assert get_dew_point_c(12, 80) == 8.656165309620064


def test_reformat_text():
    assert (
        reformat_text("H&eacute;, nogal  wat&nbsp; koud bij 3&ordm;")
        == "Hé, nogal wat koud bij 3º"
    )


def test_reformat_date():
    assert reformat_date("12/14/2019 11:34") == "14/12/19 11:34"
    assert reformat_date("1-3-2020 1:34") == "03-01-20 01:34"
    assert reformat_date("11_3_1971 8:34") == "??/??/?? ??:??"
    assert reformat_date("13/10/2012 18:95") == "??/??/?? ??:??"


def test_redefine_windrichting():
    assert redefine_windrichting("O") == ("Oost", "←")
    assert redefine_windrichting("W") == ("West", "→")
    assert redefine_windrichting("ZW") == ("ZW", "↗")
    assert redefine_windrichting("fout") == ("fou", "t")


def test_strip_date_no_shorten():
    assert strip_date("vrijdag 11 okt 2019") == "11 okt"


def test_strip_date_shorten():
    assert strip_date("vrijdag 11 oktober 2019") == "11 okt"


def test_strip_date_invalid_month():
    assert strip_date("vrijdag 11 julius 2019") == "11 julius"


def test_dew_point_above_zero():
    assert calc_dew_point("17.2", "88") == ("dauwpunt", 15.1)


def test_dew_point_below_zero():
    assert calc_dew_point("-5.4", "80") == ("rijptemp.", -8.3)


def test_dew_point_invalid():
    assert calc_dew_point(None, "Error") == ("", "")


@pytest.fixture
def xml_file_content():
    buienrader_xml_file = os.path.join(
        os.path.dirname(os.path.abspath(__file__)), "buienradar.xml"
    )
    return ET.parse(buienrader_xml_file)


def test_xml_file_content_nl(xml_file_content):
    # print(ET.dump(xml_file_content)
    assert (
        xml_file_content.find("weergegevens/verwachting_vandaag/tijdweerbericht").text
        == "Opgesteld op dinsdag 12 nov 2019 om 05:15"
    )
    assert bepaal_nl_weerteksten(xml_file_content) == {
        "weertijd": "Opgesteld op dinsdag 12 nov 2019 om 05:15",
        "weertitel": "Het is guur weer. De ene na de andere buienstoring passeert. Daarbij is het ook nog eens vrij koud voor de tijd van het jaar en waait het stevig.",
        "weertekst": "Het is guur weer. De ene na de andere buienstoring passeert. Daarbij is het ook nog eens vrij koud voor de tijd van het jaar en waait het stevig. Vanavond trekt een gebied met buien vanuit het westen over het land. Vooral langs de kust is daarbij kans op hagel en onweer. Ook kunnen vanavond windstoten optreden tot ongeveer 75 km/uur. Het koelt af naar 2 graden in het uiterste oosten en 5 graden aan zee. De wind waait uit een westelijke richting en is matig boven land. Aan de kust en op het IJsselmeer vrij krachtig tot krachtig. Op met name Texel en Vlieland kan het hard waaien met windkracht 7. Vannacht zijn er naast buien ook wat opklaringen. Vooral in het kustgebied is er nog kans op een klap onweer. Het koelt af tot een graad of 2 landinwaarts. Aan zee wordt het niet kouder dan 5 graden. Het blijft stevig waaien maar de zware windstoten verdwijnen. Morgen vallen er verspreid over het land nog enkele buien. Tussendoor laat de zon zich zien. Later in de middag en avond verdwijnen de meeste buien. Het wordt een graad of 7 langs de oostgrens. Aan de kust wordt het maximaal 9 of 10 graden. Daarmee is het iets minder koud dan vandaag. De zuidwesten wind neemt in de loop van de dag af en wordt matig van kracht. De dagen erna blijft het aan de wisselvallige kant. Donderdag verloopt in een groot deel van het land droog met geregeld zon. Met name in het zuidwesten is het bewolkt en valt er regen. Vrijdag maakt het hele land weer kans op neerslag. In de Limburgse heuvels kan dat zelfs wat natte sneeuw zijn. Overdag wordt het niet warmer dan 5 of 6 graden en is het waterkoud. In de nacht ligt de temperatuur dichtbij het vriespunt en bestaat er kans op vorst aan de grond. ",
        "weermiddellang": "Vrij koud weer met af en toe zon en iedere dag kans op regen of buien. Middagtemperatuur rond 7 graden en minima rond het vriespunt.",
        "weerlang": "Kans van 50% op overgang naar een minder wisselvallig weertype met temperaturen rond normaal. Er is een kleine kans op temperaturen (ruim) beneden normaal. ",
        "weerlangkop": "maandag 18 november 2019 tot vrijdag 22 november 2019",
        "weermiddellangkop": "woensdag 13 november 2019 tot zondag 17 november 2019",
    }


stationnr = "6280"  # Groningen


def test_xml_file_content_lokaal(xml_file_content):
    assert bepaal_lokale_weergegevens(stationnr, xml_file_content) == {
        "datum": "12/11/19 20:10",
        "dauwpunt_tekst": "dauwpunt",
        "dauwpunt_temp": 1.9,
        "iconactueel": "cc",
        "lat": "53.13",
        "lon": "6.58",
        "luchtvochtigheid": "85",
        "meetstation": "Meetstation Groningen",
        "regio": "Groningen",
        "tdelta": "9:00",
        "temperatuur_gc": "4.2",
        "windpijl": "↖",
        "windrichting": "ZZO",
        "windrichting_gr": "167",
        "windsnelheid_bf": "3",
        "windsnelheid_ms": "5.5",
        "zin": "Zwaar bewolkt",
        "zononder": "16:53",
        "zonopkomst": "7:53",
    }


def test_xml_file_station_list(xml_file_content):
    assert verwerk_station_data(xml_file_content) == [
        {"stationcode": "6240", "regio": "Amsterdam", "meetstation": "Schiphol"},
        {"stationcode": "6275", "regio": "Arnhem", "meetstation": "Arnhem"},
        {"stationcode": "6249", "regio": "Berkhout", "meetstation": "Berkhout"},
        {"stationcode": "6308", "regio": "Cadzand", "meetstation": "Cadzand"},
        {"stationcode": "6235", "regio": "Den Helder", "meetstation": "Den Helder"},
        {"stationcode": "6370", "regio": "Eindhoven", "meetstation": "Eindhoven"},
        {
            "stationcode": "6258",
            "regio": "Enkhuizen-Lelystad",
            "meetstation": "Houtribdijk",
        },
        {"stationcode": "6350", "regio": "Gilze Rijen", "meetstation": "Gilze Rijen"},
        {"stationcode": "6320", "regio": "Goeree", "meetstation": "LE Goeree"},
        {"stationcode": "6323", "regio": "Goes", "meetstation": "Goes"},
        {"stationcode": "6356", "regio": "Gorinchem", "meetstation": "Herwijnen"},
        {"stationcode": "6280", "regio": "Groningen", "meetstation": "Groningen"},
        {
            "stationcode": "6330",
            "regio": "Hoek van Holland",
            "meetstation": "Hoek van Holland",
        },
        {"stationcode": "6279", "regio": "Hoogeveen", "meetstation": "Hoogeveen"},
        {"stationcode": "6248", "regio": "Hoorn", "meetstation": "Wijdenes"},
        {"stationcode": "6209", "regio": "IJmond", "meetstation": "IJmond"},
        {"stationcode": "6225", "regio": "IJmuiden", "meetstation": "IJmuiden"},
        {"stationcode": "6270", "regio": "Leeuwarden", "meetstation": "Leeuwarden"},
        {"stationcode": "6269", "regio": "Lelystad", "meetstation": "Lelystad"},
        {"stationcode": "6380", "regio": "Maastricht", "meetstation": "Maastricht"},
        {"stationcode": "6324", "regio": "Midden-Zeeland", "meetstation": "Stavenisse"},
        {
            "stationcode": "6277",
            "regio": "Noord-Groningen",
            "meetstation": "Lauwersoog",
        },
        {"stationcode": "6273", "regio": "Noordoostpolder", "meetstation": "Marknesse"},
        {"stationcode": "6321", "regio": "Noordzee", "meetstation": "Euro platform"},
        {"stationcode": "6239", "regio": "Noordzee", "meetstation": "Zeeplatform F-3"},
        {"stationcode": "6252", "regio": "Noordzee", "meetstation": "Zeeplatform K13"},
        {
            "stationcode": "6286",
            "regio": "Oost-Groningen",
            "meetstation": "Nieuw Beerta",
        },
        {
            "stationcode": "6283",
            "regio": "Oost-Overijssel",
            "meetstation": "Groenlo-Hupsel",
        },
        {"stationcode": "6315", "regio": "Oost-Zeeland", "meetstation": "Hansweert"},
        {
            "stationcode": "6312",
            "regio": "Oosterschelde",
            "meetstation": "Oosterschelde",
        },
        {"stationcode": "6344", "regio": "Rotterdam", "meetstation": "Rotterdam"},
        {
            "stationcode": "6343",
            "regio": "Rotterdam Haven",
            "meetstation": "Rotterdam Geulhaven",
        },
        {"stationcode": "6316", "regio": "Schaar", "meetstation": "Schaar"},
        {
            "stationcode": "6285",
            "regio": "Schiermonnikoog",
            "meetstation": "Huibertgat",
        },
        {"stationcode": "6319", "regio": "Terneuzen", "meetstation": "Westdorpe"},
        {"stationcode": "6229", "regio": "Texel", "meetstation": "Texelhors"},
        {"stationcode": "6331", "regio": "Tholen", "meetstation": "Tholen"},
        {"stationcode": "6290", "regio": "Twente", "meetstation": "Twente"},
        {"stationcode": "6375", "regio": "Uden", "meetstation": "Volkel"},
        {"stationcode": "6260", "regio": "Utrecht", "meetstation": "De Bilt"},
        {"stationcode": "6391", "regio": "Venlo", "meetstation": "Arcen"},
        {"stationcode": "6242", "regio": "Vlieland", "meetstation": "Vlieland"},
        {"stationcode": "6310", "regio": "Vlissingen", "meetstation": "Vlissingen"},
        {"stationcode": "6215", "regio": "Voorschoten", "meetstation": "Voorschoten"},
        {"stationcode": "6251", "regio": "Wadden", "meetstation": "Hoorn Terschelling"},
        {"stationcode": "6377", "regio": "Weert", "meetstation": "Ell"},
        {"stationcode": "6267", "regio": "West-Friesland", "meetstation": "Stavoren"},
        {"stationcode": "6348", "regio": "West-Utrecht", "meetstation": "Lopik-Cabauw"},
        {
            "stationcode": "6313",
            "regio": "West-Zeeland",
            "meetstation": "Vlakte aan de Raan",
        },
        {"stationcode": "6257", "regio": "Wijk aan Zee", "meetstation": "Wijk aan Zee"},
        {"stationcode": "6340", "regio": "Woensdrecht", "meetstation": "Woensdrecht"},
        {"stationcode": "6278", "regio": "Zwolle", "meetstation": "Heino"},
    ]


def test_xml_file_week_voorspelling(xml_file_content):
    assert bepaal_voorspellingen(xml_file_content) == [
        {
            "icoon": "f",
            "dagweek": "wo",
            "datum": "13 nov",
            "mintemp": "4",
            "maxtemp": "8",
            "windrichting": "ZW",
            "windkracht": "4",
            "kansregen": "70",
        },
        {
            "icoon": "b",
            "dagweek": "do",
            "datum": "14 nov",
            "mintemp": "2",
            "maxtemp": "6",
            "windrichting": "ZO",
            "windkracht": "3",
            "kansregen": "30",
        },
        {
            "icoon": "q",
            "dagweek": "vr",
            "datum": "15 nov",
            "mintemp": "1",
            "maxtemp": "4",
            "windrichting": "NO",
            "windkracht": "4",
            "kansregen": "60",
        },
        {
            "icoon": "q",
            "dagweek": "za",
            "datum": "16 nov",
            "mintemp": "1",
            "maxtemp": "5",
            "windrichting": "ZW",
            "windkracht": "3",
            "kansregen": "60",
        },
        {
            "icoon": "q",
            "dagweek": "zo",
            "datum": "17 nov",
            "mintemp": "0",
            "maxtemp": "6",
            "windrichting": "NO",
            "windkracht": "3",
            "kansregen": "40",
        },
    ]


@pytest.fixture
def preticpation_file_content():
    buienrader_txt_file = os.path.join(
        os.path.dirname(os.path.abspath(__file__)), "preticpation.txt"
    )
    with open(buienrader_txt_file, "rb") as input:
        data = input.read()
    return data
