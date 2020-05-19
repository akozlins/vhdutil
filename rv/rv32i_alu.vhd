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
    i_s1    : in    std_logic_vector(W-1 downto 0);
    i_s2    : in    std_logic_vector(W-1 downto 0);
    -- operation
    i_op    : in    std_logic_vector(3 downto 0);

    eq      : out   std_logic;
    lt      : out   std_logic;
    ltu     : out   std_logic;

    -- result
    o_d     : out   std_logic_vector(W-1 downto 0)--;
);
end entity;

architecture arch of rv32i_alu is

    signal xor_s, add_s : std_logic_vector(W-1 downto 0);
    signal sub_s : std_logic_vector(W downto 0);

    signal eq_s, lt_s, ltu_s : std_logic;

    signal nshift : integer;

begin

    xor_s <= i_s1 xor i_s2;

    add_s <= std_logic_vector(unsigned(i_s1) + unsigned(i_s2));
    sub_s <= std_logic_vector(unsigned('0' & i_s1) - unsigned('0' & i_s2));

    eq_s <= '1' when ( xor_s = (xor_s'range => '0') ) else '0';
    lt_s <= sub_s(W) xor xor_s(W-1); -- underflow xor sign1 xor sign2
    ltu_s <= sub_s(W); -- underflow

    eq <= eq_s;
    lt <= lt_s;
    ltu <= ltu_s;

    nshift <= to_integer(unsigned(i_s2(4 downto 0)));

    o_d <=
        add_s                                                 when ( i_op = "0000" ) else -- add
        sub_s(W-1 downto 0)                                   when ( i_op = "1000" ) else -- sub
        std_logic_vector(shift_left (unsigned(i_s1), nshift)) when ( i_op = "0001" ) else -- sll
        (0 => lt_s , others => '0')                           when ( i_op = "0010" ) else -- slt
        (0 => ltu_s, others => '0')                           when ( i_op = "0011" ) else -- sltu
        xor_s                                                 when ( i_op = "0100" ) else -- xor
        std_logic_vector(shift_right(unsigned(i_s1), nshift)) when ( i_op = "0101" ) else -- srl
        std_logic_vector(shift_right(  signed(i_s1), nshift)) when ( i_op = "1101" ) else -- sra
        i_s1  or i_s2                                         when ( i_op = "0110" ) else -- or
        i_s1 and i_s2                                         when ( i_op = "0111" ) else -- and
        (others => '0');

end architecture;
