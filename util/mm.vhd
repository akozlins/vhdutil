library ieee;
use ieee.std_logic_1164.all;

entity mm is
    port (
        address     :   in  std_logic_vector(7 downto 0);
        read        :   in  std_logic;
        readdata    :   out std_logic_vector(15 downto 0);
        write       :   in  std_logic;
        writedata   :   in  std_logic_vector(15 downto 0);
        waitrequest :   out std_logic;

        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

architecture arch of mm is

    signal rdv_addr : std_logic_vector(address'range);
    signal readdatavalid_i : std_logic;

begin

    waitrequest <= read and work.util.to_std_logic(readdatavalid_i = '0' or rdv_addr /= address);

    process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        rdv_addr <= (others => '0');
        readdatavalid_i <= '0';
        readdata <= X"CCCC";
        --
    elsif rising_edge(clk) then
        readdatavalid_i <= read;
        rdv_addr <= address;
        readdata <= X"CCCC";

        if ( read = '1' ) then
            readdata <= (others => '0');
            readdata(address'range) <= address;
        end if;
        --
    end if;
    end process;

end architecture;
