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

    function to_string ( v : std_logic_vector ) return string is
    begin
        return integer'image(to_integer(signed((v))));
    end function;

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

    signal pc, pc_next, ram_addr : std_logic_vector(31 downto 0);
    signal reg_raddr1, reg_raddr2, reg_waddr : std_logic_vector(4 downto 0);

    signal inst, reg_rdata1, reg_rdata2, reg_wdata, imm, ram_rdata, ram_wdata : std_logic_vector(31 downto 0);
    signal ram_we : std_logic;

    signal opcode : std_logic_vector(6 downto 0);
    signal funct3 : std_logic_vector(2 downto 0);

    signal alu_s1, alu_s2, alu_d : std_logic_vector(31 downto 0);
    signal alu_op : std_logic_vector(3 downto 0);
    signal alu_eq, alu_lt, alu_ltu : std_logic;

begin

    inst <= ram(to_integer(unsigned(pc(9 downto 0))) / 4);



    ram_rdata <= ram(to_integer(unsigned(ram_addr(9 downto 0))) / 4);

    process(clk)
    begin
    if rising_edge(clk) then
        if ( ram_we = '1' ) then
            ram(to_integer(unsigned(ram_addr(9 downto 0))) / 4) <= ram_wdata;
        end if;
    end if;
    end process;

    ram_wdata <= reg_rdata2;
    ram_we <= '1' when ( opcode = work.rv32i_pkg.STORE_c ) else '0';


    reg_rdata1 <= regs(to_integer(unsigned(reg_raddr1))) when ( reg_raddr1 /= "00000" ) else (others => '0');
    reg_rdata2 <= regs(to_integer(unsigned(reg_raddr2))) when ( reg_raddr2 /= "00000" ) else (others => '0');

    process(clk)
    begin
    if ( rst_n = '0' ) then
        regs <= (others => (others => '0'));
        --
    elsif rising_edge(clk) then
        if ( reg_waddr /= "00000" ) then
            regs(to_integer(unsigned(reg_waddr))) <= reg_wdata;
        end if;
    end if;
    end process;



    i_inst : entity work.rv32i_inst
    port map (
        opcode => opcode,

        funct3 => funct3,
        funct7 => open,

        rs1 => reg_raddr1,
        rs2 => reg_raddr2,
        rd => reg_waddr,

        imm => imm,

        inst => inst--;
    );

    i_alu : entity work.rv32i_alu
    port map (
        s1  => alu_s1,
        s2  => alu_s2,
        op  => alu_op,
        eq  => alu_eq, lt => alu_lt, ltu => alu_ltu,
        d   => alu_d--,
    );

    alu_s1 <=
        pc when ( opcode = work.rv32i_pkg.AUIPC_c ) else
        pc when ( opcode = work.rv32i_pkg.JAL_c ) else
        reg_rdata1;

    alu_s2 <=
        reg_rdata2 when ( opcode = work.rv32i_pkg.BRANCH_c ) else
        reg_rdata2 when ( opcode = work.rv32i_pkg.OP_c ) else
        imm;

    alu_op <=
        inst(30) & funct3 when ( opcode = work.rv32i_pkg.OP_c ) else
        inst(30) & funct3 when ( opcode = work.rv32i_pkg.OP_IMM_c and funct3 = "101" ) else
        '0' & funct3 when ( opcode = work.rv32i_pkg.OP_IMM_c ) else
        "0000";

    reg_wdata <=
        imm when ( opcode = work.rv32i_pkg.LUI_c ) else
        std_logic_vector(unsigned(pc) + 4) when ( opcode = work.rv32i_pkg.JAL_c or opcode = work.rv32i_pkg.JALR_c ) else
        ram_rdata when ( opcode = work.rv32i_pkg.LOAD_c ) else
        alu_d;

    ram_addr <= alu_d when ( opcode = work.rv32i_pkg.LOAD_c or opcode = work.rv32i_pkg.STORE_c ) else (others => '0');

    pc_next <=
        alu_d when ( opcode = work.rv32i_pkg.JAL_c or opcode = work.rv32i_pkg.JALR_c ) else
        std_logic_vector(unsigned(pc) + unsigned(imm)) when ( opcode = work.rv32i_pkg.BRANCH_c and (
            ( funct3 = "000" and alu_eq = '1' ) or
            ( funct3 = "001" and alu_eq = '0' ) or
            ( funct3 = "100" and alu_lt = '1' ) or
            ( funct3 = "101" and alu_lt = '0' ) or
            ( funct3 = "110" and alu_ltu = '1' ) or
            ( funct3 = "111" and alu_ltu = '0' ) )
        ) else
        std_logic_vector(unsigned(pc) + 4);

    process(clk)
    begin
    if ( rst_n = '0' ) then
        pc <= (others => '0');
        --
    elsif rising_edge(clk) then
        pc <= pc_next;

        report "[" & to_string(pc) & "]" & " " & work.rv32i_pkg.inst_name(inst);
        report "    imm = " & to_string(imm);
        report "    s1: reg[" & work.rv32i_pkg.reg_name(reg_raddr1) & "] = " & to_string(reg_rdata1);
        report "    s2: reg[" & work.rv32i_pkg.reg_name(reg_raddr2) & "] = " & to_string(reg_rdata2);

        if ( ram_we = '1' ) then
            report "    ram[" & to_string(ram_addr) & "] <= " & to_string(reg_rdata2);
        end if;
        if ( reg_waddr /= "00000" ) then
            report "    reg[" & work.rv32i_pkg.reg_name(reg_waddr) & "] <= " & to_string(reg_wdata);
        end if;

        report "    pc <= " & to_string(pc_next);
    end if;
    end process;

end architecture;
