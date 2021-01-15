#!/bin/sh

grep \
    --perl-regexp \
    --only-matching \
    '(?<=^PatchVersion=)\S*' \
    /home/steam/csgo/csgo/steam.inf
