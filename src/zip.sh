#!/bin/sh
./pack.pl
cp comp/terrain.png terrain.png
zip hgpack.zip terrain.png
mkdir gui
cp comp/items.png gui/items.png
zip hgpack.zip gui/items.png
rm terrain.png
rm -r gui
