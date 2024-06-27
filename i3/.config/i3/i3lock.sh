#!/bin/bash

BLUR_RADIUS=5
BACKGROUND_COLOR=00000000
INSIDE_COLOR=00000000
WRONG_COLOR=f38ba8
GOOD_COLOR=f9e2af
RING_COLOR=cba6f7

INPUT_BACKGROUND_COLOR=FFFFFF
INPUT_FOREGROUND_COLOR=a6e3a1
TEXT_COLOR=4C4F69

i3lock --blur $BLUR_RADIUS \
       --color $BACKGROUND_COLOR \
       --inside-color=$INSIDE_COLOR \
       --ring-color=$RING_COLOR \
       --line-uses-inside \
       --keyhl-color=$INSIDE_COLOR \
       --ringver-color=$GOOD_COLOR \
       --ringwrong-color=$WRONG_COLOR \
       --insidever-color=$INSIDE_COLOR \
       --insidewrong-color=$INSIDE_COLOR \
       --radius 120 \
       --ring-width 20 \
       --time-color=ffffffc0 \
       --date-color=ffffffc0 \
       --greeter-color=ffffffc0 \
       --keyhl-color=ffffffc0 \
       --bshl-color=ffffffc0 \
       --time-size=40 \
       --date-size=20 \
       --greeter-size=20 \
       --greeter-pos="ix:iy-200" \
       --verif-color=ffffffc0 \
       --wrong-color=ff0000c0 \
       --modif-color=ff0000c0 \
       --layout-pos="ix:iy+400" \
       --indicator \
       --keyhl-color=$INPUT_FOREGROUND_COLOR \
       --bshl-color=$INPUT_FOREGROUND_COLOR
