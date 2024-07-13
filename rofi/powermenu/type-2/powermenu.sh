#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Power Menu
#
## Available Styles
#
## style-1   style-2   style-3   style-4   style-5
## style-6   style-7   style-8   style-9   style-10

# Current Theme
dir="$HOME/.config/rofi/powermenu/type-2"
theme='style-5'

# CMDs
uptime="`uptime -p | sed -e 's/up //g'`"
host=`hostname`

# Options
shutdown=''
reboot=''
logout=''
suspend='󰒲'

# Rofi CMD
rofi_cmd() {
    rofi -dmenu \
        -p "Uptime: $uptime" \
        -mesg "Uptime: $uptime" \
        -theme ${dir}/${theme}.rasi
}

# Variable passed to rofi
options="$logout\n$shutdown\n$reboot\n$suspend"

chosen="$(echo -e "$options" | rofi_cmd)"

case $chosen in
    $shutdown)
        sudo shutdown -h now
        ;;
    $reboot)
        sudo shutdown -r now
        ;;
    $logout)
        hyprlock
        ;;
    $suspend)
        sudo zzz 
        ;;
esac
