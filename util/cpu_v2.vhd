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

    signal ram_addr : word_t;
    signal ram_addr_q : word_t;
    signal ram_dout : word_t;
    signal ram_din : word_t;
    signal ram_we : std_logic;

    signal pc : word_t;

    signal ir : std_logic_vector(3 downto 0);

    signal regA, regB, regC, regC_q : word_t;
    signal regC_addr, regC_addr_q : std_logic_vector(3 downto 0);
    signal regC_din : word_t;
    signal regC_we : std_logic;

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
            ram(to_integer(unsigned(ram_addr))) <= ram_din;
        end if;
    end if; -- rising_edge
    end process ram_p;

    ram_addr <= ram_addr_q when ( state = S_STORE or state = S_LOAD or state = S_DEBUG ) else pc;
    ram_dout <= ram(to_integer(unsigned(ram_addr)));
    ram_din <= regC_q;
    ram_we <= '1' when ( state = S_STORE ) else '0';

    reg_file_i : reg_file
    generic map (
        W => 16,
        N => 4--,
    )
    port map (
        clk     => clk,
        a_addr  => ram_dout(3 downto 0),
        b_addr  => ram_dout(7 downto 4),
        c_addr  => regC_addr,
        a_dout  => regA,
        b_dout  => regB,
        c_dout  => regC,
        c_din   => regC_din,
        c_we    => regC_we,
        areset  => areset--,
    );

    regC_addr <= regC_addr_q when ( state = S_LOAD or state = S_LOADI ) else
                 ram_dout(11 downto 8);
    regC_din <= ram_dout      when ( state = S_LOAD or state = S_LOADI ) else
                regB  +  regA when ( state = S_EXEC and ir = X"0" ) else
                regB  -  regA when ( state = S_EXEC and ir = X"1" ) else
                regB and regA when ( state = S_EXEC and ir = X"2" ) else
                regB  or regA when ( state = S_EXEC and ir = X"3" ) else
                regB xor regA when ( state = S_EXEC and ir = X"4" ) else
                X"CCCC";
    regC_we <= '1' when ( state = S_LOAD or state = S_LOADI ) else
               '1' when ( state = S_EXEC and ir(ir'left) = '0' ) else
               '0';

    ir <= ram_dout(15 downto 12);

    process(clk, areset)
    begin
    if areset = '1' then
        state <= S_RESET;
    elsif rising_edge(clk) then
        state <= S_EXEC;
        ram_addr_q <= regB + regA;
        regC_addr_q <= regC_addr;
        regC_q <= regC;

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
                pc <= pc + ((7 downto 0 => ram_dout(7)) & ram_dout(7 downto 0));
            when others =>
                null;
            end case;

        when S_LOADI =>
            pc <= pc + 1;

        when S_DEBUG =>
            debug <= ram_dout;

        when S_RESET =>
            pc <= (others => '0');

        when others =>
            null;
        end case;

    end if; -- rising_edge
    end process;

end;
