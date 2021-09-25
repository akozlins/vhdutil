#!/bin/sh
set -euf

# find '*.cmp' files
# and generate 'components' package

if [ $# -ge 1 ] ; then
    cd -- "$1" || exit 1
fi

cat << EOF
library ieee;
use ieee.std_logic_1164.all;

package components is

    constant GIT_HEAD : std_logic_vector(0 to 16*4-1) := X"$(git rev-parse --short=16 HEAD)";

EOF

find -L . -name '*.cmp' -exec echo "--" '{}' ';' -exec cat '{}' ';'

cat << EOF

end package;
EOF
