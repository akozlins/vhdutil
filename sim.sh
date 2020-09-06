#!/bin/sh
set -eux

STOPTIME=64us

exec \
./util/sim.sh $1 tb/$1.vhd \
    util/*.vhd \
    cpu/*.vhd \
    rv/*.vhd
