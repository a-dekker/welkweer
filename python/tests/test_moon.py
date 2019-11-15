from moon import get_moon_phase
from freezegun import freeze_time


@freeze_time("2019-10-30 8:35:01")
def test_moon_phase():
    assert get_moon_phase() == {"text": "Nieuwe maan", "symbol": "🌕"}
