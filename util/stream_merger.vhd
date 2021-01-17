library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- merge packets delimited by SOP and EOP from N input streams
entity stream_merger is
generic (
    W : positive := 32;
    N : positive--;
);
port (
    -- input streams
    i_rdata     : in    std_logic_vector(N*W-1 downto 0);
    i_rsop      : in    std_logic_vector(N-1 downto 0); -- start of packet (SOP)
    i_reop      : in    std_logic_vector(N-1 downto 0); -- end of packet (EOP)
    i_rempty    : in    std_logic_vector(N-1 downto 0);
    o_rack      : out   std_logic_vector(N-1 downto 0); -- read ACK

    -- output stream
    o_wdata     : out   std_logic_vector(W-1 downto 0);
    o_wsop      : out   std_logic; -- SOP
    o_weop      : out   std_logic; -- EOP
    i_wfull     : in    std_logic;
    o_we        : out   std_logic; -- write enable

    i_reset_n   : in    std_logic;
    i_clk       : in    std_logic--;
);
end entity;

architecture arch of stream_merger is

    -- get next (Round-Robin) index such that empty(index) = '0'
    function next_index (
        index : integer;
        empty : std_logic_vector--;
    ) return integer is
        variable i : integer;
    begin
        for j in 1 to empty'length loop
            i := (index + j) mod empty'length;
            exit when ( empty(i) = '0' );
        end loop;
        return i;
    end function;

    type data_array_t is array (natural range <>) of std_logic_vector(W-1 downto 0);
    signal rdata : data_array_t(N-1 downto 0);

    -- current index
    signal index : integer range 0 to N-1 := 0;

    -- SOP mark
    signal busy : std_logic;

begin

    generate_rdata : for i in 0 to N-1 generate
        rdata(i) <= i_rdata(W-1 + i*W downto i*W);
    end generate;

    -- set rack for current not empty input (and not full and not reset)
    process(index, i_rempty, i_reset_n)
    begin
        o_rack <= (others => '0');
        if ( i_rempty(index) = '0' and i_wfull = '0' and i_reset_n = '1' ) then
            o_rack(index) <= '1';
        end if;
    end process;

    process(i_clk, i_reset_n)
    begin
    if ( i_reset_n /= '1' ) then
        o_wdata <= (others => '0');
        o_wsop <= '0';
        o_weop <= '0';
        o_we <= '0';

        index <= 0;
        busy <= '0';
        --
    elsif rising_edge(i_clk) then
        o_wdata <= rdata(index);
        o_wsop <= i_rsop(index);
        o_weop <= i_reop(index);
        o_we <= '0';

        if ( i_rempty(index) = '0' and i_wfull = '0' ) then
            -- write data
            o_we <= '1';

            if ( i_rsop(index) = '1' ) then
                -- set SOP mark
                busy <= '1';
            end if;

            if ( i_reop(index) = '1' ) then
                -- reset SOP mark
                busy <= '0';
                -- go to next index
                index <= next_index(index, i_rempty);
            end if;
        elsif ( busy = '0' ) then
            -- go to next index
            index <= next_index(index, i_rempty);
        end if;

        --
    end if;
    end process;

end architecture;
