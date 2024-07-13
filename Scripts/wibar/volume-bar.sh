#!/bin/zsh

# Variables
MIN_VOL=10  # Define o volume mínimo desejado
MAX_VOL=110  # Define o volume máximo desejado
DOT=""
D="·"
BAR=""
TARGET=""

# Function to return volume bar
return_bar() {
    local VOL=$(amixer get Master | grep -o -m 1 '[0-9]\{1,3\}%')
    local VOL=${VOL%\%}
    local BAR=""
    local DOT=""
    local D="·"
    local STEP=$(( (MAX_VOL - MIN_VOL) / 10 ))  # Calcula o intervalo entre cada marcador
    local COUNT=$(( (VOL - MIN_VOL) / STEP ))  # Calcula o número de marcadores
    for ((i = 0; i < COUNT; i++)); do
        BAR+=$DOT
    done
    for ((i = COUNT; i < 10; i++)); do
        BAR+=$D
    done
    echo "$BAR"
}

# Output volume bar
return_bar
