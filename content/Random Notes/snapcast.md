# snapcast

## laptop

    apt-get install pulseaudio-module-raop paprefs

## mpd

    audio_output {
        type            "fifo"
        name            "Snapcast"
        path            "/tmp/snapfifo"
        format          "48000:16:2"
        mixer_type      "software"
    }

    systemctl restart mpd
    systemctl enable mpd

## shairport-sync

    apt-get install shairport-sync avahi-daemon

    vim /etc/shairport-sync.conf
    general = {
      name = "Full House";
      output_backend = "pipe";
      mdns_backend = "avahi";
    };

    metadata = {
      enabled = "yes";
      include_cover_art = "yes";
      pipe_name = "/tmp/shairport-sync-metadata";
    }

    sessioncontrol = {
      allow_session_interruption = "yes";
      session_timeout = 20;
    }

    pipe = {
      name = "/tmp/snapfifo";
      audio_backend_buffer_desired_length = 48000;
    }

    systemctl restart shairport-sync
    systemctl enable shairport-sync

## snapclient

    wget https://github.com/badaix/snapcast/releases/download/v0.12.0/snapclient_0.12.0_armhf.deb
    dpkg -i snapclient_0.12.0_armhf.deb

/etc/default/snapclient:

    # defaults file for snapclient

    # start snapclient automatically?
    START_SNAPCLIENT=true

    # Allowed options:
    #   --help                          produce help message
    #   -v, --version                   show version number
    #   -h, --host arg                  server hostname or ip address
    #   -p, --port arg (=1704)          server port
    #   -l, --list                      list pcm devices
    #   -s, --soundcard arg (=default)  index or name of the soundcard
    #   -d, --daemon [=arg(=-3)]        daemonize, optional process priority [-20..19]
    #   --user arg                      the user[:group] to run snapclient as when daemonized
    #   --latency arg (=0)              latency of the soundcard
    #   -i, --instance arg (=1)         instance id

    USER_OPTS="--user eric:audio"

    SNAPCLIENT_OPTS="-h server"

enable everything:

    systemctl restart snapclient
    systemctl enable snapclient
