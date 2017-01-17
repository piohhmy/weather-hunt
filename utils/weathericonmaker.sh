#!/bin/sh
base=$1

if [ -z $base ]
  then
    echo No argument given
else
  file=$(basename $base)
  filename="${file%.*}"
  echo "Creating icons for ${filename}.png"
  ##
  ## Map Icons 20pt
  convert -density 200 "$base" -trim -resize 20x     "${filename}.png"
  convert -density 200 "$base" -trim -resize 40x     "${filename}@2x.png"
  convert -density 200 "$base" -trim -resize 60x     "${filename}@3x.png"

  ## Drawer Icons 100pt
  convert -density 1000 -background none "$base" -trim -resize 100x  "${filename}-big.png"
  convert -density 1000 -background none "$base" -trim -resize 200x  "${filename}-big@2x.png"
  convert -density 1000 -background none "$base" -trim -resize 300x  "${filename}-big@3x.png"
fi 

