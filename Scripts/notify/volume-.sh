#!/bin/zsh

VOL=$(pamixer --get-volume)

if [ "$VOL" -gt 0 ]; then
    NEW_VOL=$((VOL - 10))

    if [ "$NEW_VOL" -lt 0 ]; then
        NEW_VOL=0
    fi

    pactl set-sink-volume @DEFAULT_SINK@ "$NEW_VOL%"

    pkill -RTMIN+10 dwmblocks

    notify-send -t 925 "Volume: $NEW_VOL%"
fi
