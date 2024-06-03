#!/bin/bash

# Fonction pour lancer Polybar sur tous les moniteurs détectés
launch_polybar() {
  killall -q polybar
  # polybar-msg cmd quit

  while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

  for monitor in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$monitor polybar --reload base_polybar &
  done
}

if type "xrandr" > /dev/null; then
  launch_polybar
else
  polybar --reload base_polybar &
fi
