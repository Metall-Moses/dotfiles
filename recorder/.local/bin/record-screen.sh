#!/usr/bin/env bash
if pgrep -x "wf-recorder"; then
  pkill -INT -x wf-recorder
else
  wf-recorder -g "$(slurp)" -f "$HOME/Videos/recording_$(date +'%Y%m%d_%H%M%S').mp4"
fi
