# irssi notify for awesome

## irssi plugin
**~/.irssi/scripts/autorun/awnotify.pl:**

    use strict;
    use Irssi;
   
    sub hilight {
	    my ($dest, $text, $stripped) = @_;
	    if ($dest->{level} & MSGLEVEL_HILIGHT) {
		    filewrite($dest->{target}. " " .$stripped );
	    }
    }
   
    sub filewrite {
	    my ($text) = @_;
	    $text =~ s/\n/ /;
	    $text =~ s/[<@&]//g;
   
	    my @values = split(' ', $text, 4);
   
	    `echo '$values[1] $values[3]' >> /var/tmp/irssi-notify`;
	    `notify-send '<span color="#aaaaaa">$values[1]</span> $values[3]'`;
    }
   
    sub del_notify {
	    `echo > /var/tmp/irssi-notify`;
    }
   
    Irssi::signal_add_last("print text", "hilight");
    Irssi::signal_add('gui key pressed', 'del_notify');

## notify-daemon
**~/.config/autorun/awnotify.sh:**

    #/bin/sh 
    while true; do
    echo -n `echo "irssiwidget.text = ' [<span color=\"#aaaaaa\">im </span><span color=\"#ffffff\">"``cat /var/tmp/irssi-notify | grep -c ">"`"</span>] '"  | awesome-client
    sleep 1
    done &


## awesome-config
**~/.config/awesome/rc.lua:**

    irssiwidget = widget({ type = "textbox" })
    mywibox[s].widgets = { 
	    [...]
	    irssiwidget,
	    [...]
    }
