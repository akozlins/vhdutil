library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.util.all;

entity alu_v2 is
    generic (
        W   : integer := 8--;
    );
    port (
        -- carry in
        ci  :   in  std_logic;
        -- operands
        a   :   in  std_logic_vector(W-1 downto 0);
        b   :   in  std_logic_vector(W-1 downto 0);
        -- operation
        op  :   in  std_logic_vector(2 downto 0);
        -- output
        y   :   out std_logic_vector(W-1 downto 0);
        -- zero
        z   :   out std_logic;
        -- sign
        s   :   out std_logic;
        -- overflow
        v   :   out std_logic;
        -- carry out
        co  :   out std_logic--;
    );
end entity alu_v2;

architecture arch of alu_v2 is

    signal ci_i : std_logic;
    signal a_i : std_logic_vector(W-1 downto 0);
    signal b_i : std_logic_vector(W-1 downto 0);
    signal y_i : std_logic_vector(W downto 0);

begin

    y_i <= ('0' & a_i) + b_i + ci_i;
    co <= y_i(W);

    process(op, a, b, ci, y_i)
    begin
        a_i <= a;
        b_i <= b;
        ci_i <= ci;
        y <= y_i(y'range);

        case op is
        when "000" =>
            -- add
            ci_i <= '0';
        when "010" =>
            -- sub
            a_i <= not a;
            ci_i <= '1';
        when "011" =>
            -- subb
            a_i <= not a;
            ci_i <= not ci;
        when "100" =>
            y <= a and b;
        when "101" =>
            y <= a or b;
        when "110" =>
            y <= a xor b;
        when "111" =>
            y <= not a;
        when others =>
            null;
        end case;
    end process;

    z <= bool_to_logic(y_i(y'range) = 0);
    s <= y_i(W-1);
    v <= (a(W-1) and b(W-1) and not y_i(W-1)) or (not a(W-1) and not b(W-1) and y_i(W-1));

end;
