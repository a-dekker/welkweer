"""Imported by pyside"""

import datetime
from math import fmod


# def get_moon_phase() -> dict[str, str]:
def get_moon_phase():
    """Return the current moon phase."""
    now = datetime.date.today()  # datetime.timedelta(-3)
    new_moon = datetime.date(2012, 1, 23)
    cycle = 29.530588853
    phase_length = cycle / 8

    diff = (now - new_moon).days
    ldays = fmod(diff + phase_length / 3, cycle)
    current_phase = ldays * (8 / cycle)

    lunar_fases: dict = {
        0: "Nieuwe maan",
        1: "Wassende maan",
        2: "Eerste kwartier",
        3: "Wassende maan",
        4: "Volle maan",
        5: "Afnemende maan",
        6: "Laatste kwartier",
        7: "Krimpende maan",
    }

    lunar_fases_symbol: dict = {
        0: "🌕",
        1: "🌖",
        2: "🌗",
        3: "🌘",
        4: "🌑",
        5: "🌒",
        6: "🌓",
        7: "🌔",
    }

    lunar_info: dict = {}
    lunar_info["text"] = lunar_fases[int(current_phase)]
    lunar_info["symbol"] = lunar_fases_symbol[int(current_phase)]

    return lunar_info
