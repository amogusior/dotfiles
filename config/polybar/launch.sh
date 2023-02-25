killall -q polybar

echo "---" | tee -a /tmp/polybar1.log
polybar main 2>&1 | tee -a /tmp/polybar1.log & disown
polybar btm 2>&1 | tee -a /tmp/polybar2.log & disown
echo "Bars launched..."
