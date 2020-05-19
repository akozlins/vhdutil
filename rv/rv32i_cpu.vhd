--
-- Author : Alexandr Kozlinskiy
-- Date : 2019-05-23
--

library ieee;
use ieee.std_logic_1164.all;

entity rv32i_cpu_v1 is
port (
    dbg_out     : out   std_logic_vector(31 downto 0);
    dbg_in      : in    std_logic_vector(31 downto 0);
    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

library ieee;
use ieee.numeric_std.all;

architecture arch of rv32i_cpu_v1 is

    function to_string ( v : std_logic_vector ) return string is
    begin
        return integer'image(to_integer(signed((v))));
    end function;

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

    i_ram : entity work.ram_dp
    generic map (
        W => 32,
        N => 8,
        INIT_FILE_HEX => "rv/rv32i_cpu.hex"--,
    )
    port map (
        a_addr  => pc(9 downto 2),
        a_rdata => inst,
        b_addr  => ram_addr(9 downto 2),
        b_rdata => ram_rdata,
        b_wdata => ram_wdata,
        b_we    => ram_we,
        clk     => i_clk--,
    );

    ram_wdata <= reg_rdata2;
    ram_we <= '1' when ( opcode = work.rv32i_pkg.STORE_c ) else '0';

    i_reg_file : entity work.rv32i_reg_file
    port map (
        i_raddr1    => reg_raddr1,
        o_rdata1    => reg_rdata1,
        i_raddr2    => reg_raddr2,
        o_rdata2    => reg_rdata2,
        i_waddr     => reg_waddr,
        i_wdata     => reg_wdata,
        i_we        => '1',
        i_reset_n   => i_reset_n,
        i_clk       => i_clk--,
    );

    i_inst : entity work.rv32i_inst
    port map (
        o_opcode    => opcode,

        o_funct3    => funct3,
        o_funct7    => funct7,

        o_rs1       => reg_raddr1,
        o_rs2       => reg_raddr2,
        o_rd        => reg_waddr,

        o_imm       => imm,

        i_inst      => inst--;
    );

    i_alu : entity work.rv32i_alu
    port map (
        i_s1    => alu_s1,
        i_s2    => alu_s2,
        i_op    => alu_op,
        eq      => alu_eq, lt => alu_lt, ltu => alu_ltu,
        o_d     => alu_d--,
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

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        pc <= (others => '0');
        --
    elsif rising_edge(i_clk) then
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
