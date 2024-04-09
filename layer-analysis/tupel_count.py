# -*- coding: utf-8 -*-
from collections import Counter
from itertools import combinations
from datenbank import daten

# Umwandlung der Daten in alle möglichen 3-Tupel Kombinationen mit ihren Häufigkeiten
drei_tupel_haeufigkeiten = Counter()

for kombination, anzahl in daten.items():
    if len(kombination) >= 3:  # Nur Kombinationen betrachten, die mindestens 3 Elemente enthalten
        for drei_tupel in combinations(kombination, 3):
            drei_tupel_haeufigkeiten[drei_tupel] += anzahl

# Die häufigsten 3-Tupel finden
haeufigste_drei_tupel = drei_tupel_haeufigkeiten.most_common()

for tupel in haeufigste_drei_tupel:
    print(tupel)
