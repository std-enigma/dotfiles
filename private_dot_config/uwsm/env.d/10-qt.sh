#!/usr/bin/env sh

# Let Qt6 applications follow qt6ct (which can load a Kvantum/colour scheme).
QT_QPA_PLATFORMTHEME="${QT_QPA_PLATFORMTHEME:-qt6ct}"
export QT_QPA_PLATFORMTHEME
