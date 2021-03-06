--
-- author : Alexandr Kozlinskiy
-- date : 2019-11-25
--

library ieee;
use ieee.std_logic_1164.all;

-- uart receiver
--
-- - start bit is logic low
-- - stop bits are logic high
-- - LSB first
entity uart_rx is
generic (
    -- PARITY = 0 - none
    -- PARITY = 1 - odd
    -- PARITY = 2 - even
    PARITY_g : integer := 0;
    DATA_BITS_g : positive := 8;
    STOP_BITS_g : positive := 1;
    BAUD_RATE_g : positive := 115200; -- bps
    FIFO_ADDR_WIDTH_g : positive := 4;
    CLK_MHZ_g : real--;
);
port (
    -- serial data
    i_data      : in    std_logic;

    o_rdata     : out   std_logic_vector(DATA_BITS_g-1 downto 0);
    i_rack      : in    std_logic;
    o_rempty    : out   std_logic;

    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

architecture arch of uart_rx is

    signal d : std_logic_vector(1 downto 0);

    signal wdata : std_logic_vector(DATA_BITS_g-1 downto 0);
    signal we, wfull : std_logic;

    constant CNT_MAX_c : positive := positive(1000000.0 * CLK_MHZ_g / real(BAUD_RATE_g)) - 1;
    signal cnt : integer range 0 to CNT_MAX_c;

    type state_t is (
        STATE_START,
        STATE_DATA,
        STATE_PARITY,
        STATE_STOP,
        STATE_IDLE--,
    );
    signal state : state_t;

    signal data_bit : integer range 0 to DATA_BITS_g-1;
    signal parity : std_logic;
    signal stop_bit : integer range 0 to STOP_BITS_g-1;

begin

    -- psl default clock is rising_edge(i_clk) ;
    -- psl assert always ( o_rempty = '0' or i_rack = '0' ) ;

    d(0) <= i_data;
    process(i_clk, i_reset_n)
    begin
    if rising_edge(i_clk) then
        d(1) <= d(0);
    end if;
    end process;

    -- use fifo to buffer output data
    e_fifo : entity work.fifo_sc
    generic map (
        DATA_WIDTH_g => DATA_BITS_g,
        ADDR_WIDTH_g => FIFO_ADDR_WIDTH_g--,
    )
    port map (
        o_rdata         => o_rdata,
        i_rack          => i_rack,
        o_rempty        => o_rempty,

        i_wdata         => wdata,
        i_we            => we,
        o_wfull         => wfull,

        i_reset_n       => i_reset_n,
        i_clk           => i_clk--;
    );

    parity <=
        -- total parity odd
        '1' xor work.util.xor_reduce(wdata) when ( PARITY_g = 1 ) else
        -- total parity even
        '0' xor work.util.xor_reduce(wdata) when ( PARITY_g = 2 ) else
        '-';

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        we <= '0';
        cnt <= 0;
        state <= STATE_IDLE;
        --
    elsif rising_edge(i_clk) then
        we <= '0';

        -- baud rate counter
        if ( cnt = CNT_MAX_c ) then
            cnt <= 0;
        else
            cnt <= cnt + 1;
        end if;

        if ( d(0) /= d(1) and d(1) = '1' and state = STATE_IDLE ) then
            cnt <= 0;
            state <= STATE_START;
        end if;

        -- change state and sample data at baud half-phase
        if ( cnt = CNT_MAX_c / 2 ) then
            case state is
            when STATE_START =>
                if ( wfull = '1' ) then
                    -- TODO : overrun error
                end if;

                data_bit <= 0;
                stop_bit <= 0;
                state <= STATE_DATA;
                --
            when STATE_DATA =>
                wdata(data_bit) <= i_data;

                if ( data_bit /= DATA_BITS_g-1) then
                    data_bit <= data_bit + 1;
                elsif ( PARITY_g /= 0 ) then
                    state <= STATE_PARITY;
                else
                    we <= '1';
                    state <= STATE_STOP;
                end if;
                --
            when STATE_PARITY =>
                if ( i_data /= parity ) then
                    -- TODO : parity error
                end if;

                we <= '1';
                state <= STATE_STOP;
                --
            when STATE_STOP =>
                if ( i_data /= '1' ) then
                    -- TODO : framing error
                    if ( wdata = (wdata'range => '0') ) then
                        -- TODO : break condition
                    end if;
                end if;

                if ( stop_bit /= STOP_BITS_g-1) then
                    stop_bit <= stop_bit + 1;
                else
                    state <= STATE_IDLE;
                end if;
                --
            when others =>
                null;
            end case;
        end if;
        --
    end if;
    end process;

end architecture;
