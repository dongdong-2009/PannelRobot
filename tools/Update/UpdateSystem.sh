#! /bin/sh
tar xJvf usr.tar.xz -C /
${PWD}/UpdateGUI update_cmd -qws

sync

reboot
