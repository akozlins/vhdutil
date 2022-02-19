#!/bin/bash

STOP_TIME_US=1 \
../sim.sh \
    tb_fifo_sc.vhd \
    ../*.vhd \
    ../quartus/*.vhd
