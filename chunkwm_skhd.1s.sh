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
CURRENT_MODE=$(chunkc tiling::query --desktop mode)
# TODO: if not running only show options that make sense?
case $CURRENT_MODE in
  'failed')
    CHUNK_STATE='off'
    ;;
  'bsp')
    CHUNK_STATE='on'
    MODE_TOGGLE='float'
    MODE_EMOJI='⊞'
    ;;
  'float')
    CHUNK_STATE='on'
    MODE_TOGGLE='bsp'
    MODE_EMOJI='⧉'
    ;;
esac

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
  if [[ "$CHUNK_STATE" = "on" ]]; then
    echo "$(chunkc tiling::query --desktop id):${MODE_EMOJI} | length=5"
  else
    echo "chunkwm"
  fi
  echo "---"
  echo "Toggle layout | bash='$0' param1=toggle terminal=false"
  echo "Equalize windows | bash='$0' param1=equalize terminal=false"
  echo "Enable focus follows mouse | bash='$0' param1=efocus terminal=false" 
  echo "Disable focus follows mouse | bash='$0' param1=dfocus terminal=false"
  # if [[ "$CHUNK_STATE" = "on" ]]; then
  #   echo "---"
  # fi
  echo "---"
  echo "STATE: $CHUNK_STATE"
  echo "Restart chunkwm | bash='$0' param1=restart_chunk terminal=false"
  if [[ "$CHUNK_STATE" = "on" ]]; then
      echo "Stop chunkwm | bash='$0' param1=stop_chunk terminal=false"  
  fi
  echo "---"
  echo "Restart chunkwm & skhd | bash='$0' param1=restart terminal=false"
  echo "Stop chunkwm & skhd | bash='$0' param1=stop terminal=false"
fi
