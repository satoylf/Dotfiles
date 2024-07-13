#!/bin/bash

SCREENSHOT_DIR=~/Imagens/Screenshots
FILENAME=$(date +%Y-%m-%d_%H-%M-%S_ss.png)
SCREENSHOT_PATH="$SCREENSHOT_DIR/$FILENAME"

grim -g "$(slurp)" "$SCREENSHOT_PATH"

wl-copy < "$SCREENSHOT_PATH"
