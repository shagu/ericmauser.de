# CMaNGOS Classic Quick Install Instructions
## Server

    mkdir server
    cd server/
    git clone git://github.com/cmangos/mangos-classic.git
    cd mangos-classic/
    mkdir build
    cd build/
    cmake .. -DBUILD_EXTRACTORS=1 -DCMAKE_INSTALL_PREFIX=../out
    make
    make install
    cd ..
    ln -sf mangosd.conf.dist out/etc/mangosd.conf
    ln -sf realmd.conf.dist out/etc/realmd.conf
    ln -sf playerbot.conf.dist out/etc/playerbot.conf

## Client Data

    cp out/bin/tools/* /tmp/WoW-1.12.1-enUS/
    cd /tmp/WoW-1.12.1-enUS/
    chmod +x ExtractResources.sh
    ./ExtractResources.sh
    cd -
    cp -rf /tmp/WoW-1.12.1-enUS/{maps,dbc,vmaps,mmaps,Cameras} out/bin

# Database

    mysql -uroot -p < sql/create/db_create_mysql.sql
    mysql -uroot -p classicmangos < sql/base/mangos.sql

    for sql_file in $(ls sql/base/dbc/original_data/*.sql); do mysql -uroot -p --database=classicmangos < $sql_file ; done
    for sql_file in $(ls sql/base/dbc/cmangos_fixes/*.sql); do mysql -uroot -p --database=classicmangos < $sql_file ; done

    mysql -uroot -p classiccharacters < sql/base/characters.sql
    mysql -uroot -p classicrealmd < sql/base/realmd.sql

    git clone git://github.com/cmangos/classic-db.git
    cd classic-db
    ./InstallFullDB.sh; vim InstallFullDB.config
    ./InstallFullDB.sh

# launch

    cd out/bin
    ./realmd &
    ./mangosd
