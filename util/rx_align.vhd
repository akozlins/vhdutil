--
-- author : Alexandr Kozlinskiy
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rx_align is
generic (
    -- channel width in bytes
    CHANNEL_WIDTH_g : positive := 32;
    -- control symbol
    K_g : std_logic_vector(7 downto 0) := X"BC"--;
);
port (
    o_data      :   out std_logic_vector(CHANNEL_WIDTH_g-1 downto 0);
    o_datak     :   out std_logic_vector(CHANNEL_WIDTH_g/8-1 downto 0);

    o_locked    :   out std_logic;

    i_data      :   in  std_logic_vector(CHANNEL_WIDTH_g-1 downto 0);
    i_datak     :   in  std_logic_vector(CHANNEL_WIDTH_g/8-1 downto 0);

    i_syncstatus        :   in  std_logic_vector(CHANNEL_WIDTH_g/8-1 downto 0);
    i_patterndetect     :   in  std_logic_vector(CHANNEL_WIDTH_g/8-1 downto 0);
    o_enapatternalign   :   out std_logic;

    i_errdetect :   in  std_logic_vector(CHANNEL_WIDTH_g/8-1 downto 0);
    i_disperr   :   in  std_logic_vector(CHANNEL_WIDTH_g/8-1 downto 0);

    i_reset_n   :   in  std_logic;
    i_clk       :   in  std_logic--;
);
end entity;

architecture arch of rx_align is

    signal data : std_logic_vector(63 downto 0);
    signal datak : std_logic_vector(7 downto 0);

    signal enapatternalign_cnt : unsigned(7 downto 0);

    signal locked : std_logic;
    signal pattern : std_logic_vector(3 downto 0);

    -- quality counter
    -- - increment if good pattern
    -- - decrement if error
    signal quality : integer range 0 to 7;

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
        data(31 downto 0) <= data(63 downto 32);
        datak(3 downto 0) <= datak(7 downto 4);
        data(CHANNEL_WIDTH_g-1 + 32 downto 32) <= i_data;
        datak(CHANNEL_WIDTH_g/8-1 + 4 downto 4) <= i_datak;
        --
    end if;
    end process;

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        o_enapatternalign <= '0';
        enapatternalign_cnt <= (others => '0');
        --
    elsif rising_edge(i_clk) then
        o_enapatternalign <= '0';
        enapatternalign_cnt <= (others => '0');

        -- generate rising edge if not locked
        if ( locked = '0' ) then
            -- generate one clock cycle pulse to prevent being stuck at '1'
            if ( enapatternalign_cnt = (enapatternalign_cnt'range => '1') ) then
                o_enapatternalign <= '1';
            end if;
            enapatternalign_cnt <= enapatternalign_cnt + 1;
        end if;
        --
    end if;
    end process;

    process(i_clk, i_reset_n)
        variable error_v : boolean;
        variable pattern_v : std_logic_vector(3 downto 0);
        --
    begin
    if ( i_reset_n = '0' ) then
        locked <= '0';
        pattern <= "0000";
        quality <= 0;
        o_data <= (others => '0');
        o_datak <= (others => '1');
        --
    elsif rising_edge(i_clk) then
        error_v := false;
        pattern_v := (others => '0');
        pattern_v(i_patterndetect'range) := i_patterndetect;

        if ( pattern_v = "0000" ) then
            -- idle
        elsif ( pattern_v = "0001" or pattern_v = "0010" or pattern_v = "0100" or pattern_v = "1000" ) then
            if ( pattern /= "0000" and pattern /= pattern_v) then
                -- unexpected pattern
                error_v := true;
            end if;

            -- require one control symbol
            if ( pattern_v(i_datak'range) /= i_datak ) then
                error_v := true;
            end if;

            -- check control symbol
            if ( pattern_v = "0001" and i_data(7 downto 0) /= K_g ) then
                error_v := true;
            end if;
            if ( pattern_v = "0010" and i_data(15 downto 8) /= K_g ) then
                error_v := true;
            end if;
            if ( pattern_v = "0100" and i_data(23 downto 16) /= K_g ) then
                error_v := true;
            end if;
            if ( pattern_v = "1000" and i_data(31 downto 24) /= K_g ) then
                error_v := true;
            end if;
        else
            -- invalid pattern
            error_v := true;
        end if;

        -- NOTE:
        -- rx_syncstatus is driven high and _stay_ high for 20 bit interface
        -- and driven high for _one_ clock cycle for 10 bit interface
        if ( error_v
--            or i_syncstatus /= (i_syncstatus'range => '1')
            or i_errdetect /= (i_errdetect'range => '0')
            or i_disperr /= (i_disperr'range => '0')
        ) then
            if ( quality = 0 ) then
                -- not locked
                locked <= '0';
                pattern <= "0000";
            else
                quality <= quality - 1;
            end if;
        elsif ( pattern_v /= "0000" ) then
            -- good pattern
            if ( quality = 7 ) then
                -- locked
                locked <= '1';
                pattern <= pattern_v;
            else
                quality <= quality + 1;
            end if;
        end if;

        -- default value is invalid K byte
        o_data <= (others => '0');
        o_datak <= (others => '1');

        -- align such that LSByte is comma
        case pattern is
        when "0001" =>
            o_data <= data(CHANNEL_WIDTH_g-1 + 0 downto 0);
            o_datak <= datak(CHANNEL_WIDTH_g/8-1 + 0 downto 0);
        when "0010" =>
            o_data <= data(CHANNEL_WIDTH_g-1 + 8 downto 8);
            o_datak <= datak(CHANNEL_WIDTH_g/8-1 + 1 downto 1);
        when "0100" =>
            o_data <= data(CHANNEL_WIDTH_g-1 + 16 downto 16);
            o_datak <= datak(CHANNEL_WIDTH_g/8-1 + 2 downto 2);
        when "1000" =>
            o_data <= data(CHANNEL_WIDTH_g-1 + 24 downto 24);
            o_datak <= datak(CHANNEL_WIDTH_g/8-1 + 3 downto 3);
        when others =>
            null;
        end case;

        --
    end if; -- rising_edge
    end process;

end architecture;
