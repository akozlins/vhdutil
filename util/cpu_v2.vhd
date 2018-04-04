library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.util.all;

entity cpu_v2 is
    port (
        debug   :   out std_logic_vector(15 downto 0);
        clk     :   in  std_logic;
        areset  :   in  std_logic--;
    );
end entity cpu_v2;

architecture arch of cpu_v2 is

    subtype word_t is std_logic_vector(15 downto 0);

    type ram_t is array (0 to 2**8-1) of word_t;
    signal ram : ram_t := (
       X"D100", X"0001", -- LDI : reg1 = 1
       X"DC00", X"00CC", -- LDI : regC = 0xCC
       X"DF00", X"0000", -- LDI : regF = 0
       X"0FF1", -- ADD : regF = regF + reg1
       X"FF0C", -- ST : *regC = regF
       X"C00C", -- DBG : debug = *regC
       X"A0FD", -- JMP : pc -= 3
       others => (others => '0')
    );

    signal address : word_t;
    signal address_q : word_t;
    signal rdata : word_t;
    signal wdata : word_t;
    signal write : std_logic;

    signal pc : word_t;

    signal ir : std_logic_vector(3 downto 0);

    signal dA : word_t;
    signal dB : word_t;
    signal dC : word_t;
    signal dC_q : word_t;

    signal aC : std_logic_vector(3 downto 0);
    signal aC_q : std_logic_vector(3 downto 0);
    signal wdC : word_t;
    signal weC : std_logic;

    type state_t is (
        S_EXEC,
        S_STORE,
        S_LOAD,
        S_LOADI,
        S_DEBUG,
        S_RESET--,
    );
    signal state : state_t;

begin

    ram_p : process(clk)
    begin
    if rising_edge(clk) then
        if(write = '1') then
            ram(to_integer(unsigned(address))) <= wdata;
        end if;
    end if; -- rising_edge
    end process ram_p;

    address <= address_q when ( state = S_STORE or state = S_LOAD or state = S_DEBUG ) else pc;
    rdata <= ram(to_integer(unsigned(address)));
    wdata <= dC_q;
    write <= '1' when ( state = S_STORE ) else '0';

    reg_file_i : reg_file
    generic map (
        W => 16,
        N => 4--,
    )
    port map (
        clk => clk,
        aA => rdata(3 downto 0),
        aB => rdata(7 downto 4),
        aC => aC,
        rdA => dA,
        rdB => dB,
        rdC => dC,
        wdC => wdC,
        weC => weC,
        areset => areset--,
    );

    aC <= aC_q when ( state = S_LOAD or state = S_LOADI ) else
          rdata(11 downto 8);
    wdC <= rdata     when ( state = S_LOAD or state = S_LOADI ) else
           dB  +  dA when ( state = S_EXEC and ir = X"0") else
           dB  -  dA when ( state = S_EXEC and ir = X"1") else
           dB and dA when ( state = S_EXEC and ir = X"2") else
           dB  or dA when ( state = S_EXEC and ir = X"3") else
           dB xor dA when ( state = S_EXEC and ir = X"4") else
           X"CCCC";
    weC <= '1' when ( state = S_LOAD or state = S_LOADI ) else
           '1' when ( state = S_EXEC and ir(ir'left) = '0' ) else
           '0';

    ir <= rdata(15 downto 12);

    process(clk, areset)
    begin
    if areset = '1' then
        state <= S_RESET;
    elsif rising_edge(clk) then
        state <= S_EXEC;
        address_q <= dB + dA;
        aC_q <= aC;
        dC_q <= dC;

        case state is
        when S_EXEC =>
            pc <= pc + 1;

            case ir is
            when X"F" => -- ST : *(regB + regA) = regC
                state <= S_STORE;
            when X"E" => -- LD : regC = *(regB + regA)
                state <= S_LOAD;
            when X"D" => -- LDI : regC = *(pc + 1)
                state <= S_LOADI;
            when X"C" => -- DBG
                state <= S_DEBUG;
            when X"A" => -- JMP : pc += rdata(7 downto 0)
                pc <= pc + ((7 downto 0 => rdata(7)) & rdata(7 downto 0));
            when others =>
                null;
            end case;

        when S_LOADI =>
            pc <= pc + 1;

        when S_DEBUG =>
            debug <= rdata;

        when S_RESET =>
            pc <= (others => '0');

        when others =>
            null;
        end case;

    end if; -- rising_edge
    end process;

end;
