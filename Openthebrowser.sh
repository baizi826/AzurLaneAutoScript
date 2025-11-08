#!/bin/bash
sleep 5
open http://127.0.0.1:22267
osascript -e 'tell application "Terminal" to close first window' & exit