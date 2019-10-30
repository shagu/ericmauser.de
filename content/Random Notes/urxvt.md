# URxvt
## Copy & Paste

Support for Ctrl-Shift-C and Ctrl-Shift-V in (u)rxvt.
install: `xsel` and download the clipboard perl script:

    wget https://github.com/muennich/urxvt-perls/raw/master/clipboard -O /usr/lib/urxvt/perl/clipboard 

.Xdefaults:

	URxvt.perl-ext-common: default,matcher,clipboard
	URxvt.keysym.Shift-Control-C: perl:clipboard:copy
	URxvt.keysym.Shift-Control-V: perl:clipboard:paste

## instant color-change
Using `printf` to instantly swithc colors within rxvt-unicode:

change cursor color (blue):

    printf '\33]12;12\007'

change background color (dark-grey):

    printf '\33]11;%s\007' "#333333"

### auto-change
Automatically switch colors based on the last ran process in `zsh`.
**.zshrc:**

    appearance() {
	    if (( EUID != 0 )); then
		    printf '\33]12;12\007' # blue user cursor
	    else
		    printf '\33]12;9\007' # red root cursor
	    fi
    }
    appearance

    su() {
	    [ -n "$1" ]
		    printf '\33]12;8\007' # changes cursor color
		    /bin/su $@
		    appearance
    }

    ssh() {
	    [ -n "$1" ]
		    printf '\33]12;10\007' # changes cursor colo
		    /usr/bin/ssh $@
		    appearance
    }

    chroot() {
	    [ -n "$1" ]
		    printf '\33]12;13\007' # changes cursor color	
		    /bin/chroot $@
		    appearance
    }

# Change window title

    echo -en "\033]0;"$@"\a"

