#!/bin/sh
set -euf

dev=$1

if [ ! -e "/sys/bus/pci/devices/$dev" ]; then
    exit 1
fi

port=$(dirname -- "$(readlink -e -- "/sys/bus/pci/devices/$dev")")

echo 1 > "/sys/bus/pci/devices/$dev/remove"
sleep 1
echo 1 > "$port/rescan"

lspci -vv -s "$dev"
