#!/bin/bash

# <bitbar.title>chunkwm/skhd helper</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Shi Han NG</bitbar.author>
# <bitbar.author.github>shihanng</bitbar.author.github>
# <bitbar.desc>Plugin that displays desktop id and desktop mode of chunkwm.</bitbar.desc>
# <bitbar.dependencies>brew,chunkwm,skhd</bitbar.dependencies>

# Info about chunkwm, see: https://github.com/koekeishiya/chunkwm
# For skhd, see: https://github.com/koekeishiya/skhd

function refreshBB {
  open -g 'bitbar://refreshPlugin?name=chunkwm.*?.sh'
}

export PATH=/usr/local/bin:$PATH
CURRENT_MODE=$(chunkc tiling::query --desktop mode  2>&1)
case $CURRENT_MODE in
  'chunkc: connection failed!')
    CHUNK_STATE='stopped'
    MODE=''
    MODE_TOGGLE='none'
    MODE_EMOJI="⧄"
    ;;
  'bsp')
    CHUNK_STATE='running'
    MODE='bsp'
    MODE_TOGGLE='float'
    MODE_EMOJI='⊞'
    ;;
  'float')
    MODE='float'
    CHUNK_STATE='running'
    MODE_TOGGLE='bsp'
    MODE_EMOJI='⧉'
    ;;
  *)
    CHUNK_STATE='stopped'
    ;;
esac

# TODO: see if ffm plugin is loaded so we can have single FFM menu entry
PLUGINS_LOADED=$(chunkc core::query --plugins loaded  2>&1)
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
  brew services stop chunkwm
  brew services stop skhd
  refreshBB
elif [[ "$1" = "start_chunk" ]]; then
  brew services start chunkwm
  sleep $SLEEP_TIME
  refreshBB
elif [[ "$1" = "restart_chunk" ]]; then
  brew services restart chunkwm
  # chunkwm isn't ready for queries right away after restarting, wait a bit
  # sleep $SLEEP_TIME
  refreshBB
elif [[ "$1" = "stop_chunk" ]]; then
  brew services stop chunkwm
  refreshBB
elif [[ "$1" = "restart_both" ]]; then
  brew services restart chunkwm
  brew services restart skhd
  refreshBB
elif [[ "$1" = "dfocus" ]]; then
  chunkc core::unload ffm.so
  sleep 0.2
  refreshBB
elif [[ "$1" = "efocus" ]]; then
  chunkc core::load ffm.so
  sleep 0.2
  refreshBB
elif [[ "$1" = "toggle" ]]; then
  chunkc tiling::desktop --layout $MODE_TOGGLE
  refreshBB
elif [[ "$1" = "equalize" ]]; then
  chunkc tiling::desktop --equalize
  refreshBB
else
  #
  # display block
  #
  if [[ "$CHUNK_STATE" = "running" ]]; then
    #echo "c ${MODE_EMOJI}"
    # TODO: hide display of desktop id behind flag?
    #echo "c ${MODE_EMOJI} $(chunkc tiling::query --desktop id) | length=5"
    echo "c ${MODE_EMOJI} $(chunkc tiling::query --desktop id)"
  else
    echo "c ${MODE_EMOJI}"
  fi
  echo "---"
  if [[ "$CHUNK_STATE" = "running" ]]; then
    # TODO: selector for all 3 modes?
    echo "Desktop Mode: ${MODE}"
    echo "Toggle Layout | bash='$0' param1=toggle terminal=false"
    echo "Equalize Windows | bash='$0' param1=equalize terminal=false"
    if [[ "$FFM_ENABLED" = "yes" ]]; then
      echo "Disable FFM | bash='$0' param1=dfocus terminal=false"
    else
      echo "Enable FFM | bash='$0' param1=efocus terminal=false" 
    fi
    echo "---"
  fi

  echo "chunkwm: $CHUNK_STATE"
  if [[ "$CHUNK_STATE" = "running" ]]; then
    echo "Restart chunkwm | bash='$0' param1=restart_chunk terminal=false"
    echo "Stop chunkwm | bash='$0' param1=stop_chunk terminal=false"
  else
    echo "Start chunkwm | bash='$0' param1=start_chunk terminal=false"
  fi
  # TODO: add back in control of skhd? behind a flag or option?

fi
