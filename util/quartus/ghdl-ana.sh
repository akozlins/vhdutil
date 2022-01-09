#!/bin/bash
set -euf

SRC=()
while IFS='' read -r arg ; do
    arg=$(realpath -s --relative-to=.cache -- "$arg")
    SRC+=("$arg")
done < <(./util/quartus/qsf-list-vhdl.tcl)

# directories to be searched for library files
DIRS=(
    "/usr/local/lib/ghdl/vendors/altera"
    "/usr/lib/ghdl/vendors/altera"
    "$HOME/.local/share/ghdl/vendors/altera"
)

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
    # ...
#    --warn-no-binding
)

for arg in "${DIRS[@]}" ; do
    [ -d "$arg" ] && OPTS+=(-P"$arg")
done

mkdir -p -- .cache
cd -- .cache || exit 1

# import: files are scanned, parsed and added into the libraries
ghdl -i "${OPTS[@]}" "${SRC[@]}"
# make: analyze and elaborate the design
ghdl -m "${OPTS[@]}" top
