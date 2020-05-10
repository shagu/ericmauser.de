# Custom Screen Resolution

A small bash function to add custom screen resolutions - that are not detected automatically - to your display. Add the following to the `~/.bashrc`:

    function resolution {
      if [ -z "$1" ] || [ -z "$2" ]; then
        echo "USAGE:"
        echo "  resolution WIDTH HEIGHT [DISPLAY]"
      else
        settings=$(cvt $1 $2 | sed -n 's/^.*"\(.*\)"\(.*\)$/\1,\2/p')
        name=$(echo "$settings" | cut -d , -f 1)
        opts=$(echo "$settings" | cut -d , -f 2)

        if [ -z "$3" ]; then
          display=$(xrandr | sed -n "s/\(.*\) connected.*/\1/p" | head -n 1)
        else
          display=$3
        fi

        xrandr --newmode "$name" $opts
        xrandr --addmode $display "$name"
      fi
    }

Usage: `resolution WIDTH HEIGHT [DISPLAY]`
Example: `resolution 800 600 eDP-1`
