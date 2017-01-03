#!/bin/sh
base=$1

if [ -z $base ]
  then
    echo No argument given
else
  ##
  ## Notifications 20pt
  convert "$base" -resize 20x20!     "Icon-20.png"
  convert "$base" -resize 40x40!     "Icon-20@2x.png"
  convert "$base" -resize 60x60!     "Icon-20@3x.png"

  ## Settings 29pt
  convert "$base" -resize 29x29!     "Icon-29.png"
  convert "$base" -resize 58x58!     "Icon-29@2x.png"
  convert "$base" -resize 87x87!     "Icon-29@3x.png"

  ## Spotlight 40pt
  convert "$base" -resize 40x40!     "Icon-40.png"
  convert "$base" -resize 80x80!     "Icon-40@2x.png"
  convert "$base" -resize 120x120!   "Icon-40@3x.png"

  ## iPhone App 60pt
  convert "$base" -resize 120x120!   "Icon-60@2x.png"
  convert "$base" -resize 180x180!   "Icon-60@3x.png"

  ## iPad App 76pt
  convert "$base" -resize 76x76!     "Icon-76.png"
  convert "$base" -resize 152x152!   "Icon-76@2x.png"
  
  ## iPad Pro App 83.5pt
  convert "$base" -resize 167x167!   "Icon-83.5@2x.png"
 fi 

