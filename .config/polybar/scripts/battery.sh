#!/bin/bash

bat0_status="$(cat /sys/class/power_supply/BAT0/status | cut -c 1)"
bat1_status="$(cat /sys/class/power_supply/BAT1/status | cut -c 1)"
capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
capacity2="$(cat /sys/class/power_supply/BAT1/capacity)"

# echo -n "${capacity}% ($bat0_status)  ${capacity2}% ($bat1_status)"
echo -n "$(echo "(${capacity}+${capacity2})/2" | bc | xargs)% ${bat0_status}${bat1_status}"
