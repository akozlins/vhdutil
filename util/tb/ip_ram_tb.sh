#!/bin/bash

STOP_TIME_US=1 \
../sim.sh \
    ram_2rw_tb.vhd \
    ../*.vhd \
    ../quartus/*.vhd
