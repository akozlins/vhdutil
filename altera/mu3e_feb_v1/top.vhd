library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
port (
    o_si5342_spi_sclk   : out   std_logic;
    o_si5342_spi_mosi   : out   std_logic;
    i_si5342_spi_miso   : in    std_logic;
    o_si5342_spi_ss_n   : out   std_logic;
    o_si5342_oe_n       : out   std_logic;
    o_si5342_reset_n    : out   std_logic;

    -- out0 (125 MHz)
    i_si5342_clk_125    : in    std_logic;
    -- out1 (50 MHz)
    i_si5342_clk_50     : in    std_logic;



    o_led_n             : out   std_logic_vector(15 downto 0);
    i_btn_n             : in    std_logic_vector(1 downto 0);

    i_reset_n           : in    std_logic--;
);
end entity;

architecture arch of top is

    signal led : std_logic_vector(o_led_n'range) := (others => '0');

    signal clk_50, reset_50_n : std_logic;

    signal av_test : work.util.avalon_t;

    signal spi_wdata, spi_rdata : std_logic_vector(31 downto 0);
    signal spi_we, spi_wfull, spi_rack, spi_rempty : std_logic;
    signal spi_sclk_div : std_logic_vector(15 downto 0);

begin

    o_led_n <= not led;

    o_si5342_oe_n <= '0';
    o_si5342_reset_n <= '1';

    clk_50 <= i_si5342_clk_50;

    e_reset_50_n : entity work.reset_sync
    port map ( o_reset_n => reset_50_n, i_reset_n => i_reset_n, i_clk => clk_50 );

    e_clk_50_hz : entity work.clkdiv
    generic map (
        P => 50000000--,
    )
    port map (
        o_clk       => led(0),
        i_reset_n   => reset_50_n,
        i_clk       => clk_50--,
    );

    e_nios : component work.components.nios
    port map (
--        spi_sclk => o_si5342_spi_sclk,
--        spi_mosi => o_si5342_spi_mosi,
--        spi_miso => i_si5342_spi_miso,
--        spi_ss_n(0) => o_si5342_spi_ss_n,

        avm_test_address        => av_test.address(7 downto 0),
        avm_test_read           => av_test.read,
        avm_test_readdata       => av_test.readdata,
        avm_test_write          => av_test.write,
        avm_test_writedata      => av_test.writedata,
        avm_test_waitrequest    => av_test.waitrequest,

        rst_reset_n => reset_50_n,
        clk_clk => clk_50--,
    );

    process(clk_50, reset_50_n)
    begin
    if ( reset_50_n = '0' ) then
        av_test.readdata <= X"CCCCCCCC";
        spi_we <= '0';
        spi_rack <= '0';
    elsif rising_edge(clk_50) then
        av_test.readdata <= X"CCCCCCCC";
        spi_we <= '0';
        spi_rack <= '0';

        if ( av_test.write = '1' and av_test.address(7 downto 0) = X"00" ) then
            spi_sclk_div <= av_test.writedata(15 downto 0);
        end if;
        if ( av_test.read = '1' and av_test.address(7 downto 0) = X"00" ) then
            av_test.readdata <= (others => '0');
            av_test.readdata(15 downto 0) <= spi_sclk_div;
            av_test.readdata(16) <= spi_wfull;
            av_test.readdata(17) <= spi_rempty;
--            av_test.readdata(18) <= spi_cpol;
--            av_test.readdata(19) <= spi_sdo_cpha;
--            av_test.readdata(20) <= spi_sdi_cpha;
        end if;

        if ( av_test.write = '1' and av_test.address(7 downto 0) = X"01" and spi_wfull = '0' ) then
            spi_wdata <= av_test.writedata;
            spi_we <= '1';
        end if;
        if ( av_test.read = '1' and av_test.address(7 downto 0) = X"01" and spi_rempty = '0' ) then
            av_test.readdata <= spi_rdata;
            spi_rack <= '1';
        end if;
    end if;
    end process;

    e_spi : entity work.spi_master
    port map (
        o_sclk => o_si5342_spi_sclk,
        o_sdo => o_si5342_spi_mosi,
        i_sdi => i_si5342_spi_miso,
        o_ss_n => o_si5342_spi_ss_n,

        i_wdata => spi_wdata(7 downto 0),
        i_we => spi_we,
        o_wfull => spi_wfull,

        o_rdata => spi_rdata(7 downto 0),
        i_rack => spi_rack,
        o_rempty => spi_rempty,

        i_sclk_div => spi_sclk_div,

        i_reset_n => reset_50_n,
        i_clk => clk_50--,
    );

end architecture;
