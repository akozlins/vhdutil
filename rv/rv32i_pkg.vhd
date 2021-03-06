--
-- Author : Alexandr Kozlinskiy
-- Date : 2019-05-27
--

library ieee;
use ieee.std_logic_1164.all;

package rv32i_pkg is

    -- opcode
    constant LUI_c      : std_logic_vector(6 downto 0) := "0110111";
    constant AUIPC_c    : std_logic_vector(6 downto 0) := "0010111";
    constant JAL_c      : std_logic_vector(6 downto 0) := "1101111";
    constant JALR_c     : std_logic_vector(6 downto 0) := "1100111";
    constant BRANCH_c   : std_logic_vector(6 downto 0) := "1100011";
    constant LOAD_c     : std_logic_vector(6 downto 0) := "0000011";
    constant STORE_c    : std_logic_vector(6 downto 0) := "0100011";
    constant OP_IMM_c   : std_logic_vector(6 downto 0) := "0010011";
    constant OP_c       : std_logic_vector(6 downto 0) := "0110011";
    constant MISC_MEM_c : std_logic_vector(6 downto 0) := "0001111";
    constant SYSTEM_c   : std_logic_vector(6 downto 0) := "1110011";

    function reg_name (
        reg : std_logic_vector(4 downto 0)--;
    ) return string;

    function inst_name (
        inst : std_logic_vector(31 downto 0)--;
    ) return string;

    function jal (
        imm : std_logic_vector(20 downto 0);
        rd : std_logic_vector(4 downto 0)--;
    ) return std_logic_vector;

end package;

