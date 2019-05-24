--
-- Author : Alexandr Kozlinskiy
-- Date : 2019-05-21
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rv32i_alu is
generic (
    W : natural := 32--;
);
port (
    -- operands
    s1 : in std_logic_vector(W-1 downto 0);
    s2 : in std_logic_vector(W-1 downto 0);
    -- operation
    op : in std_logic_vector(3 downto 0); -- subsra & funct3
    -- result
    d : out std_logic_vector(W-1 downto 0)--;
);
end entity;

architecture arch of rv32i_alu is

    signal lt_s, ltu_s : std_logic;

    signal nshift_s : integer;

begin

    lt_s <= '1' when ( signed(s1) < signed(s2) ) else '0';
    ltu_s <= '1' when ( unsigned(s1) < unsigned(s2) ) else '0';

    nshift_s <= to_integer(unsigned(s2(4 downto 0)));

    d <=
        std_logic_vector(unsigned(s1) + unsigned(s2))         when ( op = "0000" ) else -- add
        std_logic_vector(unsigned(s1) - unsigned(s2))         when ( op = "1000" ) else -- sub
        std_logic_vector(shift_left (unsigned(s1), nshift_s)) when ( op = "0001" ) else -- sll
        (0 => lt_s , others => '0')                           when ( op = "0010" ) else -- slt
        (0 => ltu_s, others => '0')                           when ( op = "0011" ) else -- sltu
        s1 xor s2                                             when ( op = "0100" ) else -- xor
        std_logic_vector(shift_right(unsigned(s1), nshift_s)) when ( op = "0101" ) else -- srl
        std_logic_vector(shift_right(  signed(s1), nshift_s)) when ( op = "1101" ) else -- sra
        s1  or s2                                             when ( op = "0110" ) else -- or
        s1 and s2                                             when ( op = "0111" ) else -- and
        (others => '-');

end architecture;
