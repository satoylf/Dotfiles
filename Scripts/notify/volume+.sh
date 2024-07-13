#!/bin/zsh

VOL=$(pamixer --get-volume)

if [ "$VOL" -lt 100 ]; then
    NEW_VOL=$((VOL + 10))

    if [ "$NEW_VOL" -gt 100 ]; then
        NEW_VOL=100
    fi
    pactl set-sink-volume @DEFAULT_SINK@ "$NEW_VOL%"

    pkill -RTMIN+10 dwmblocks

    notify-send -t 925 "Volume: $NEW_VOL%"
fi
