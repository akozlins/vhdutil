# Utils

Common (portable) vhdl components.

## Simulation

```
# compile altera libs
/usr/lib/ghdl/vendors/compile-altera.sh \
    --src "$QUARTUS_ROOTDIR/eda/sim_lib" \
    --out "$HOME/.cache/altera-quartus" \
    --vhdl2008 \
    --altera
# run simulation
./sim.sh <tb_entity> <sources>
```