package body rv32i_pkg is

    function reg_name (
        reg : std_logic_vector(4 downto 0)--;
    ) return string is
    begin
        -- https://github.com/riscv/riscv-elf-psabi-doc/blob/master/riscv-elf.md

        if ( reg = "00000" ) then return "zero"; end if;
        if ( reg = "00001" ) then return "ra"; end if; -- return address
        if ( reg = "00010" ) then return "sp"; end if; -- stack pointer
        if ( reg = "00011" ) then return "gp"; end if; -- global pointer
        if ( reg = "00100" ) then return "tp"; end if; -- thread pointer
        if ( reg = "00101" ) then return "t0"; end if; -- temporary registers
        if ( reg = "00110" ) then return "t1"; end if;
        if ( reg = "00111" ) then return "t2"; end if;
        if ( reg = "01000" ) then return "s0"; end if; -- callee-saved registers
        if ( reg = "01001" ) then return "s1"; end if;
        if ( reg = "01010" ) then return "a0"; end if; -- argument registers
        if ( reg = "01011" ) then return "a1"; end if;
        if ( reg = "01100" ) then return "a2"; end if;
        if ( reg = "01101" ) then return "a3"; end if;
        if ( reg = "01110" ) then return "a4"; end if;
        if ( reg = "01111" ) then return "a5"; end if;
        if ( reg = "10000" ) then return "a6"; end if;
        if ( reg = "10001" ) then return "a7"; end if;
        if ( reg = "10010" ) then return "s2"; end if;
        if ( reg = "10011" ) then return "s3"; end if;
        if ( reg = "10100" ) then return "s4"; end if;
        if ( reg = "10101" ) then return "s5"; end if;
        if ( reg = "10110" ) then return "s6"; end if;
        if ( reg = "10111" ) then return "s7"; end if;
        if ( reg = "11000" ) then return "s8"; end if;
        if ( reg = "11001" ) then return "s9"; end if;
        if ( reg = "11010" ) then return "s10"; end if;
        if ( reg = "11011" ) then return "s11"; end if;
        if ( reg = "11100" ) then return "t3"; end if;
        if ( reg = "11101" ) then return "t4"; end if;
        if ( reg = "11110" ) then return "t5"; end if;
        if ( reg = "11111" ) then return "t6"; end if;
        return "";
    end function;

    function inst_name (
        inst : std_logic_vector(31 downto 0)--;
    ) return string is
    begin
        if ( inst(6 downto 0) = LUI_c   ) then return "lui"; end if;
        if ( inst(6 downto 0) = AUIPC_c ) then return "auipc"; end if;
        if ( inst(6 downto 0) = JAL_c   ) then return "jal"; end if;
        if ( inst(6 downto 0) = JALR_c  ) then return "jalr"; end if;
        if ( inst(6 downto 0) = BRANCH_c  and inst(14 downto 12) = "000" ) then return "beq"; end if;
        if ( inst(6 downto 0) = BRANCH_c  and inst(14 downto 12) = "001" ) then return "bne"; end if;
        if ( inst(6 downto 0) = BRANCH_c  and inst(14 downto 12) = "100" ) then return "blt"; end if;
        if ( inst(6 downto 0) = BRANCH_c  and inst(14 downto 12) = "101" ) then return "bge"; end if;
        if ( inst(6 downto 0) = BRANCH_c  and inst(14 downto 12) = "110" ) then return "bltu"; end if;
        if ( inst(6 downto 0) = BRANCH_c  and inst(14 downto 12) = "111" ) then return "bgeu"; end if;
        if ( inst(6 downto 0) = LOAD_c    and inst(14 downto 12) = "010" ) then return "lw"; end if;
        if ( inst(6 downto 0) = STORE_c   and inst(14 downto 12) = "010" ) then return "sw"; end if;
        if ( inst(6 downto 0) = OP_IMM_c  and inst(14 downto 12) = "000" ) then return "addi"; end if;
        if ( inst(6 downto 0) = OP_IMM_c  and inst(14 downto 12) = "010" ) then return "slti"; end if;
        if ( inst(6 downto 0) = OP_IMM_c  and inst(14 downto 12) = "011" ) then return "sltiu"; end if;
        if ( inst(6 downto 0) = OP_IMM_c  and inst(14 downto 12) = "100" ) then return "xori"; end if;
        if ( inst(6 downto 0) = OP_IMM_c  and inst(14 downto 12) = "110" ) then return "ori"; end if;
        if ( inst(6 downto 0) = OP_IMM_c  and inst(14 downto 12) = "111" ) then return "andi"; end if;
        if ( inst(6 downto 0) = OP_IMM_c  and inst(14 downto 12) = "001" and inst(31 downto 26) = "0000000" ) then return "slli"; end if;
        if ( inst(6 downto 0) = OP_IMM_c  and inst(14 downto 12) = "101" and inst(31 downto 26) = "0000000" ) then return "srli"; end if;
        if ( inst(6 downto 0) = OP_IMM_c  and inst(14 downto 12) = "101" and inst(31 downto 26) = "0100000" ) then return "srai"; end if;
        if ( inst(6 downto 0) = OP_c      and inst(14 downto 12) = "000" and inst(31 downto 25) = "0000000" ) then return "and"; end if;
        if ( inst(6 downto 0) = OP_c      and inst(14 downto 12) = "000" and inst(31 downto 25) = "0100000" ) then return "sub"; end if;
        if ( inst(6 downto 0) = OP_c      and inst(14 downto 12) = "001" and inst(31 downto 25) = "0000000" ) then return "sll"; end if;
        if ( inst(6 downto 0) = OP_c      and inst(14 downto 12) = "010" and inst(31 downto 25) = "0000000" ) then return "slt"; end if;
        if ( inst(6 downto 0) = OP_c      and inst(14 downto 12) = "011" and inst(31 downto 25) = "0000000" ) then return "sltu"; end if;
        if ( inst(6 downto 0) = OP_c      and inst(14 downto 12) = "100" and inst(31 downto 25) = "0000000" ) then return "xor"; end if;
        if ( inst(6 downto 0) = OP_c      and inst(14 downto 12) = "101" and inst(31 downto 25) = "0000000" ) then return "srl"; end if;
        if ( inst(6 downto 0) = OP_c      and inst(14 downto 12) = "101" and inst(31 downto 25) = "0100000" ) then return "sra"; end if;
        if ( inst(6 downto 0) = OP_c      and inst(14 downto 12) = "110" and inst(31 downto 25) = "0000000" ) then return "or"; end if;
        if ( inst(6 downto 0) = OP_c      and inst(14 downto 12) = "111" and inst(31 downto 25) = "0000000" ) then return "and"; end if;
        if ( inst(6 downto 0) = MISC_MEM_c ) then return "fence"; end if;
        if ( inst(6 downto 0) = SYSTEM_c ) then return "ecall"; end if;
        if ( inst(6 downto 0) = SYSTEM_c ) then return "ebreak"; end if;
        return "invalid";
    end function;

    function jal (
        imm : std_logic_vector(20 downto 0);
        rd : std_logic_vector(4 downto 0)--;
    ) return std_logic_vector is
    begin
        return imm(20) & imm(10 downto 1) & imm(11) & imm(19 downto 12) & rd & JAL_c;
    end function;

end package body;
