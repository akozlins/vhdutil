--
-- author : Alexandr Kozlinskiy
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rx_align is
generic (
    -- channel width in bytes
    g_BYTES : positive := 4;
    -- control symbol
    g_K : std_logic_vector(7 downto 0) := X"BC"--;
);
port (
    o_data      :   out std_logic_vector(g_BYTES*8-1 downto 0);
    o_datak     :   out std_logic_vector(g_BYTES-1 downto 0);
    o_locked    :   out std_logic;

    o_bitslip   :   out std_logic;

    i_data      :   in  std_logic_vector(g_BYTES*8-1 downto 0);
    i_datak     :   in  std_logic_vector(g_BYTES-1 downto 0);
    i_error     :   in  std_logic;

    i_reset_n   :   in  std_logic;
    i_clk       :   in  std_logic--;
);
end entity;

architecture arch of rx_align is

    signal data : std_logic_vector(63 downto 0);
    signal datak : std_logic_vector(7 downto 0);

    signal timeout : unsigned(7 downto 0);

    signal locked : std_logic;
    signal pattern, pattern_q : std_logic_vector(3 downto 0);

    -- quality counter
    -- - increment if good pattern
    -- - decrement if error
    signal quality : unsigned (3 downto 0);

begin

    o_locked <= locked;

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        data <= (others => '0');
        datak <= (others => '0');
        --
    elsif rising_edge(i_clk) then
        data <= (others => '0');
        datak <= (others => '0');
        -- assume link is LSBit first
        data(g_BYTES*8-1 downto 0) <= data(g_BYTES*8-1 + g_BYTES*8 downto g_BYTES*8);
        datak(g_BYTES-1 downto 0) <= datak(g_BYTES-1 + g_BYTES downto g_BYTES);
        data(g_BYTES*8-1 + g_BYTES*8 downto g_BYTES*8) <= i_data;
        datak(g_BYTES-1 + g_BYTES downto g_BYTES) <= i_datak;
        --
    end if;
    end process;

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        o_bitslip <= '0';
        timeout <= (others => '0');
        --
    elsif rising_edge(i_clk) then
        o_bitslip <= '0';
        timeout <= (others => '0');

        -- generate rising edge if not locked
        if ( locked = '0' ) then
            -- assert rx_bitslip signal for two parallel clock cycles
            if ( timeout(timeout'left downto 1) = (timeout'left downto 1 => '1') ) then
                o_bitslip <= '1';
            end if;
            timeout <= timeout + 1;
        end if;
        --
    end if;
    end process;

    process(i_data, i_datak)
    begin
        pattern <= (others => '0');
        for i in i_datak'range loop
            pattern(i) <= work.util.to_std_logic(i_data(7 + 8*i downto 8*i + 0) = g_K and i_datak(i) = '1');
        end loop;
    end process;

    process(i_clk, i_reset_n)
        variable error_v : boolean;
        --
    begin
    if ( i_reset_n = '0' ) then
        locked <= '0';
        quality <= (others => '0');
        o_data <= (others => '0');
        o_datak <= (others => '1');
        --
    elsif rising_edge(i_clk) then
        error_v := false;

        if ( pattern = "0001" or pattern = "0010" or pattern = "0100" or pattern = "1000" ) then
            if ( pattern_q /= "0000" and pattern_q /= pattern) then
                -- unexpected pattern
                error_v := true;
            end if;
        elsif ( pattern /= "0000" ) then
            -- invalid pattern
            error_v := true;
        end if;

        if ( error_v or i_error = '1' ) then
            if ( quality = (quality'range => '0') ) then
                -- not locked
                locked <= '0';
                pattern_q <= "0000";
            else
                quality <= quality - 1;
            end if;
        elsif ( pattern /= "0000" ) then
            -- good pattern
            if ( quality = (quality'range => '1') ) then
                -- locked
                locked <= '1';
                pattern_q <= pattern;
            else
                quality <= quality + 1;
            end if;
        end if;

        -- default output is invalid K bytes
        o_data <= (others => '0');
        o_datak <= (others => '1');

        -- align such that LSByte is K (comma)
        case pattern_q is
        when "0001" =>
            o_data <= data(g_BYTES*8-1 + 0 downto 0);
            o_datak <= datak(g_BYTES-1 + 0 downto 0);
        when "0010" =>
            o_data <= data(g_BYTES*8-1 + 8 downto 8);
            o_datak <= datak(g_BYTES-1 + 1 downto 1);
        when "0100" =>
            o_data <= data(g_BYTES*8-1 + 16 downto 16);
            o_datak <= datak(g_BYTES-1 + 2 downto 2);
        when "1000" =>
            o_data <= data(g_BYTES*8-1 + 24 downto 24);
            o_datak <= datak(g_BYTES-1 + 3 downto 3);
        when others =>
            null;
        end case;

        --
    end if; -- rising_edge
    end process;

end architecture;
