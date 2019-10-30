# Gnome
## Gsettings

    # enable fractional scaling on wayland
    gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"

    # enable debugger
    gsettings set org.gtk.Settings.Debug enable-inspector-keybinding true

    # touchpad and mouse settings
    gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing false
    gsettings set org.gnome.desktop.peripherals.touchpad click-method 'areas'
    gsettings set org.gnome.desktop.wm.preferences resize-with-right-button true
    gsettings set org.gnome.desktop.wm.preferences mouse-button-modifier '<Alt>'

    # behaviour and appearance
    gsettings set org.gnome.desktop.wm.preferences button-layout ':minimize,maximize,close'
    gsettings set org.gtk.Settings.FileChooser sort-directories-first true
    gsettings set org.gnome.nautilus.preferences recursive-search "never"
    gsettings set org.gnome.shell.overrides attach-modal-dialogs false

    # disable automount
    gsettings set org.gnome.desktop.media-handling automount 'false'
    gsettings set org.gnome.desktop.media-handling automount-open 'false' 

    # disable system sounds
    gsettings set org.gnome.desktop.sound event-sounds false

    # epiphany settings
    gsettings set org.gnome.Epiphany default-search-engine 'Google'
    gsettings set org.gnome.Epiphany homepage-url 'about:blank'

    # terminal settings
    gsettings set org.gnome.Terminal.Legacy.Settings theme-variant 'dark'
    gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false
    gsettings set org.gnome.Terminal.Legacy.Settings confirm-close false

    # enable night shift
    gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 5500
    gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true

    # keybinds
    gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Terminal'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'gnome-terminal'
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>1'
    gsettings set org.gnome.settings-daemon.plugins.media-keys www '<Super>2'
    gsettings set org.gnome.settings-daemon.plugins.media-keys home '<Super>3'

    gsettings set org.gnome.desktop.wm.keybindings close "['<Alt>c']"
    gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Alt>v']"
    gsettings set org.gnome.desktop.wm.keybindings minimize "['<Alt>s']"
    gsettings set org.gnome.desktop.wm.keybindings toggle-fullscreen "['<Alt>f']"
    gsettings set org.gnome.desktop.wm.keybindings always-on-top "['<Alt>t']"

    for i in $(seq 1 9); do gsettings set org.gnome.shell.keybindings switch-to-application-$i "['<Super><Shift>$i']"; done

## Terminal Internal Padding

add the following to ~/.config/gtk-3.0/gtk.css:

     TerminalScreen {
       -VteTerminal-inner-border: 10px 10px 10px 10px;
     }

## Terminal Force Quit

This removes the "really-quit" dialog on gnome-terminal:

    gconftool-2 --set --type bool /apps/gnome-terminal/global/confirm_window_close false

# Terminal: Scroll in GNU/Screen
into ~/.screenrc:

    # enable scrolling
    termcapinfo xterm ti@:te@
    # bind page up/down
    bindkey -m "^[[5;2~" stuff ^b
    bindkey -m "^[[6;2~" stuff ^f 
