#!/usr/bin/env bash
# Terminate already running bar instances
# If all your bars have ipc enabled, you can use
# Otherwise you can use the nuclear option:
killall -q polybar

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log
polybar main 2>&1 | tee -a /tmp/polybar1.log & disown
#echo "---" | tee -a /tmp/polybar2.log
#polybar one 2>&1 | tee -a /tmp/polybar2.log & disown
#echo "---" | tee -a /tmp/polybar3.log
#polybar two 2>&1 | tee -a /tmp/polybar3.log & disown
#echo "---" | tee -a /tmp/polybar4.log
#polybar spot 2>&1 | tee -a /tmp/polybar4.log & disown
#echo "Bars launched..."
