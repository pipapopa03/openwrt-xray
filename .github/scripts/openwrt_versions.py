#!/usr/bin/env python3
"""Печатает последние точечные релизы OpenWrt для N свежих веток (через пробел).

usage: openwrt_versions.py [N]
Источник: https://downloads.openwrt.org/.versions.json
Пропускает rc/snapshot, из каждой ветки X.Y берёт максимальный X.Y.Z.
"""
import json
import re
import sys
import urllib.request

n = int(sys.argv[1]) if len(sys.argv) > 1 else 2

with urllib.request.urlopen("https://downloads.openwrt.org/.versions.json", timeout=30) as r:
    data = json.load(r)

candidates = list(data.get("versions_list", []))
for key in ("stable_version", "oldstable_version"):
    if data.get(key):
        candidates.append(data[key])

best = {}
for v in candidates:
    m = re.fullmatch(r"(\d+)\.(\d+)\.(\d+)", str(v))
    if not m:
        continue
    t = tuple(int(x) for x in m.groups())
    series = t[:2]
    if series not in best or t > best[series][0]:
        best[series] = (t, v)

versions = [best[s][1] for s in sorted(best)[-n:]]
if not versions:
    sys.exit("no OpenWrt versions found in .versions.json")
print(" ".join(versions))
