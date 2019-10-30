# Install Trinity Core on Debian/Ubuntu

## Other Guides
- [How-to_Linux](http://collab.kpsn.org/display/tc/How-to_Linux)
- [How-to_First_step_into_Trinity_Core](http://collab.kpsn.org/display/tc/How-to_First_step_into_Trinity_Core)

## Sources

- [server](git://github.com/TrinityCore/TrinityCore.git) 
- [database](http://www.trinitycore.org/f/files/download/5-tdb-full-updates/)

## Install dependencies

    sudo apt-get install build-essential autoconf libtool gcc g++ make cmake git-core patch wget links zip unzip unrar
    sudo apt-get install openssl libssl-dev libmysqlclient15-dev libmysql++-dev libreadline6-dev zlib1g-dev libbz2-dev libncurses5-dev libace-dev

## Build the Server

    git clone git://github.com/TrinityCore/TrinityCore.git 
    mkdir TrinityCore/build
    cd TrinityCore/build
    cmake ../ -DSERVERS=1 -DTOOLS=1 -DPREFIX=/home/trinity/server -DSCRIPTS=1
    make -j5
    make install

## Build Library for Map extraction

    sudo apt-get install automake1.10
    cd ~/TrinityCore/dep/libmpq/
    sh ./autogen.sh
    ./configure
    make
    sudo make install

## Map Generation

    cd <your WoW client directory>
    mkdir vmaps mmaps
    /home/<username>/server/bin/mapextractor
    /home/<username>/server/bin/vmap4extractor
    /home/<username>/server/bin/vmap4assembler Buildings vmaps
    cp Buildings/* ./vmaps
    /home/<username>/server/bin/mmaps_generator
    cp dbc maps mmaps vmaps /home/<username>/server/data

## Database

    mysql -u root -p < ./TrinityCore/sql/create/create_mysql.sql
    mysql -u root -p auth < ./TrinityCore/sql/base/auth_database.sql 
    mysql -u root -p characters < ./TrinityCore/sql/base/characters_database.sql

    mysql -u root -p world < ./path/to/your/tdb.sql
    cd ./TrinityCore/sql/updates/world
    for i in *; do mysql -u trinity --password=trinity world < $i; done

## Configure

    cp worldserver.conf.dist worldserver.conf
    cp authserver.conf.dist authserver.conf

**worldserver.conf:**

    LoginDatabaseInfo = "127.0.0.1;3306;trinity;trinity;auth"
    WorldDatabaseInfo = "127.0.0.1;3306;trinity;trinity;world"
    CharacterDatabaseInfo = "127.0.0.1;3306;trinity;trinity;characters"

    vmap.enableLOS = 1
    vmap.enableHeight = 1
    vmap.petLOS = 1
    vmap.enableIndoorCheck = 1
    mmap.enablePathFinding = 0

**authserver.conf:**

    LoginDatabaseInfo = "127.0.0.1;3306;trinity;trinity;auth"

## Start Server
    cd ./server/data
    ../bin/authserver
    ../bin/worldserver

## Add Accounts
    account create <user> <pass>
    account set gmlevel <user> 3 -1

## GM Commands
check quests:
    .lookup quest <questname>
    .quest complete <questid>
