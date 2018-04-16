library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.util.all;

entity cpu_v1 is
    port (
        dbg_out :   out std_logic_vector(31 downto 0);
        dbg_in  :   in  std_logic_vector(31 downto 0);
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

architecture arch of cpu_v1 is

    subtype word_t is std_logic_vector(15 downto 0);

    type ram_t is array (0 to 2**8-1) of word_t;
    signal ram : ram_t := (
       X"D100", X"0001", -- LDI : reg1 = 1
       X"DF00", X"0000", -- LDI : reg15 = 0
       X"0FF1", -- ADD : reg15 = reg15 + reg1
       X"A0FF", -- JMP : pc -= 1
       others => (others => '0')
    );

    signal ram_addr : word_t;
    signal ram_rd : word_t;
    signal ram_wd : word_t;
    signal ram_we : std_logic;

    type reg_t is array (0 to 15) of word_t;
    signal reg : reg_t;

    signal pc : word_t;

    signal ir : std_logic_vector(3 downto 0);
    signal regC_addr : std_logic_vector(3 downto 0);
    signal regB : word_t;
    signal regA : word_t;

    signal regC_addr_q : std_logic_vector(3 downto 0);

    type state_t is (
        S_EXEC,
        S_STORE,
        S_LOAD,
        S_LOADI,
        S_RESET--,
    );
    signal state : state_t;

begin

    dbg_out <= reg(14) & reg(15);

    process(clk)
    begin
    if rising_edge(clk) then
        if ( ram_we = '1' ) then
            ram(to_integer(unsigned(ram_addr))) <= ram_wd;
        end if;
    end if; -- rising_edge
    end process;

    ram_rd <= ram(to_integer(unsigned(ram_addr)));

    ir <= ram_rd(15 downto 12);
    regC_addr <= ram_rd(11 downto 8);
    regB <= reg(to_integer(unsigned(ram_rd(7 downto 4))));
    regA <= reg(to_integer(unsigned(ram_rd(3 downto 0))));

    process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        state <= S_RESET;
    elsif rising_edge(clk) then
        ram_we <= '0';

        case state is
        when S_EXEC =>
            pc <= pc + 1;
            ram_addr <= pc + 1;

            case ir is
            when X"F" => -- ST : *(regB + regA) = regC
                ram_addr <= regB + regA;
                ram_wd <= reg(to_integer(unsigned(regC_addr)));
                ram_we <= '1';
                state <= S_STORE;
            when X"E" => -- LD : regC = *(regB + regA)
                ram_addr <= regB + regA;
                regC_addr_q <= regC_addr;
                state <= S_LOAD;
            when X"D" => -- LDI : regC = *(pc + 1)
                regC_addr_q <= regC_addr;
                state <= S_LOADI;
            when X"A" => -- JMP : pc += rdata(7 downto 0)
                pc <= pc + ((7 downto 0 => ram_rd(7)) & ram_rd(7 downto 0));
                ram_addr <= pc + ((7 downto 0 => ram_rd(7)) & ram_rd(7 downto 0));
            when X"4" => -- XOR : regC = regB xor regA
                reg(to_integer(unsigned(regC_addr))) <= regB xor regA;
            when X"3" => -- OR : regC = regB or regA
                reg(to_integer(unsigned(regC_addr))) <= regB or regA;
            when X"2" => -- AND : regC = regB and regA
                reg(to_integer(unsigned(regC_addr))) <= regB and regA;
            when X"1" => -- SUB : regC = regB - regA
                reg(to_integer(unsigned(regC_addr))) <= regB - regA;
            when X"0" => -- ADD : regC = regB + regA
                reg(to_integer(unsigned(regC_addr))) <= regB + regA;
            when others =>
                null;
            end case;

        when S_STORE =>
            ram_addr <= pc;
            state <= S_EXEC;

        when S_LOAD =>
            reg(to_integer(unsigned(regC_addr_q))) <= ram_rd;
            ram_addr <= pc;
            state <= S_EXEC;

        when S_LOADI =>
            reg(to_integer(unsigned(regC_addr_q))) <= ram_rd;
            pc <= pc + 1;
            ram_addr <= pc + 1;
            state <= S_EXEC;

        when S_RESET =>
            pc <= (others => '0');
            ram_addr <= (others => '0');
            state <= S_EXEC;

        when others =>
            null;
        end case;

        reg(0) <= (others => '0');
    end if; -- rising_edge
    end process;

end architecture;
