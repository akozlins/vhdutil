library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ip_ram_tb is
end entity;

architecture arch of ip_ram_tb is

    constant CLK_MHZ : positive := 100;
    signal clk, reset_n : std_logic := '0';

    signal waddr : std_logic_vector(3 downto 0);
    signal wd : std_logic_vector(3 downto 0);
    signal we : std_logic;

    signal raddr : std_logic_vector(3 downto 0);
    signal rd : std_logic_vector(3 downto 0);

    type state_t is (
        state_write,
        state_read,
        state_rvalid,
        state_reset--,
    );
    signal state : state_t;

begin

    clk <= not clk after (500 ns / CLK_MHZ);
    reset_n <= '0', '1' after (1000 ns / CLK_MHZ);

    e_ram : entity work.ip_ram
    generic map (
        g_ADDR0_WIDTH => waddr'length,
        g_DATA0_WIDTH => wd'length,
        g_ADDR1_WIDTH => raddr'length,
        g_DATA1_WIDTH => rd'length,
        DEVICE_FAMILY => "Arria V"--,
    )
    port map (
        i_addr0 => waddr,
        i_wdata0 => wd,
        i_we0 => we,
        i_clk0 => clk,

        i_addr1 => raddr,
        o_rdata1 => rd,
        i_clk1 => clk--,
    );

    wd <= std_logic_vector(waddr(wd'range)) when ( state = state_write ) else (others => '0');
    we <= '1' when ( state = state_write ) else '0';

    process(clk, reset_n)
    begin
    if ( reset_n = '0' ) then
        waddr <= (others => '0');
        raddr <= (others => '0');
        state <= state_reset;
        --
    elsif rising_edge(clk) then
        case state is
        when state_write =>
            raddr <= std_logic_vector(unsigned(raddr) + 1);
            state <= state_read;
        when state_read =>
            state <= state_rvalid;
        when state_rvalid =>
            assert ( rd = raddr(rd'range) ) severity error;
            waddr <= std_logic_vector(unsigned(waddr) + 1);
            state <= state_write;
        when state_reset =>
            waddr <= (others => '0');
            raddr <= (others => '1');
            state <= state_write;
        end case;

        --
    end if;
    end process;

end architecture;
