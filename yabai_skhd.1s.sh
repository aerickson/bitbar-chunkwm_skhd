#!/bin/bash

# <bitbar.title>yabai/skhd helper</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Shi Han NG</bitbar.author>
# <bitbar.author.github>shihanng</bitbar.author.github>
# <bitbar.desc>Plugin that displays desktop id and desktop mode of yabai.</bitbar.desc>
# <bitbar.dependencies>brew,yabai,skhd</bitbar.dependencies>

# Info about yabai, see: https://github.com/koekeishiya/yabai
# For skhd, see: https://github.com/koekeishiya/skhd

function refreshBB {
  open -g 'bitbar://refreshPlugin?name=yabai.*?.sh'
}

export PATH=/usr/local/bin:$PATH

# CURRENT_MODE=$(brew services list | grep yabai | grep started | grep -v grep  2>&1)
# if [ -z "$CURRENT_MODE" ]; then
#   # echo "\$var is empty"
#   CHUNK_STATE='stopped'
#   MODE_EMOJI="?"
# else
#   # echo "\$var is NOT empty"
#   CHUNK_STATE='running'
#   MODE_EMOJI="⧄"  
# fi

CURRENT_MODE=$(yabai -m query --spaces --space | jq .type  2>&1)
case $CURRENT_MODE in
  'yabai: connection failed!')
    CHUNK_STATE='running'
    MODE=''
    MODE_TOGGLE='none'
    MODE_EMOJI="?"
    ;;
  '"bsp"')
    CHUNK_STATE='running'
    MODE='bsp'
    MODE_TOGGLE='float'
    MODE_EMOJI='⊞'
    ;;
  '"float"')
    MODE='float'
    CHUNK_STATE='running'
    MODE_TOGGLE='bsp'
    MODE_EMOJI='⧉'
    ;;
  *)
    echo "$CURRENT_MODE"
    CHUNK_STATE='stopped'
    MODE_EMOJI="⧄"
    ;;
esac

# TODO: see if ffm plugin is loaded so we can have single FFM menu entry
PLUGINS_LOADED=$(yabai core::query --plugins loaded  2>&1)
case $PLUGINS_LOADED in
  *ffm.so*)
    FFM_ENABLED='yes'
    ;;
  *)
    FFM_ENABLED='no'
    ;;
esac

#
# command handlers
#
# SLEEP_TIME=0.5
SLEEP_TIME=1
if [[ "$1" = "stop" ]]; then
  brew services stop yabai
  brew services stop skhd
  refreshBB
elif [[ "$1" = "start_chunk" ]]; then
  brew services start yabai
  sleep $SLEEP_TIME
  refreshBB
elif [[ "$1" = "restart_chunk" ]]; then
  brew services restart yabai
  # yabai isn't ready for queries right away after restarting, wait a bit
  # sleep $SLEEP_TIME
  refreshBB
elif [[ "$1" = "stop_chunk" ]]; then
  brew services stop yabai
  refreshBB
elif [[ "$1" = "restart_both" ]]; then
  brew services restart yabai
  brew services restart skhd
  refreshBB
elif [[ "$1" = "dfocus" ]]; then
  yabai core::unload ffm.so
  sleep 0.2
  refreshBB
elif [[ "$1" = "efocus" ]]; then
  yabai core::load ffm.so
  sleep 0.2
  refreshBB
elif [[ "$1" = "toggle" ]]; then
  yabai -m space --layout $MODE_TOGGLE
  refreshBB
elif [[ "$1" = "bsp" ]]; then
  yabai -m space --layout bsp
  refreshBB
elif [[ "$1" = "float" ]]; then
  yabai -m space --layout float
  refreshBB  
elif [[ "$1" = "equalize" ]]; then
  yabai tiling::desktop --equalize
  refreshBB
else
  #
  # display block
  #
  if [[ "$CHUNK_STATE" = "running" ]]; then
    # echo "y ${MODE_EMOJI}"
    # TODO: hide display of desktop id behind flag?
    echo "y ${MODE_EMOJI} $(yabai -m query --spaces --space | jq .index) | length=5"
    # echo "y ${MODE_EMOJI} $(yabai tiling::query --desktop id)"
  else
    echo "y ${MODE_EMOJI}"
  fi
  echo "---"
  if [[ "$CHUNK_STATE" = "running" ]]; then
    # TODO: selector for all 3 modes?
    echo "Desktop Mode: ${MODE}"
    # echo "BSP | bash='$0' param1=bsp terminal=false"
    # echo "Float | bash='$0' param1=float terminal=false"
    echo "Toggle Layout | bash='$0' param1=toggle terminal=false"
    # echo "Equalize Windows | bash='$0' param1=equalize terminal=false"
    # if [[ "$FFM_ENABLED" = "yes" ]]; then
    #   echo "Disable FFM | bash='$0' param1=dfocus terminal=false"
    # else
    #   echo "Enable FFM | bash='$0' param1=efocus terminal=false" 
    # fi
    echo "---"
  fi

  echo "yabai: $CHUNK_STATE"
  # if [[ "$CHUNK_STATE" = "running" ]]; then
  echo "Restart yabai | bash='$0' param1=restart_chunk terminal=false"
  #   echo "Stop yabai | bash='$0' param1=stop_chunk terminal=false"
  # else
  #   echo "Start yabai | bash='$0' param1=start_chunk terminal=false"
  # fi
  # TODO: add back in control of skhd? behind a flag or option?

fi
