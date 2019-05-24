--
-- Author : Alexandr Kozlinskiy
-- Date : 2019-05-21
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

    function reg_name (
        reg : std_logic_vector(4 downto 0)--;
    ) return string;

    function inst_name (
        inst : std_logic_vector(31 downto 0)--;
    ) return string;

end package;

package body rv32i_pkg is

    function reg_name (
        reg : std_logic_vector(4 downto 0)--;
    ) return string is
    begin
        if ( reg = "00000" ) then return "zero"; end if;
        if ( reg = "00001" ) then return "ra"; end if;
        if ( reg = "00010" ) then return "sp"; end if;
        if ( reg = "00011" ) then return "gp"; end if;
        if ( reg = "00100" ) then return "tp"; end if;
        if ( reg = "00101" ) then return "t0"; end if;
        if ( reg = "00110" ) then return "t1"; end if;
        if ( reg = "00111" ) then return "t2"; end if;
        if ( reg = "01000" ) then return "s0"; end if;
        if ( reg = "01001" ) then return "s1"; end if;
        if ( reg = "01010" ) then return "a0"; end if;
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
        return "invalid";
    end function;

end package body;

library ieee;
use ieee.std_logic_1164.all;

entity rv32i_inst is
port (
    opcode : out std_logic_vector(6 downto 0);

    funct3 : out std_logic_vector(2 downto 0);
    funct7 : out std_logic_vector(6 downto 0);

    rs1 : out std_logic_vector(4 downto 0);
    rs2 : out std_logic_vector(4 downto 0);
    rd : out std_logic_vector(4 downto 0);

    imm : out std_logic_vector(31 downto 0);

    inst : in std_logic_vector(31 downto 0)--;
);
end entity;

use work.rv32i_pkg.all;

architecture arch of rv32i_inst is

    signal opcode_s : std_logic_vector(6 downto 0);

    signal typeR, typeI, typeS, typeB, typeU, typeJ : boolean;

begin

    opcode_s <= inst(6 downto 0);

    typeR <= ( opcode_s = OP_c );
    typeI <= ( opcode_s = OP_IMM_c or opcode_s = JALR_c or opcode_s = LOAD_c );
    typeS <= ( opcode_s = STORE_c );
    typeB <= ( opcode_s = BRANCH_c );
    typeU <= ( opcode_s = LUI_c or opcode_s = AUIPC_c );
    typeJ <= ( opcode_s = JAL_c );

    opcode <= opcode_s when ( typeR or typeI or typeS or typeB or typeU or typeJ ) else (others => '-');

    funct3 <= inst(14 downto 12) when ( typeR or typeI or typeS or typeB ) else (others => '0');
    funct7 <= inst(31 downto 25) when ( typeR ) else (others => '-');

    rs1 <= inst(19 downto 15) when ( typeR or typeI or typeS or typeB ) else (others => '0');
    rs2 <= inst(24 downto 20) when ( typeR or typeS or typeB ) else (others => '0');
    rd <= inst(11 downto 7) when ( typeR or typeI or typeU or typeJ ) else (others => '0');

    imm <=
    --  | 31                                               | 11       | 10                 | 4                  | 0
        (31 downto 11 => inst(31))                                    & inst(30 downto 25) & inst(24 downto 21) & inst(20) when ( typeI ) else -- I-immediate
        (31 downto 11 => inst(31))                                    & inst(30 downto 25) & inst(11 downto 8)  & inst(7)  when ( typeS ) else -- S-immediate
        (31 downto 12 => inst(31))                         & inst(7)  & inst(30 downto 25) & inst(11 downto 8)  & '0'      when ( typeB ) else -- B-immediate
        inst(31) & inst(30 downto 20) & inst(19 downto 12) & (11 downto 0 => '0')                                          when ( typeU ) else -- U-immediate
        (31 downto 20 => inst(31))    & inst(19 downto 12) & inst(20) & inst(30 downto 25) & inst(24 downto 21) & '0'      when ( typeJ ) else -- J-immediate
        (others => '0');

end architecture;
