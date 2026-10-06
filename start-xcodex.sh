#!/bin/bash
# start-xcodex.sh — Startet xcodex garantiert aus diesem Verzeichnis heraus.
#
# Hintergrund: Wird im Terminal einfach "xcodex" getippt (ohne "./" oder
# vollen Pfad), sucht die Shell über $PATH — dabei kann eine ältere,
# systemweit installierte Version (z. B. /usr/local/bin/xcodex aus einem
# früheren PKG-Install) VOR dieser hier gefunden werden. batch.json neben
# diesem Ordner würde dann von der falschen, alten Version ignoriert.
#
# Dieses Script wechselt zuerst in sein eigenes Verzeichnis und übergibt den
# Pfad zur batch.json zusätzlich explizit per "-b<Pfad>" — unabhängig von der
# automatischen Erkennung "neben dem Binary".
#
# Verwendung: ./start-xcodex.sh   (im Finder auch per Doppelklick startbar)

set -e
cd "$(dirname "$0")"
exec ./xcodex -b"$(pwd)/batch.json" "$@"
