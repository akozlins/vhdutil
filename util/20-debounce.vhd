library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debounce is
    generic (
        N   : positive := 1;
        C   : unsigned := X"FFFF"--;
    );
    port (
        input   :   in  std_logic_vector(N-1 downto 0);
        output  :   out std_logic_vector(N-1 downto 0);
        clk     :   in  std_logic--;
    );
end entity;

architecture arch of debounce is

    signal input_q0, input_q1 : std_logic_vector(input'range);

    type cnt_t is array(natural range <>) of unsigned(C'range);
    signal cnt : cnt_t(input'range);

begin

    process(clk)
    begin
    if rising_edge(clk) then
        input_q0 <= input;
        input_q1 <= input_q0;
        for i in input'range loop
            if ( input_q0(i) /= input_q1(i) ) then
                cnt(i) <= (others => '0');
            elsif ( cnt(i) = C ) then
                output(i) <= input_q1(i);
            else
                cnt(i) <= cnt(i) + 1;
            end if;
        end loop;
    end if; -- rising_edge
    end process;

end architecture;
