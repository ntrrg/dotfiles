#!/bin/sh

set -xeo pipefail

riverctl default-layout wideriver

wideriver \
	--layout left \
	--layout-alt monocle \
	--stack even \
	--count-master 1 \
	--ratio-master 0.50 \
	--count-wide-left 1 \
	--ratio-wide 0.50 \
	--no-smart-gaps \
	--inner-gaps 5 \
	--outer-gaps 5 \
	--border-width 2 \
	--border-width-monocle 0 \
	--border-width-smart-gaps 0 \
	--border-color-focused "" \
	--border-color-focused-monocle "" \
	--border-color-unfocused "" \
	--log-threshold warning \
	> "$XDG_RUNTIME_DIR/wideriver.log" 2>&1 &

riverctl send-layout-cmd wideriver "--layout left"
riverctl map layout None Up send-layout-cmd wideriver "--count +1"
riverctl map layout Alt Up send-layout-cmd wideriver ""
riverctl map layout Shift Up send-layout-cmd wideriver ""
riverctl map layout None Right send-layout-cmd wideriver "--ratio +0.025"
riverctl map layout Alt Right send-layout-cmd wideriver "--ratio +0.005"
riverctl map layout Shift Right send-layout-cmd wideriver "--ratio +0.05"
riverctl map layout None Down send-layout-cmd wideriver "--count -1"
riverctl map layout Alt Down send-layout-cmd wideriver ""
riverctl map layout Shift Down send-layout-cmd wideriver ""
riverctl map layout None Left send-layout-cmd wideriver "--ratio -0.025"
riverctl map layout Alt Left send-layout-cmd wideriver "--ratio -0.005"
riverctl map layout Shift Left send-layout-cmd wideriver "--ratio -0.05"

riverctl map layout Alt+Shift Up spawn "
	riverctl send-layout-cmd wideriver '--layout top' &&
	riverctl map layout None Up send-layout-cmd wideriver '--ratio -0.025' &&
	riverctl map layout Alt Up send-layout-cmd wideriver '--ratio -0.005' &&
	riverctl map layout Shift Up send-layout-cmd wideriver '--ratio -0.05' &&
	riverctl map layout None Right send-layout-cmd wideriver '--count -1' &&
	riverctl map layout Alt Right send-layout-cmd wideriver '' &&
	riverctl map layout Shift Right send-layout-cmd wideriver '' &&
	riverctl map layout None Down send-layout-cmd wideriver '--ratio +0.025' &&
	riverctl map layout Alt Down send-layout-cmd wideriver '--ratio +0.005' &&
	riverctl map layout Shift Down send-layout-cmd wideriver '--ratio +0.05' &&
	riverctl map layout None Left send-layout-cmd wideriver '--count +1' &&
	riverctl map layout Alt Left send-layout-cmd wideriver '' &&
	riverctl map layout Shift Left send-layout-cmd wideriver ''
"

riverctl map layout Alt+Shift Right spawn "
	riverctl send-layout-cmd wideriver '--layout right' &&
	riverctl map layout None Up send-layout-cmd wideriver '--count -1' &&
	riverctl map layout Alt Up send-layout-cmd wideriver '' &&
	riverctl map layout Shift Up send-layout-cmd wideriver '' &&
	riverctl map layout None Right send-layout-cmd wideriver '--ratio -0.025' &&
	riverctl map layout Alt Right send-layout-cmd wideriver '--ratio -0.005' &&
	riverctl map layout Shift Right send-layout-cmd wideriver '--ratio -0.05' &&
	riverctl map layout None Down send-layout-cmd wideriver '--count +1' &&
	riverctl map layout Alt Down send-layout-cmd wideriver '' &&
	riverctl map layout Shift Down send-layout-cmd wideriver '' &&
	riverctl map layout None Left send-layout-cmd wideriver '--ratio +0.025' &&
	riverctl map layout Alt Left send-layout-cmd wideriver '--ratio +0.005' &&
	riverctl map layout Shift Left send-layout-cmd wideriver '--ratio +0.05'
"

riverctl map layout Alt+Shift Down spawn "
	riverctl send-layout-cmd wideriver '--layout bottom' &&
	riverctl map layout None Up send-layout-cmd wideriver '--ratio +0.025' &&
	riverctl map layout Alt Up send-layout-cmd wideriver '--ratio +0.005' &&
	riverctl map layout Shift Up send-layout-cmd wideriver '--ratio +0.05' &&
	riverctl map layout None Right send-layout-cmd wideriver '--count +1' &&
	riverctl map layout Alt Right send-layout-cmd wideriver '' &&
	riverctl map layout Shift Right send-layout-cmd wideriver '' &&
	riverctl map layout None Down send-layout-cmd wideriver '--ratio -0.025' &&
	riverctl map layout Alt Down send-layout-cmd wideriver '--ratio -0.005' &&
	riverctl map layout Shift Down send-layout-cmd wideriver '--ratio -0.05' &&
	riverctl map layout None Left send-layout-cmd wideriver '--count -1' &&
	riverctl map layout Alt Left send-layout-cmd wideriver '' &&
	riverctl map layout Shift Left send-layout-cmd wideriver ''
"

riverctl map layout Alt+Shift Left spawn "
	riverctl send-layout-cmd wideriver '--layout left' &&
	riverctl map layout None Up send-layout-cmd wideriver '--count +1' &&
	riverctl map layout Alt Up send-layout-cmd wideriver '' &&
	riverctl map layout Shift Up send-layout-cmd wideriver '' &&
	riverctl map layout None Right send-layout-cmd wideriver '--ratio +0.025' &&
	riverctl map layout Alt Right send-layout-cmd wideriver '--ratio +0.005' &&
	riverctl map layout Shift Right send-layout-cmd wideriver '--ratio +0.05' &&
	riverctl map layout None Down send-layout-cmd wideriver '--count -1' &&
	riverctl map layout Alt Down send-layout-cmd wideriver '' &&
	riverctl map layout Shift Down send-layout-cmd wideriver '' &&
	riverctl map layout None Left send-layout-cmd wideriver '--ratio -0.025'&&
	riverctl map layout Alt Left send-layout-cmd wideriver '--ratio -0.005' &&
	riverctl map layout Shift Left send-layout-cmd wideriver '--ratio -0.05'
"

riverctl map layout Alt+Shift Return spawn "
	riverctl send-layout-cmd wideriver '--layout wide' &&
	riverctl map layout None Up send-layout-cmd wideriver '--count +1' &&
	riverctl map layout Alt Up send-layout-cmd wideriver '' &&
	riverctl map layout Shift Up send-layout-cmd wideriver '' &&
	riverctl map layout None Right send-layout-cmd wideriver '--ratio +0.025' &&
	riverctl map layout Alt Right send-layout-cmd wideriver '--ratio +0.005' &&
	riverctl map layout Shift Right send-layout-cmd wideriver '--ratio +0.05' &&
	riverctl map layout None Down send-layout-cmd wideriver '--count -1' &&
	riverctl map layout Alt Down send-layout-cmd wideriver '' &&
	riverctl map layout Shift Down send-layout-cmd wideriver '' &&
	riverctl map layout None Left send-layout-cmd wideriver '--ratio -0.025'&&
	riverctl map layout Alt Left send-layout-cmd wideriver '--ratio -0.005' &&
	riverctl map layout Shift Left send-layout-cmd wideriver '--ratio -0.05'
"

riverctl map normal Alt F10 send-layout-cmd wideriver "--layout-toggle"
riverctl map normal Alt+Shift F10 send-layout-cmd wideriver "--layout monocle"
