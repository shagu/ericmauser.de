# mplayer
## youtube

package: 
    youtube-dl (git), mplayer

usage:
    mplayer -cache 2048 `youtube-dl "$1" -g` 2>&1

## webcam

package: 
    mplayer (use flag: v4l2)

record:
    mencoder -tv driver=v4l2:fps=25:height=600:width=800 -ovc raw -vf scale=800:600 -o $1 tv:// -nosound

view:
    mplayer tv:// -tv driver=v4l2:width=800:height=600:device=/dev/video0
