library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity debounce is
    generic (
        N   : integer := 1;
        C   : std_logic_vector := X"FFFF"--;
    );
    port (
        input   :   in  std_logic_vector(N-1 downto 0);
        output  :   out std_logic_vector(N-1 downto 0);
        clk     :   in  std_logic--;
    );
end entity debounce;

architecture arch of debounce is

    signal input_q0 : std_logic_vector(N-1 downto 0);
    signal input_q1 : std_logic_vector(N-1 downto 0);

    type cnt_array_type is array(N-1 downto 0) of std_logic_vector(C'length-1 downto 0);
    signal cnt : cnt_array_type;

begin

    process(clk)
    begin
    if rising_edge(clk) then
        input_q0 <= input;
        input_q1 <= input_q0;
        for i in N-1 downto 0 loop
            if ( input_q0(i) /= input_q1(i) ) then
                cnt(i) <= (others => '0');
            elsif ( cnt(i) = C ) then
                output(i) <= input_q1(i);
            else
                cnt(i) <= cnt(i) + 1;
            end if;
        end loop;
    end if;
    end process;

end;
