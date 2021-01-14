FROM ubuntu:bionic

USER root

RUN dpkg --add-architecture i386
RUN apt-get update --yes
RUN apt-get install --yes \
    libstdc++6:i386 \
    libcurl4-gnutls-dev:i386 \
    lib32z1 \
    lib32ncurses5 \
    libbz2-1.0:i386 \
    lib32gcc1 \
    gdb \
    python-pip \
    wget \
    unzip \
    curl


RUN curl https://public.gameye.com/binaries/igniter-shell/v2.0.4/amd64/linux/igniter-shell.tar.gz | tar --extract --gzip --directory /usr/local/bin/

RUN pip install awscli

RUN useradd --create-home --uid 2000 steam

USER steam
WORKDIR /home/steam

RUN curl --location "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar --extract --gzip
RUN ./steamcmd.sh \
    +login anonymous \
    +force_install_dir /home/steam/csgo \
    +app_update 740 validate \
    +quit

WORKDIR /home/steam/csgo/csgo

RUN wget https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git971-linux.tar.gz && \
    tar zxvf mmsource-1.10.7-git971-linux.tar.gz && \
    wget https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6502-linux.tar.gz && \
    tar zxvf sourcemod-1.10.0-git6502-linux.tar.gz

RUN wget https://github.com/splewis/get5/releases/download/0.7.1/get5_0.7.1.zip && \
    unzip get5_0.7.1.zip

RUN chmod -R 775 addons cfg

WORKDIR /home/steam/csgo/

COPY --chown=steam:steam ./config /home/steam/config
COPY --chown=steam:steam ./entrypoint.sh /home/steam/entrypoint.sh
COPY --chown=steam:steam ./version.sh /home/steam/version.sh
ENTRYPOINT ["/home/steam/entrypoint.sh"]
