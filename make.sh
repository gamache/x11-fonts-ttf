#!/bin/sh
set -e

FONTS_DIR="${FONTS_DIR:-/usr/share/fonts/X11/misc}"
if [ ! -d "$FONTS_DIR" ]
then
  echo "Can't find X11 fonts. Set FONTS_DIR to its full pathname."
  exit 1
fi

BITS_N_PICAS_JAR="${BITS_N_PICAS_JAR:-BitsNPicas.jar}"
if [ ! -f "$BITS_N_PICAS_JAR" ]
then
  echo "Can't find BitsNPicas.jar. Set BITS_N_PICAS_JAR to its full pathname."
  exit 1
fi

PCF2BDF="${PCF2BDF:-pcf2bdf}"
w=`which $PCF2BDF`
if [ "x$w" = "x" ]
then
  echo "Can't find pcf2bdf. Set PCF2BDF to its full pathname."
  exit 1
fi

cp $FONTS_DIR/*.pcf.gz .
gunzip -f *.gz

for f in `ls *.pcf`
do
  pcf2bdf -o "${f%.*}".bdf "$f"
done

for f in `ls *.bdf`
do
  ff="${f%.*}"
  mkdir "$ff"
  cd "$ff"
  java -jar "$BITS_N_PICAS_JAR" convertbitmap -f ttf ../"$f"
  mv "$(ls *.ttf)" ../"$ff"-"$(ls *.ttf)"
  cd ..
  rmdir "$ff"
done

rm *.pcf *.bdf

