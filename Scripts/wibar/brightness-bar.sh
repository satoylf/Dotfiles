#!/bin/zsh

# Variables
DOT=""
D="·"
BAR=""
TOTAL_BALLS=10  # Número total de bolinhas na barra
MAX_BRIGHTNESS=$(cat /sys/class/backlight/intel_backlight/max_brightness)
CURRENT_BRIGHTNESS=$(cat /sys/class/backlight/intel_backlight/actual_brightness)
INCREMENT=$(( MAX_BRIGHTNESS / TOTAL_BALLS ))  # Incremento para cada bolinha

# Calcula o número de bolinhas a serem exibidas com base no brilho atual
NUM_BALLS=$(( CURRENT_BRIGHTNESS / INCREMENT ))

# Cria a barra com as bolinhas
for ((i = 0; i < TOTAL_BALLS; i++)); do
    if [ $i -lt NUM_BALLS ]; then
        BAR+=$DOT
    else
        BAR+=$D
    fi
done
echo "$BAR"
