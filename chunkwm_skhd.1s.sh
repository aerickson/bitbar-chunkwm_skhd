#!/bin/bash

# <bitbar.title>chunkwm/skhd helper</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Shi Han NG</bitbar.author>
# <bitbar.author.github>shihanng</bitbar.author.github>
# <bitbar.desc>Plugin that displays desktop id and desktop mode of chunkwm.</bitbar.desc>
# <bitbar.dependencies>brew,chunkwm,skhd</bitbar.dependencies>

# Info about chunkwm, see: https://github.com/koekeishiya/chunkwm
# For skhd, see: https://github.com/koekeishiya/skhd

export PATH=/usr/local/bin:$PATH
CURRENT_MODE=$(chunkc tiling::query --desktop mode  2>&1)
case $CURRENT_MODE in
  'chunkc: connection failed!')
    CHUNK_STATE='off'
    MODE=''
    MODE_TOGGLE='none'
    MODE_EMOJI="⧄"
    ;;
  'bsp')
    CHUNK_STATE='on'
    MODE='bsp'
    MODE_TOGGLE='float'
    MODE_EMOJI='⊞'
    ;;
  'float')
    MODE='float'
    CHUNK_STATE='on'
    MODE_TOGGLE='bsp'
    MODE_EMOJI='⧉'
    ;;
esac

#
# command handlers
# 
if [[ "$1" = "stop" ]]; then
  brew services stop chunkwm
  brew services stop skhd
elif [[ "$1" = "stop_chunk" ]]; then
  brew services stop chunkwm
elif [[ "$1" = "restart_chunk" ]]; then
  brew services restart chunkwm
elif [[ "$1" = "restart_both" ]]; then
  brew services restart chunkwm
  brew services restart skhd
elif [[ "$1" = "dfocus" ]]; then
  chunkc core::unload ffm.so
elif [[ "$1" = "efocus" ]]; then
  chunkc core::load ffm.so
elif [[ "$1" = "toggle" ]]; then
  chunkc tiling::desktop --layout $MODE_TOGGLE
elif [[ "$1" = "equalize" ]]; then
  chunkc tiling::desktop --equalize
else
  #
  # display block
  #
  if [[ "$CHUNK_STATE" = "on" ]]; then
    echo "c ${MODE_EMOJI}"
    # TODO: hide display of desktop id behind flag?
    # echo "c ${MODE_EMOJI}:$(chunkc tiling::query --desktop id) | length=5"
  else
    echo "c ${MODE_EMOJI}"
  fi
  echo "---"
  if [[ "$CHUNK_STATE" = "on" ]]; then
    # TODO: selector for all 3 modes?
    echo "Desktop Mode: ${MODE}"
    echo "Toggle Layout | bash='$0' param1=toggle terminal=false"
    echo "Equalize Windows | bash='$0' param1=equalize terminal=false"
    # TODO: figure out how to make this a toggle (add query command or detect somehow)
    echo "Focus Follows Mouse"
    echo "--Enable FFM | bash='$0' param1=efocus terminal=false" 
    echo "--Disable FFM | bash='$0' param1=dfocus terminal=false"
    echo "---"
  fi

  echo "chunkwm: $CHUNK_STATE"
  if [[ "$CHUNK_STATE" = "on" ]]; then
    echo "Restart chunkwm | bash='$0' param1=restart_chunk terminal=false"
    echo "Stop chunkwm | bash='$0' param1=stop_chunk terminal=false"
  else
    echo "Start chunkwm | bash='$0' param1=restart_chunk terminal=false"
  fi
  # TODO: add back in control of skhd? behind a flag or option?

fi
