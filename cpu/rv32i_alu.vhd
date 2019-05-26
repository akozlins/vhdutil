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

    eq : out std_logic;
    lt : out std_logic;
    ltu : out std_logic;

    -- result
    d : out std_logic_vector(W-1 downto 0)--;
);
end entity;

architecture arch of rv32i_alu is

    signal xor_s, add_s : std_logic_vector(W-1 downto 0);
    signal sub_s : std_logic_vector(W downto 0);

    signal eq_s, lt_s, ltu_s : std_logic;

    signal nshift_s : integer;

begin

    xor_s <= s1 xor s2;

    add_s <= std_logic_vector(unsigned(s1) + unsigned(s2));
    sub_s <= std_logic_vector(unsigned('0' & s1) - unsigned('0' & s2));

    eq_s <= '1' when ( xor_s = (xor_s'range => '0') ) else '0';
    lt_s <= sub_s(W) xor xor_s(W-1); -- underflow xor sign1 xor sign2
    ltu_s <= sub_s(W); -- underflow

    eq <= eq_s;
    lt <= lt_s;
    ltu <= ltu_s;

    nshift_s <= to_integer(unsigned(s2(4 downto 0)));

    d <=
        add_s                                                 when ( op = "0000" ) else -- add
        sub_s(W-1 downto 0)                                   when ( op = "1000" ) else -- sub
        std_logic_vector(shift_left (unsigned(s1), nshift_s)) when ( op = "0001" ) else -- sll
        (0 => lt_s , others => '0')                           when ( op = "0010" ) else -- slt
        (0 => ltu_s, others => '0')                           when ( op = "0011" ) else -- sltu
        xor_s                                                 when ( op = "0100" ) else -- xor
        std_logic_vector(shift_right(unsigned(s1), nshift_s)) when ( op = "0101" ) else -- srl
        std_logic_vector(shift_right(  signed(s1), nshift_s)) when ( op = "1101" ) else -- sra
        s1  or s2                                             when ( op = "0110" ) else -- or
        s1 and s2                                             when ( op = "0111" ) else -- and
        (others => '-');

end architecture;
