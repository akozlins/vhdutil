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

        spi_master_sclk => o_si5342_spi_sclk,
        spi_master_sdo => o_si5342_spi_mosi,
        spi_master_sdi => i_si5342_spi_miso,
        spi_master_ss_n(0) => o_si5342_spi_ss_n,

        avm_test_address        => av_test.address(7 downto 0),
        avm_test_read           => av_test.read,
        avm_test_readdata       => av_test.readdata,
        avm_test_write          => av_test.write,
        avm_test_writedata      => av_test.writedata,
        avm_test_waitrequest    => av_test.waitrequest,

        rst_reset_n => reset_50_n,
        clk_clk => clk_50--,
    );

end architecture;
