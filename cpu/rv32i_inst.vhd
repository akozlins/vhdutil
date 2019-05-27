--
-- Author : Alexandr Kozlinskiy
-- Date : 2019-05-21
--

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
