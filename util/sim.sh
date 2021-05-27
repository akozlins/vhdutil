#!/bin/bash
set -euf

if [ $# -eq 0 ] ; then
    echo "Usage: $0 tb [entity.vhd]..."
    exit
fi

TB="$1"
shift

SRC=()
for arg in "$@" ; do
    arg=$(realpath -s --relative-to=.cache -- "$arg")
    SRC+=("$arg")
done

# elaboration options
OPTS=(
    # vhdl standard (default is '93c', '08' is VHDL-2008 standard)
    --std=08
    # supply packages defined by ieee (std_logic_1164, numeric_bit and and numeric_std)
    --ieee=standard
    # when two operators are overloaded, give preference to the explicit declaration
    -fexplicit
    # allow the use of synopsys non-standard packages (std_logic_arith, std_logic_signed, std_logic_unsigned, std_logic_textio)
    -fsynopsys
    # allow UTF8 chars in comments
    --mb-comments
    # enable parsing of PSL assertions within comments
    -fpsl
)

# directories to be searched for library files
DIRS=(
    "/usr/local/lib/ghdl/vendors/altera"
    "$HOME/.local/share/ghdl/vendors/altera"
)
for arg in "${DIRS[@]}" ; do
    [ -d "$arg" ] && OPTS+=(-P"$arg")
done

# simulation options
SIM_OPTS=(
    # display the design hierarchy
    --disp-tree=inst
    # disable ieee asserts at the start of simulation
    --ieee-asserts=disable-at-0
    # level at which an assertion stops the simulation
    --assert-level=failure
    # level at which an assertion displays a backtrace
    --backtrace-severity=warning
    # export waveforms
    --vcd="$TB.vcd" --wave="$TB.ghw" --fst="$TB.fst"
    # write PSL report at the end of simulation
    --psl-report="$TB.psl-report"
)
if [ -n "${STOP_TIME_US:+x}" ] ; then
    SIM_OPTS+=(
        --stop-time="$STOP_TIME_US"us
        -gg_STOP_TIME_US="$STOP_TIME_US"
        -gg_SEED="$((0x$(cat /dev/random | tr -dc "0-9A-F" | head -c 8)-0x80000000))"
    )
else
    SIM_OPTS+=(
        --stop-time="${STOPTIME:-1us}"
    )
fi
[ -f "$TB.wave-opt" ] && SIM_OPTS+=(--read-wave-opt="../$TB.wave-opt")

mkdir -p -- .cache
cd -- .cache || exit 1

# import: files are scanned, parsed and added into the libraries
ghdl -i "${OPTS[@]}" "${SRC[@]}"
# make: analyze and elaborate the design
ghdl -m "${OPTS[@]}" "$TB"
# run: run/simulate the design
ghdl -r "${OPTS[@]}" "$TB" "${SIM_OPTS[@]}"

if [ -f "../$TB.gtkw" ] ; then
    gtkwave "$TB.ghw" "../$TB.gtkw"
else
    gtkwave --autosavename "$TB.ghw"
fi
