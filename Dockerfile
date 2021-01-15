FROM ubuntu:bionic

# install prerequisites for the game
RUN dpkg --add-architecture i386
RUN apt-get update --yes ; \
    apt-get install --yes \
    libstdc++6:i386 \
    libcurl4-gnutls-dev:i386 \
    lib32z1 \
    lib32ncurses5 \
    libbz2-1.0:i386 \ 
    lib32gcc1 \
    gdb \
    curl \
    unzip ; \
    apt-get clean


# add game user (steam in this case)
RUN useradd --create-home --uid 2000 steam
USER steam
WORKDIR /home/steam

# install csgo!
RUN curl \
    --location --silent \
    "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | \
    tar --extract --gzip --directory /home/steam/
RUN ./steamcmd.sh \
    +login anonymous \
    +force_install_dir /home/steam/csgo/ \
    +app_update 740 validate \
    +quit

# install igniter
RUN curl \
    --location --silent \
    "https://public.gameye.com/binaries/igniter-shell/v2.0.4/amd64/linux/igniter-shell.tar.gz" | \
    tar --extract --gzip --directory /usr/local/bin/

# install some plugins
RUN curl \
    --location --silent \
    "https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git971-linux.tar.gz" | \
    tar --extract --gzip --directory /home/steam/csgo/csgo/
RUN curl \
    --location --silent \
    "https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6502-linux.tar.gz" | \
    tar --extract --gzip --directory /home/steam/csgo/csgo/
RUN curl \
    --location --silent \
    "https://github.com/splewis/get5/releases/download/0.7.1/get5_0.7.1.zip" \
    --output /tmp/get5_0.7.1.zip ; \
    unzip /tmp/get5_0.7.1.zip -d /home/steam/csgo/csgo/ ; \
    rm /tmp/get5_0.7.1.zip

# copy files and directories
COPY --chown=steam:steam ./config /home/steam/config
COPY --chown=steam:steam ./entrypoint.sh /home/steam/entrypoint.sh
COPY --chown=steam:steam ./version.sh /home/steam/version.sh

# setup entrypoint
ENTRYPOINT ["/home/steam/entrypoint.sh"]
