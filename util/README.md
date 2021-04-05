# Utils

Common (portable) vhdl components.

## Simulation

```
# compile altera libs
/usr/lib/ghdl/vendors/compile-altera.sh \
    --src "$QUARTUS_ROOTDIR/eda/sim_lib" \
    --out "$HOME/.cache/altera-quartus" \
    --altera
# run simulation
./sim.sh <tb_entity> <sources>
```
