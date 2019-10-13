import pytest

from buienradar import (
    get_dew_point_c,
    reformat_text,
    redefine_windrichting,
    strip_date,
    reformat_date,
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
