--
-- Author : Alexandr Kozlinskiy
-- Date : 2019-05-23
--

library ieee;
use ieee.std_logic_1164.all;

entity rv32i_cpu_v1 is
    port (
        dbg_out :   out std_logic_vector(31 downto 0);
        dbg_in  :   in  std_logic_vector(31 downto 0);
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

library ieee;
use ieee.numeric_std.all;

architecture arch of rv32i_cpu_v1 is

    type ram_t is array (natural range <>) of std_logic_vector(31 downto 0);

    signal ram : ram_t(0 to 255) := (
        -- reset vector
        work.rv32i_pkg.jal('0' & X"00004", "00000"),
        -- set sp
        X"400" & "00000" & "000" & "00010" & work.rv32i_pkg.OP_IMM_c,
        -- set ra
        work.rv32i_pkg.jal('0' & X"00008", "00001"),
        -- hlt
        work.rv32i_pkg.jal('0' & X"00000", "00000"),
        --
        X"ff010113",
        X"00112623",
        X"00812423",
        X"01010413",
        X"04c000ef",
        X"00050793",
        X"00078513",
        X"00c12083",
        X"00812403",
        X"01010113",
        X"00008067",
        X"fe010113",
        X"00812e23",
        X"02010413",
        X"fea42623",
        X"feb42423",
        X"fec42703",
        X"fe842783",
        X"00f707b3",
        X"00078513",
        X"01c12403",
        X"02010113",
        X"00008067",
        X"fe010113",
        X"00112e23",
        X"00812c23",
        X"02010413",
        X"fe042623",
        X"fe042423",
        X"0200006f",
        X"02a00593",
        X"fec42503",
        X"fadff0ef",
        X"fea42623",
        X"fe842783",
        X"00178793",
        X"fef42423",
        X"fe842703",
        X"00f00793",
        X"fce7dee3",
        X"fec42783",
        X"00078513",
        X"01c12083",
        X"01812403",
        X"02010113",
        X"00008067",
        --
        others => (others => 'U')
    );

    signal regs : ram_t(0 to 31) := (
        others => (others => '-')
    );

    signal pc, ram_addr : std_logic_vector(31 downto 0);
    signal reg_addr1, reg_addr2, reg_waddr : std_logic_vector(4 downto 0);

    signal inst, reg_rd1, reg_rd2, reg_wd, imm, ldata : std_logic_vector(31 downto 0);

    signal opcode : std_logic_vector(6 downto 0);
    signal funct3 : std_logic_vector(2 downto 0);

    signal alu_s1, alu_s2, alu_d : std_logic_vector(31 downto 0);
    signal alu_op : std_logic_vector(3 downto 0);

begin

    inst <= ram(to_integer(unsigned(pc(9 downto 0))) / 4);



    ldata <= ram(to_integer(unsigned(ram_addr(9 downto 0))) / 4);

    process(clk)
    begin
    if rising_edge(clk) then
        if ( opcode = work.rv32i_pkg.STORE_c ) then
            report "    ram[" & integer'image(to_integer(unsigned(ram_addr))) & "] <= " & integer'image(to_integer(unsigned(reg_rd2)));
            ram(to_integer(unsigned(ram_addr(9 downto 0))) / 4) <= reg_rd2;
        end if;
    end if;
    end process;



    reg_rd1 <= regs(to_integer(unsigned(reg_addr1))) when ( reg_addr1 /= "00000" ) else (others => '0');
    reg_rd2 <= regs(to_integer(unsigned(reg_addr2))) when ( reg_addr2 /= "00000" ) else (others => '0');

    process(clk)
    begin
    if ( rst_n = '0' ) then
        regs <= (others => (others => '0'));
        --
    elsif rising_edge(clk) then
        if ( reg_waddr /= "00000" ) then
            report "    reg[" & work.rv32i_pkg.reg_name(reg_waddr) & "] <= " & integer'image(to_integer(unsigned(reg_wd)));
            regs(to_integer(unsigned(reg_waddr))) <= reg_wd;
        end if;
    end if;
    end process;



    i_inst : entity work.rv32i_inst
    port map (
        opcode => opcode,

        funct3 => funct3,
        funct7 => open,

        rs1 => reg_addr1,
        rs2 => reg_addr2,
        rd => reg_waddr,

        imm => imm,

        inst => inst--;
    );

    i_alu : entity work.rv32i_alu
    port map (
        s1  => alu_s1,
        s2  => alu_s2,
        op  => alu_op,
        d   => alu_d--,
    );

    alu_s1 <=
        pc when ( opcode = work.rv32i_pkg.AUIPC_c ) else
        pc when ( opcode = work.rv32i_pkg.JAL_c ) else
        pc when ( opcode = work.rv32i_pkg.BRANCH_c ) else
        reg_rd1;

    alu_s2 <=
        reg_rd2 when ( opcode = work.rv32i_pkg.OP_c ) else
        imm;

    alu_op <=
        inst(30) & funct3 when ( opcode = work.rv32i_pkg.OP_c ) else
        inst(30) & funct3 when ( opcode = work.rv32i_pkg.OP_IMM_c and funct3 = "101" ) else
        '0' & funct3 when ( opcode = work.rv32i_pkg.OP_IMM_c ) else
        "0000";

    reg_wd <=
        imm when ( opcode = work.rv32i_pkg.LUI_c ) else
        std_logic_vector(unsigned(pc) + 4) when ( opcode = work.rv32i_pkg.JAL_c or opcode = work.rv32i_pkg.JALR_c ) else
        ldata when ( opcode = work.rv32i_pkg.LOAD_c ) else
        alu_d;

    ram_addr <= alu_d when ( opcode = work.rv32i_pkg.LOAD_c or opcode = work.rv32i_pkg.STORE_c ) else (others => '0');

    process(clk)
    begin
    if ( rst_n = '0' ) then
        pc <= (others => '0');
        --
    elsif rising_edge(clk) then
        report "[" & integer'image(to_integer(unsigned(pc))) & "]";
        report "    " & work.rv32i_pkg.inst_name(inst);
        report "    imm = " & integer'image(to_integer(signed(imm)));
        report "    s1: reg[" & work.rv32i_pkg.reg_name(reg_addr1) & "] = " & integer'image(to_integer(unsigned(reg_rd1)));
        report "    s2: reg[" & work.rv32i_pkg.reg_name(reg_addr2) & "] = " & integer'image(to_integer(unsigned(reg_rd2)));

        if ( opcode = work.rv32i_pkg.JAL_c or opcode = work.rv32i_pkg.JALR_c ) then
            pc <= alu_d;
            report "    pc <= " & integer'image(to_integer(unsigned(alu_d)));
            --
        elsif ( opcode = work.rv32i_pkg.BRANCH_c and (
            ( funct3 = "000" and reg_rd1 = reg_rd2 ) or
            ( funct3 = "001" and reg_rd1 /= reg_rd2 ) or
            ( funct3 = "100" and signed(reg_rd1) < signed(reg_rd2) ) or
            ( funct3 = "101" and signed(reg_rd1) >= signed(reg_rd2) ) or
            ( funct3 = "110" and unsigned(reg_rd1) < unsigned(reg_rd2) ) or
            ( funct3 = "111" and unsigned(reg_rd1) >= unsigned(reg_rd2) )
        ) ) then
            pc <= std_logic_vector(unsigned(pc) + unsigned(imm));
            report "    pc <= " & integer'image(to_integer(unsigned(pc) + unsigned(imm)));
            --
        else
            pc <= std_logic_vector(unsigned(pc) + 4);
            report "    pc <= " & integer'image(to_integer(unsigned(pc) + 4));
        end if;
    end if;
    end process;

end architecture;
