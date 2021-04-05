#

## `top.qpf`

## `top.qsf`

## `top.qip`

## `makefile.mk`

This `mk` file contains helper tagets
that allow to process specific quartus build steps:

- generate `qsys` files
- generate `sopcinfo` files
- generate BSP from NIOS `sopcinfo` file
- build software for NIOS
- execute flow command on quartus project (compile firmware)

The `qsys` files can be created from quartus
either by creating new system in QSYS editor
or by generating specific IP.

The `sopcinfo` files are generated directly from `qsys` files.
