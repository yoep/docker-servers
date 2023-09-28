#!/bin/bash

echo "--- Wine Info ---"
echo "Using wine version $(wine --version)"
echo "Using winetricks version $(winetricks --version)"
echo "---"

Xvfb :1 -screen 0 1024x768x16 &
DISPLAY=:1 WINEDEBUG=-all WINEPREFIX="${WINE_LOCATION}" winetricks sound=disabled
DISPLAY=:1 WINEDEBUG=-all WINEPREFIX="${WINE_LOCATION}" winetricks corefonts
DISPLAY=:1 WINEDEBUG=-all WINEPREFIX="${WINE_LOCATION}" winetricks -q vcrun2019
DISPLAY=:1 WINEDEBUG=-all WINEPREFIX="${WINE_LOCATION}" winetricks -q --force dotnet48