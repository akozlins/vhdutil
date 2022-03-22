
JedecChain;
    FileRevision(JESD32A);
    DefaultMfr(6E);

    P ActionCode(Ign)
        Device PartName(10AX090H1) MfrSpec(OpMask(0));
    P ActionCode(Ign)
        Device PartName(5M2210Z) MfrSpec(OpMask(0) SEC_Device(CFI_1GB) Child_OpMask(3 1 1 1) PFLPath("output_files/top.pof"));

ChainEnd;

AlteraBegin;
    ChainType(JTAG);
AlteraEnd;
