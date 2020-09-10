--
-- author : Alexandr Kozlinskiy
-- date : 2019-11-25
--

library ieee;
use ieee.std_logic_1164.all;

-- uart transmitter
--
-- - start bit is logic low
-- - stop bits are logic high
-- - LSB first
entity uart_tx is
generic (
    DATA_BITS_g : positive := 8;
    -- PARITY = 0 - none
    -- PARITY = 1 - odd
    -- PARITY = 2 - even
    PARITY_g : integer := 0;
    STOP_BITS_g : positive := 1;
    BAUD_RATE_g : positive := 115200; -- bps
    FIFO_ADDR_WIDTH_g : positive := 2;
    CLK_MHZ_g : real--;
);
port (
    o_data      : out   std_logic;
    -- output enable
    o_data_oe   : out   std_logic;

    i_wdata     : in    std_logic_vector(DATA_BITS_g-1 downto 0);
    i_we        : in    std_logic;
    o_wfull     : out   std_logic;

    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

architecture arch of uart_tx is

    signal rdata : std_logic_vector(DATA_BITS_g-1 downto 0);
    signal rack, rempty : std_logic;

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
    -- psl assert always ( i_we = '0' or o_wfull = '0' ) ;

    o_data <=
        -- start bit
        '0' when ( state = STATE_START ) else
        -- data bits
        rdata(data_bit) when ( state = STATE_DATA ) else
        -- parity bit
        parity when ( state = STATE_PARITY) else
        -- stop bit
        '1' when ( state = STATE_STOP ) else
        -- idle is logic high
        '1';
    o_data_oe <=
        '1' when ( state /= STATE_IDLE ) else
        '0';

    -- use fifo to buffer input data
    e_fifo : entity work.fifo_sc
    generic map (
        DATA_WIDTH_g => DATA_BITS_g,
        ADDR_WIDTH_g => FIFO_ADDR_WIDTH_g--,
    )
    port map (
        o_rdata         => rdata,
        i_rack          => rack,
        o_rempty        => rempty,

        i_wdata         => i_wdata,
        i_we            => i_we,
        o_wfull         => o_wfull,

        i_reset_n       => i_reset_n,
        i_clk           => i_clk--;
    );

    parity <=
        -- total parity odd
        '1' xor work.util.xor_reduce(rdata) when ( PARITY_g = 1 ) else
        -- total parity even
        '0' xor work.util.xor_reduce(rdata) when ( PARITY_g = 2 ) else
        '-';

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        rack <= '0';
        cnt <= 0;
        state <= STATE_IDLE;
        --
    elsif rising_edge(i_clk) then
        rack <= '0';

        -- change state at baud rate
        if ( cnt = CNT_MAX_c ) then
            case state is
            when STATE_START =>
                data_bit <= 0;
                stop_bit <= 0;
                state <= STATE_DATA;
                --
            when STATE_DATA =>
                if ( data_bit /= DATA_BITS_g-1) then
                    data_bit <= data_bit + 1;
                elsif ( PARITY_g /= 0 ) then
                    state <= STATE_PARITY;
                else
                    rack <= '1';
                    state <= STATE_STOP;
                end if;
                --
            when STATE_PARITY =>
                rack <= '1';
                state <= STATE_STOP;
                --
            when STATE_STOP =>
                if ( stop_bit /= STOP_BITS_g-1) then
                    stop_bit <= stop_bit + 1;
                elsif ( rempty = '0' ) then
                    -- continue transmission
                    state <= STATE_START;
                else
                    -- TODO : underrun error
                    state <= STATE_IDLE;
                end if;
                --
            when STATE_IDLE =>
                if ( rempty = '0' ) then
                   -- start transmission
                    state <= STATE_START;
                end if;
                --
            when others =>
                null;
            end case;

            cnt <= 0;
        else
            cnt <= cnt + 1;
        end if;
        --
    end if;
    end process;

end architecture;
