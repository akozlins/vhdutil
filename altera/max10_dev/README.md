# Max10 fpga



## NIOS



## UFM internal flash

- [nios_ufm]
  - connect instruction master to flash
  - set reset vector to address 0
- [hal_bsp]
  - set .text section to flash region
  - enable alt_load



```
quartus_pgm -m jtag -c 1 --operation="pv;output_files/top.pof"
./software/pgm_ufm.sh
> pgm_srec $mm software/app/main.srec
> processor_run [ lindex $proc_paths 0 ]
```
