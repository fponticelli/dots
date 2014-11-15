#!/bin/sh
set -e
rm -f dots.zip
zip -r dots.zip src test extraParams.hxml haxelib.json LICENSE README.md
haxelib submit dots.zip