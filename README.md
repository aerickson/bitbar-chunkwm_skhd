# bitbar-chunkwm_skhd
A simple bitbar for [chunkwm](https://github.com/koekeishiya/chunkwm)/[skhd](https://github.com/koekeishiya/skhd). See [here](https://github.com/matryer/bitbar#installing-plugins) for installation.

## changes by aerickson

- indicates if chunkwm is running or not
- indicates current desktop mode
- designed to support https://github.com/koekeishiya/chunkwm/pull/519
  - issues update requests when commands are run
- focus more on chunkwm (vs skhd)
  - may add back as configuration option

![current look](https://content.evernote.com/shard/s74/sh/4181b659-9e1b-494d-aebc-a7b825760a10/e876c91950b088e4/res/6403b129-9733-4500-bf1f-215046131ead/skitch.png)

### installation

- if using https://github.com/koekeishiya/chunkwm/pull/519:
  - symlink into your bitbar plugin directory as `chunkwm.5m.sh`
- otherwise
  - symlink into your bitbar plugin directory as `chunkwm.1s.sh`
