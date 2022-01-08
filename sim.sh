#!/bin/sh
set -eux

export STOPTIME=64us

exec \
./util/sim.sh $1 tb/$1.vhd \
    util/*.vhd \
    cpu/*.vhd \
    rv/*.vhd
