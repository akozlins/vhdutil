library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.util.all;

entity cpu_v1 is
    port (
        dbg_out :   out std_logic_vector(31 downto 0);
        dbg_in  :   in  std_logic_vector(31 downto 0);
        clk     :   in  std_logic;
        areset  :   in  std_logic--;
    );
end entity cpu_v1;

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

    signal address : word_t;
    signal rdata : word_t;
    signal wdata : word_t;
    signal write : std_logic;

    type reg_t is array (0 to 15) of word_t;
    signal reg : reg_t;

    signal pc : word_t;

    signal instr : std_logic_vector(3 downto 0);
    signal regC : std_logic_vector(3 downto 0);
    signal regB : word_t;
    signal regA : word_t;

    signal regC_q : std_logic_vector(3 downto 0);

    type state_t is (
        S_EXEC,
        S_ST,
        S_LD,
        S_LDI,
        S_RESET--,
    );
    signal state : state_t;

begin

    dbg_out <= reg(14) & reg(15);

    ram_p : process(clk)
    begin
    if rising_edge(clk) then
        if(write = '1') then
            ram(to_integer(unsigned(address))) <= wdata;
        end if;
    end if; -- rising_edge
    end process ram_p;

    rdata <= ram(to_integer(unsigned(address)));

    instr <= rdata(15 downto 12);
    regC <= rdata(11 downto 8);
    regB <= reg(to_integer(unsigned(rdata(7 downto 4))));
    regA <= reg(to_integer(unsigned(rdata(3 downto 0))));

    process(clk, areset)
    begin
    if areset = '1' then
        state <= S_RESET;
    elsif rising_edge(clk) then
        write <= '0';

        case state is
        when S_EXEC =>
            pc <= pc + 1;
            address <= pc + 1;

            case instr is
            when X"F" => -- ST : *(regB + regA) = regC
                address <= regB + regA;
                wdata <= reg(to_integer(unsigned(regC)));
                write <= '1';
                state <= S_ST;
            when X"E" => -- LD : regC = *(regB + regA)
                address <= regB + regA;
                regC_q <= regC;
                state <= S_LD;
            when X"D" => -- LDI : regC = *(pc + 1)
                regC_q <= regC;
                state <= S_LDI;
            when X"A" => -- JMP : pc += rdata(7 downto 0)
                pc <= pc + ((7 downto 0 => rdata(7)) & rdata(7 downto 0));
                address <= pc + ((7 downto 0 => rdata(7)) & rdata(7 downto 0));
            when X"4" => -- XOR : regC = regB xor regA
                reg(to_integer(unsigned(regC))) <= regB xor regA;
            when X"3" => -- OR : regC = regB or regA
                reg(to_integer(unsigned(regC))) <= regB or regA;
            when X"2" => -- AND : regC = regB and regA
                reg(to_integer(unsigned(regC))) <= regB and regA;
            when X"1" => -- SUB : regC = regB - regA
                reg(to_integer(unsigned(regC))) <= regB - regA;
            when X"0" => -- ADD : regC = regB + regA
                reg(to_integer(unsigned(regC))) <= regB + regA;
            when others =>
                null;
            end case;

        when S_ST =>
            address <= pc;
            state <= S_EXEC;

        when S_LD =>
            reg(to_integer(unsigned(regC_q))) <= rdata;
            address <= pc;
            state <= S_EXEC;

        when S_LDI =>
            reg(to_integer(unsigned(regC_q))) <= rdata;
            pc <= pc + 1;
            address <= pc + 1;
            state <= S_EXEC;

        when S_RESET =>
            pc <= (others => '0');
            address <= (others => '0');
            state <= S_EXEC;

        when others =>
            null;
        end case;

        reg(0) <= (others => '0');
    end if; -- rising_edge
    end process;

end;
