--
-- author : Alexandr Kozlinskiy
-- date : 2021-05-30
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- SPI master with avalon interface
entity avalon_spi_master is
generic (
    g_DATA_WIDTH        : positive := 8;
    g_FIFO_ADDR_WIDTH   : positive := 4--;
);
port (
    o_sclk              : out   std_logic;
    o_sdo               : out   std_logic;
    i_sdi               : in    std_logic;
    o_ss_n              : out   std_logic_vector(31 downto 0);

    i_avs_address       : in    std_logic_vector(1 downto 0);
    i_avs_read          : in    std_logic;
    o_avs_readdata      : out   std_logic_vector(31 downto 0);
    i_avs_write         : in    std_logic;
    i_avs_writedata     : in    std_logic_vector(31 downto 0);
    o_avs_waitrequest   : out   std_logic;

    i_reset_n           : in    std_logic;
    i_clk               : in    std_logic--;
);
end entity;

architecture arch of avalon_spi_master is

    signal ss : std_logic_vector(o_ss_n'range);

    signal spi_ss_n : std_logic;
    signal spi_wdata, spi_rdata : std_logic_vector(31 downto 0);
    signal spi_we, spi_wfull, spi_rack, spi_rempty : std_logic;
    signal spi_sclk_div : std_logic_vector(15 downto 0);
    signal spi_cpol, spi_sdo_cpha, spi_sdi_cpha : std_logic;
    signal spi_reset : std_logic;

begin

    o_ss_n <= not (ss and (ss'range => not spi_ss_n));

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        ss <= (others => '0');
        o_avs_readdata <= X"CCCCCCCC";
        o_avs_waitrequest <= '0';
        spi_we <= '0';
        spi_rack <= '0';
        spi_sclk_div <= (others => '0');
        spi_cpol <= '0';
        spi_sdo_cpha <= '0';
        spi_sdi_cpha <= '0';
        spi_reset <= '0';
    elsif rising_edge(i_clk) then
        o_avs_readdata <= X"CCCCCCCC";
        o_avs_waitrequest <= '0';
        spi_we <= '0';
        spi_rack <= '0';

        -- tx data
        if ( i_avs_write = '1' and i_avs_address = "00" and spi_wfull = '0' ) then
            spi_wdata <= i_avs_writedata;
            spi_we <= '1';
        end if;
        -- rx data
        if ( i_avs_read = '1' and i_avs_address = "00" and spi_rempty = '0' ) then
            o_avs_readdata <= spi_rdata;
            spi_rack <= '1';
        end if;

        -- slave select
        if ( i_avs_write = '1' and i_avs_address = "01" ) then
            ss <= i_avs_writedata;
        end if;
        if ( i_avs_read = '1' and i_avs_address = "01" ) then
            o_avs_readdata <= ss;
        end if;

        -- status
        if ( i_avs_write = '1' and i_avs_address = "10" ) then
            --
        end if;
        if ( i_avs_read = '1' and i_avs_address = "10" ) then
            o_avs_readdata <= (others => '0');
            o_avs_readdata(0) <= spi_wfull;
            o_avs_readdata(8) <= spi_rempty;
        end if;

        -- control
        if ( i_avs_write = '1' and i_avs_address = "11" ) then
            spi_sclk_div <= i_avs_writedata(15 downto 0);
            spi_cpol <= i_avs_writedata(16);
            spi_sdo_cpha <= i_avs_writedata(17);
            spi_sdi_cpha <= i_avs_writedata(18);
            spi_reset <= i_avs_writedata(31);
        end if;
        if ( i_avs_read = '1' and i_avs_address = "11" ) then
            o_avs_readdata <= (others => '0');
            o_avs_readdata(15 downto 0) <= spi_sclk_div;
            o_avs_readdata(16) <= spi_cpol;
            o_avs_readdata(17) <= spi_sdo_cpha;
            o_avs_readdata(18) <= spi_sdi_cpha;
            o_avs_readdata(31) <= spi_reset;
        end if;

    end if;
    end process;

    e_spi_master : entity work.spi_master
    generic map (
        g_DATA_WIDTH => g_DATA_WIDTH,
        g_FIFO_ADDR_WIDTH => g_FIFO_ADDR_WIDTH--,
    )
    port map (
        o_sclk => o_sclk,
        o_sdo => o_sdo,
        i_sdi => i_sdi,
        o_ss_n => spi_ss_n,

        i_wdata => spi_wdata(g_DATA_WIDTH-1 downto 0),
        i_we => spi_we,
        o_wfull => spi_wfull,

        o_rdata => spi_rdata(g_DATA_WIDTH-1 downto 0),
        i_rack => spi_rack,
        o_rempty => spi_rempty,

        i_sclk_div => spi_sclk_div,
        i_cpol => spi_cpol,
        i_sdo_cpha => spi_sdo_cpha,
        i_sdi_cpha => spi_sdi_cpha,

        i_reset_n => i_reset_n and not spi_reset,
        i_clk => i_clk--,
    );

end architecture;
