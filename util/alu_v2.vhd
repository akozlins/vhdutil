library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.util.all;

entity alu_v2 is
    generic (
        W   : integer := 8--;
    );
    port (
        -- operands
        a   :   in  std_logic_vector(W-1 downto 0);
        b   :   in  std_logic_vector(W-1 downto 0);
        -- carry in
        ci  :   in  std_logic;
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
end entity;

architecture arch of alu_v2 is

    constant ZERO : std_logic_vector(W-1 downto 0) := (others => '0');

    signal ci_i : std_logic;
    signal a_i, b_i, s_i : std_logic_vector(W-1 downto 0);
    signal y_i : std_logic_vector(W-1 downto 0);

begin

    i_adder : component adder
    generic map (
        W => W--,
    )
    port map (
        a => a_i,
        b => b_i,
        ci => ci_i,
        s => s_i,
        co => co--,
    );

    process(op, a, b, ci, s_i)
    begin
        a_i <= a;
        b_i <= b;
        ci_i <= ci;
        y_i <= s_i;

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
            y_i <= a and b;
        when "101" =>
            y_i <= a or b;
        when "110" =>
            y_i <= a xor b;
        when "111" =>
            y_i <= not (a or b);
        when others =>
            null;
        end case;
    end process;

    y <= y_i;
    z <= bool_to_logic(y_i = ZERO);
    s <= y_i(y_i'left);
    v <= (a(a'left) and b(b'left) and not y_i(y_i'left)) or
         (not a(a'left) and not b(b'left) and y_i(y_i'left));

end architecture;
