--
-- Author : Alexandr Kozlinskiy
-- Date : 2019-05-21
--

library ieee;
use ieee.std_logic_1164.all;

entity rv32i_inst is
port (
    o_opcode    : out   std_logic_vector(6 downto 0);

    o_funct3    : out   std_logic_vector(2 downto 0);
    o_funct7    : out   std_logic_vector(6 downto 0);

    o_rs1       : out   std_logic_vector(4 downto 0);
    o_rs2       : out   std_logic_vector(4 downto 0);
    o_rd        : out   std_logic_vector(4 downto 0);

    o_imm       : out   std_logic_vector(31 downto 0);

    i_inst      : in    std_logic_vector(31 downto 0)--;
);
end entity;

use work.rv32i_pkg.all;

architecture arch of rv32i_inst is

    signal opcode : std_logic_vector(6 downto 0);

    signal typeR, typeI, typeS, typeB, typeU, typeJ : boolean;

begin

    opcode <= i_inst(6 downto 0);

    typeR <= ( opcode = OP_c );
    typeI <= ( opcode = OP_IMM_c or opcode = JALR_c or opcode = LOAD_c or opcode = SYSTEM_c );
    typeS <= ( opcode = STORE_c );
    typeB <= ( opcode = BRANCH_c );
    typeU <= ( opcode = LUI_c or opcode = AUIPC_c );
    typeJ <= ( opcode = JAL_c );

    o_opcode <= opcode when ( typeR or typeI or typeS or typeB or typeU or typeJ ) else (others => '-');

    o_funct3 <= i_inst(14 downto 12) when ( typeR or typeI or typeS or typeB ) else (others => '0');
    o_funct7 <= i_inst(31 downto 25) when ( typeR ) else (others => '-');

    o_rs1 <= i_inst(19 downto 15) when ( typeR or typeI or typeS or typeB ) else (others => '0');
    o_rs2 <= i_inst(24 downto 20) when ( typeR or typeS or typeB ) else (others => '0');
    o_rd <= i_inst(11 downto 7) when ( typeR or typeI or typeU or typeJ ) else (others => '0');

    o_imm <=
    --  | 31                                                     | 11         | 10                   | 4                    | 0
        (31 downto 11 => i_inst(31))                                          & i_inst(30 downto 25) & i_inst(24 downto 21) & i_inst(20) when ( typeI ) else -- I-immediate
        (31 downto 11 => i_inst(31))                                          & i_inst(30 downto 25) & i_inst(11 downto 8)  & i_inst(7)  when ( typeS ) else -- S-immediate
        (31 downto 12 => i_inst(31))                             & i_inst(7)  & i_inst(30 downto 25) & i_inst(11 downto 8)  & '0'        when ( typeB ) else -- B-immediate
        i_inst(31) & i_inst(30 downto 20) & i_inst(19 downto 12) & (11 downto 0 => '0')                                                  when ( typeU ) else -- U-immediate
        (31 downto 20 => i_inst(31))      & i_inst(19 downto 12) & i_inst(20) & i_inst(30 downto 25) & i_inst(24 downto 21) & '0'        when ( typeJ ) else -- J-immediate
        (others => '0');

end architecture;
