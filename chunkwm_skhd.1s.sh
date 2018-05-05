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
case $CURRENT_MODE in
  'bsp')
    MODE_TOGGLE='monocle'
    MODE_EMOJI='⊞'
    ;;
  'monocle')
    MODE_TOGGLE='bsp'
    MODE_EMOJI='⧈'
    ;;
esac

if [[ "$1" = "stop" ]]; then
  brew services stop chunkwm
  brew services stop skhd
elif [[ "$1" = "restart" ]]; then
  brew services restart chunkwm
  brew services restart skhd
elif [[ "$1" = "toggle" ]]; then
  chunkc tiling::desktop --layout $MODE_TOGGLE
elif [[ "$1" = "equalize" ]]; then
  chunkc tiling::desktop --equalize
else
  echo "$(chunkc tiling::query --desktop id):${MODE_EMOJI} | length=5"
  echo "---"
  echo "Toggle layout | bash='$0' param1=toggle terminal=false"
  echo "Equalize windows | bash='$0' param1=equalize terminal=false"
  echo "---"
  echo "Restart chunkwm & skhd | bash='$0' param1=restart terminal=false"
  echo "Stop chunkwm & skhd | bash='$0' param1=stop terminal=false"
fi
