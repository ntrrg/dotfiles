#!/bin/sh

set -xeo pipefail

riverctl default-layout rivertile
rivertile -view-padding 5 -outer-padding 5 &

riverctl send-layout-cmd rivertile "main-location left"
riverctl map layout None Up send-layout-cmd rivertile "main-count +1"
riverctl map layout Alt Up send-layout-cmd rivertile ""
riverctl map layout Shift Up send-layout-cmd rivertile ""
riverctl map layout None Right send-layout-cmd rivertile "main-ratio +0.025"
riverctl map layout Alt Right send-layout-cmd rivertile "main-ratio +0.005"
riverctl map layout Shift Right send-layout-cmd rivertile "main-ratio +0.05"
riverctl map layout None Down send-layout-cmd rivertile "main-count -1"
riverctl map layout Alt Down send-layout-cmd rivertile ""
riverctl map layout Shift Down send-layout-cmd rivertile ""
riverctl map layout None Left send-layout-cmd rivertile "main-ratio -0.025"
riverctl map layout Alt Left send-layout-cmd rivertile "main-ratio -0.005"
riverctl map layout Shift Left send-layout-cmd rivertile "main-ratio -0.05"

riverctl map layout Alt+Shift Up spawn "
	riverctl send-layout-cmd rivertile 'main-location top' &&
	riverctl map layout None Up send-layout-cmd rivertile 'main-ratio -0.025' &&
	riverctl map layout Alt Up send-layout-cmd rivertile 'main-ratio -0.005' &&
	riverctl map layout Shift Up send-layout-cmd rivertile 'main-ratio -0.05' &&
	riverctl map layout None Right send-layout-cmd rivertile 'main-count -1' &&
	riverctl map layout Alt Right send-layout-cmd rivertile '' &&
	riverctl map layout Shift Right send-layout-cmd rivertile '' &&
	riverctl map layout None Down send-layout-cmd rivertile 'main-ratio +0.025' &&
	riverctl map layout Alt Down send-layout-cmd rivertile 'main-ratio +0.005' &&
	riverctl map layout Shift Down send-layout-cmd rivertile 'main-ratio +0.05' &&
	riverctl map layout None Left send-layout-cmd rivertile 'main-count +1' &&
	riverctl map layout Alt Left send-layout-cmd rivertile '' &&
	riverctl map layout Shift Left send-layout-cmd rivertile ''
"

riverctl map layout Alt+Shift Right spawn "
	riverctl send-layout-cmd rivertile 'main-location right' &&
	riverctl map layout None Up send-layout-cmd rivertile 'main-count -1' &&
	riverctl map layout Alt Up send-layout-cmd rivertile '' &&
	riverctl map layout Shift Up send-layout-cmd rivertile '' &&
	riverctl map layout None Right send-layout-cmd rivertile 'main-ratio -0.025' &&
	riverctl map layout Alt Right send-layout-cmd rivertile 'main-ratio -0.005' &&
	riverctl map layout Shift Right send-layout-cmd rivertile 'main-ratio -0.05' &&
	riverctl map layout None Down send-layout-cmd rivertile 'main-count +1' &&
	riverctl map layout Alt Down send-layout-cmd rivertile '' &&
	riverctl map layout Shift Down send-layout-cmd rivertile '' &&
	riverctl map layout None Left send-layout-cmd rivertile 'main-ratio +0.025' &&
	riverctl map layout Alt Left send-layout-cmd rivertile 'main-ratio +0.005' &&
	riverctl map layout Shift Left send-layout-cmd rivertile 'main-ratio +0.05'
"

riverctl map layout Alt+Shift Down spawn "
	riverctl send-layout-cmd rivertile 'main-location bottom' &&
	riverctl map layout None Up send-layout-cmd rivertile 'main-ratio +0.025' &&
	riverctl map layout Alt Up send-layout-cmd rivertile 'main-ratio +0.005' &&
	riverctl map layout Shift Up send-layout-cmd rivertile 'main-ratio +0.05' &&
	riverctl map layout None Right send-layout-cmd rivertile 'main-count +1' &&
	riverctl map layout Alt Right send-layout-cmd rivertile '' &&
	riverctl map layout Shift Right send-layout-cmd rivertile '' &&
	riverctl map layout None Down send-layout-cmd rivertile 'main-ratio -0.025' &&
	riverctl map layout Alt Down send-layout-cmd rivertile 'main-ratio -0.005' &&
	riverctl map layout Shift Down send-layout-cmd rivertile 'main-ratio -0.05' &&
	riverctl map layout None Left send-layout-cmd rivertile 'main-count -1' &&
	riverctl map layout Alt Left send-layout-cmd rivertile '' &&
	riverctl map layout Shift Left send-layout-cmd rivertile ''
"

riverctl map layout Alt+Shift Left spawn "
	riverctl send-layout-cmd rivertile 'main-location left' &&
	riverctl map layout None Up send-layout-cmd rivertile 'main-count +1' &&
	riverctl map layout Alt Up send-layout-cmd rivertile '' &&
	riverctl map layout Shift Up send-layout-cmd rivertile '' &&
	riverctl map layout None Right send-layout-cmd rivertile 'main-ratio +0.025' &&
	riverctl map layout Alt Right send-layout-cmd rivertile 'main-ratio +0.005' &&
	riverctl map layout Shift Right send-layout-cmd rivertile 'main-ratio +0.05' &&
	riverctl map layout None Down send-layout-cmd rivertile 'main-count -1' &&
	riverctl map layout Alt Down send-layout-cmd rivertile '' &&
	riverctl map layout Shift Down send-layout-cmd rivertile '' &&
	riverctl map layout None Left send-layout-cmd rivertile 'main-ratio -0.025'&&
	riverctl map layout Alt Left send-layout-cmd rivertile 'main-ratio -0.005' &&
	riverctl map layout Shift Left send-layout-cmd rivertile 'main-ratio -0.05'
"
