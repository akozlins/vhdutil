--
-- author : Alexandr Kozlinskiy
-- date : 2021-05-18
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- SPI master
--
-- - ...
entity spi_master is
generic (
    g_DATA_WIDTH : positive := 8;
    g_FIFO_ADDR_WIDTH : positive := 2;
    g_CLK_MHZ : real--;
);
port (
    i_wdata     : out   std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_we        : in    std_logic;
    o_wfull     : out   std_logic;

    o_rdata     : out   std_logic_vector(g_DATA_WIDTH-1 downto 0);
    i_rack      : in    std_logic;
    o_rempty    : out   std_logic;

    o_ss        : out   std_logic;
    o_sck       : out   std_logic;
    o_mosi      : out   std_logic;
    i_miso      : in    std_logic;

    -- number of cycles between sck clock transitions
    i_sck_n     : in    std_logic_vector(15 downto 0) := (others => '0');
    -- clock polarity
    i_cpol      : in    std_logic := '0';
    -- clock phase (separate for mosi and miso)
    -- - cpha = 0 -> sample on first clock transitions
    -- - cpha = 1 -> sample on second clock transition
    i_mosi_cpha : in    std_logic := '0';
    i_miso_cpha : in    std_logic := '0';

    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

architecture arch of spi_master is

    -- sck clock
    signal sck_cnt : unsigned(15 downto 0);
    signal sck_q, sck : std_logic;

    signal cpol, mosi_cpha, miso_cpha : std_logic;

    signal mosi_rdata, miso_wdata : std_logic_vector(g_DATA_WIDTH-1 downto 0);
    signal mosi_rack, mosi_rempty, miso_we, miso_wfull : std_logic;
    signal data_i : integer range 0 to g_DATA_WIDTH-1;

    type state_t is (
        STATE_START,
        STATE_DATA,
        STATE_STOP,
        STATE_IDLE--,
    );
    signal state : state_t;

begin

    -- generate sck clock
    process(i_clk)
    begin
    if ( i_reset_n = '0' ) then
        sck_cnt <= (others => '0');
        sck_q <= '0';
        sck <= '0';
        --
    elsif rising_edge(i_clk) then
        if ( sck_cnt = unsigned(i_sck_n) ) then
            sck_cnt <= (others => '0');
            sck <= not sck;
        else
            sck_cnt <= sck_cnt + 1;
        end if;
        sck_q <= sck;
        --
    end if;
    end process;



    e_mosi_fifo : entity work.fifo_sc
    generic map (
        DATA_WIDTH_g => g_DATA_WIDTH,
        ADDR_WIDTH_g => g_FIFO_ADDR_WIDTH--,
    )
    port map (
        o_rdata         => mosi_rdata,
        i_rack          => mosi_rack,
        o_rempty        => mosi_rempty,

        i_wdata         => i_wdata,
        i_we            => i_we,
        o_wfull         => o_wfull,

        i_reset_n       => i_reset_n,
        i_clk           => i_clk--;
    );

    e_miso_fifo : entity work.fifo_sc
    generic map (
        DATA_WIDTH_g => g_DATA_WIDTH,
        ADDR_WIDTH_g => g_FIFO_ADDR_WIDTH--,
    )
    port map (
        o_rdata         => o_rdata,
        i_rack          => i_rack,
        o_rempty        => o_rempty,

        i_wdata         => miso_wdata,
        i_we            => miso_we,
        o_wfull         => miso_wfull,

        i_reset_n       => i_reset_n,
        i_clk           => i_clk--;
    );



    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n = '0' ) then
        o_ss <= '0';
        o_sck <= '0';
        o_mosi <= 'Z';
        cpol <= '0';
        mosi_cpha <= '0';
        miso_cpha <= '0';
        mosi_rack <= '0';
        miso_we <= '0';
        state <= STATE_IDLE;
        --
    elsif rising_edge(i_clk) then
        mosi_rack <= '0';
        miso_we <= '0';

        case state is
        when STATE_IDLE =>
            o_ss <= '0';
            o_sck <= i_cpol;
            if ( mosi_rempty = '0' ) then
                cpol <= i_cpol;
                mosi_cpha <= i_mosi_cpha;
                miso_cpha <= i_miso_cpha;
                state <= STATE_START;
            end if;
            --
        when STATE_START =>
            -- set ss on sck falling edge
            if ( sck_q = '1' and sck = '0' ) then
                o_ss <= '1';
                state <= STATE_DATA;
                data_i <= 0;
            end if;
            --
        when STATE_DATA =>
            -- update mosi
            if ( (mosi_cpha = '0' and sck_q = '1' and sck = '0') or
                 (mosi_cpha = '1' and sck_q = '0' and sck = '1') ) then
                o_mosi <= mosi_rdata(data_i);
                o_sck <= sck xor cpol;

                if ( data_i = g_DATA_WIDTH-1 ) then
                    mosi_rack <= '1';
                    miso_we <= '1';
                    data_i <= 0;
                else
                    data_i <= data_i + 1;
                end if;
            end if;

            -- sample miso
            if ( (miso_cpha = '0' and sck_q = '0' and sck = '1') or
                 (miso_cpha = '1' and sck_q = '1' and sck = '0') ) then
                -- TODO: msb or lsb first
                miso_wdata(data_i) <= i_miso;
                o_sck <= sck xor cpol;
            end if;

            if ( mosi_rempty = '1' ) then
                state <= STATE_STOP;
            end if;
            --
        when STATE_STOP =>
            -- reset ss on sck rising edge
            if ( sck_q = '0' and sck = '1' ) then
                o_ss <= '0';
                o_mosi <= 'Z';
                state <= STATE_IDLE;
            end if;
            --
        when others =>
            null;
        end case;
        --
    end if;
    end process;

end architecture;
