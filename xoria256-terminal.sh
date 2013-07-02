#!/bin/sh
#
# Shell script that configures gnome-terminal to use xoria256 theme
# colors. Written for Debian Wheezy.
#
#    AUTHOR: Igor Kalnitsky <igor@kalnitsky.org>
#   LICENSE: GNU GPL v3
 
PALETTE="#121212121212:#D7D787878787:#AFAFD7D78787:#F7F7F7F7AFAF:#8787AFAFD7D7:#D7D7AFAFD7D7:#AFAFD7D7D7D7:#E6E6E6E6E6E6:#121212121212:#D7D787878787:#AFAFD7D78787:#F7F7F7F7AFAF:#8787AFAFD7D7:#D7D7AFAFD7D7:#AFAFD7D7D7D7:#E6E6E6E6E6E6"
BG_COLOR="#1C1C1C1C1C1C"
FG_COLOR="#E6E6E6E6E6E6"
 
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/use_theme_background" --type bool false
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/use_theme_colors" --type bool false
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/palette" --type string "$PALETTE"
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/background_color" --type string "$BG_COLOR"
gconftool-2 --set "/apps/gnome-terminal/profiles/Default/foreground_color" --type string "$FG_COLOR"
