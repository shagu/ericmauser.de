# Cinnamon
## Gsettings
update: since version 2.0+ cinnamon is using its own config strings, 
the gnome settings from above will not work anymore
update: cinnamon 2.6.x changed the gsetting paths (keybindings updated)

show settings:
    gsettings list-recursively org.cinnamon.desktop.media-handling

deactivate automount:
    gsettings set org.cinnamon.desktop.media-handling automount 'false'
    gsettings set org.cinnamon.desktop.media-handling automount-open 'false' 

desktop font:
    gsettings set org.nemo.desktop font 'Sans 8'

keyboard shortcuts:
    gsettings set org.cinnamon.desktop.keybindings.media-keys screensaver "['<Super>l']"
    gsettings set org.cinnamon.desktop.keybindings.media-keys terminal "['<Super>1']"
    gsettings set org.cinnamon.desktop.keybindings.media-keys www "['<Super>2']"
    gsettings set org.cinnamon.desktop.keybindings.media-keys home "['<Super>3']"
    gsettings set org.cinnamon.desktop.keybindings.wm panel-run-dialog "['<Super>0']"
    gsettings set org.cinnamon.desktop.keybindings.wm minimize "['<Alt>s']"
    gsettings set org.cinnamon.desktop.keybindings.wm close "['<Alt>c']"
    gsettings set org.cinnamon.desktop.keybindings.wm toggle-maximized "['<Alt>v']"
    gsettings set org.cinnamon.desktop.keybindings.wm toggle-fullscreen "['<Alt>f']"
    gsettings set org.cinnamon.desktop.keybindings.wm move-to-workspace-left "['<Shift><Alt>Left']"
    gsettings set org.cinnamon.desktop.keybindings.wm move-to-workspace-right "['<Shift><Alt>Right']"
    gsettings set org.cinnamon.desktop.keybindings.wm switch-to-workspace-1 "['<Alt>F1']"
    gsettings set org.cinnamon.desktop.keybindings.wm switch-to-workspace-2 "['<Alt>F2']"
    gsettings set org.cinnamon.desktop.keybindings.wm switch-to-workspace-3 "['<Alt>F3']"
    gsettings set org.cinnamon.desktop.keybindings.wm switch-to-workspace-4 "['<Alt>F4']"
    gsettings set org.cinnamon.desktop.keybindings.wm switch-to-workspace-5 "['<Alt>F5']"
    gsettings set org.cinnamon.desktop.keybindings.wm switch-to-workspace-down "['<Control><Alt>Down']"
    gsettings set org.cinnamon.desktop.keybindings.wm switch-to-workspace-up "['<Control><Alt>Up']"
    gsettings set org.cinnamon.desktop.keybindings.wm switch-to-workspace-left "['<Control><Alt>Left']"
    gsettings set org.cinnamon.desktop.keybindings.wm switch-to-workspace-right "['<Control><Alt>Right']"
    gsettings set org.cinnamon.desktop.keybindings.wm move-to-workspace-1 "['<Alt><Shift>F1']"
    gsettings set org.cinnamon.desktop.keybindings.wm move-to-workspace-2 "['<Alt><Shift>F2']"
    gsettings set org.cinnamon.desktop.keybindings.wm move-to-workspace-3 "['<Alt><Shift>F3']"
    gsettings set org.cinnamon.desktop.keybindings.wm move-to-workspace-4 "['<Alt><Shift>F4']"
    gsettings set org.cinnamon.desktop.keybindings.wm move-to-workspace-5 "['<Alt><Shift>F5']"

## Change Desktop Colors
This is to change the desktop text color in Cinnamon, 
simply edit in your gtk CSS file the nemo desktop settings.

    ~/.config/gtk-3.0/gtk.css:
    .nemo-desktop.nemo-canvas-item {
      color: #CCCCCC;
      text-shadow: 1px 1px @desktop_item_text_shadow;
    }

## Systray Icon Size
the tray icon size is defined in: /usr/share/cinnamon/applets/systray@cinnamon.org/applet.js
