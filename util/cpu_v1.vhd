library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.util.all;

entity cpu_v1 is
    port (
        reg15   :   out std_logic_vector(15 downto 0);
        clk     :   in  std_logic;
        areset  :   in  std_logic--;
    );
end entity cpu_v1;

architecture arch of cpu_v1 is

    subtype word_t is std_logic_vector(15 downto 0);

    type ram_t is array (0 to 2**8-1) of word_t;
    signal ram : ram_t := (
       X"D100", X"0001", -- ldi reg1 = 1
       X"DF00", X"0000", -- ldi : reg15 = 0
       X"0FF1", -- add : reg15 = reg15 + reg1
       X"A0FF", -- jmp : pc -= 1
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
    signal regA : word_t;
    signal regB : word_t;
    signal regC : std_logic_vector(3 downto 0);
    signal regC_q : std_logic_vector(3 downto 0);

    type state_t is (
        S_RESET,
        S_EXEC,
        S_ST,
        S_LD,
        S_LDI--,
    );
    signal state : state_t;

begin

    reg15 <= reg(15);

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
        regC_q <= regC;

        if state = S_RESET then
            pc <= (others => '0');
            address <= (others => '0');
            state <= S_EXEC;

        elsif state = S_EXEC then
            pc <= pc + 1;
            address <= pc + 1;

            case instr is
            when X"F" => -- st : *regC = regA
                address <= reg(to_integer(unsigned(regC)));
                wdata <= regA;
                write <= '1';
                state <= S_ST;
            when X"E" => -- ld : regC = *regA
                address <= regA;
                state <= S_LD;
            when X"D" => -- ldi : regC = I
                state <= S_LDI;
            when X"A" => -- jmp : pc += rdata(7 downto 0)
                pc <= pc + ((7 downto 0 => rdata(7)) & rdata(7 downto 0));
                address <= pc + ((7 downto 0 => rdata(7)) & rdata(7 downto 0));
--                if rdata(7) = '0' then
--                    pc <= pc + (X"00" & rdata(7 downto 0));
--                    address <= pc + (X"00" & rdata(7 downto 0));
--                else
--                    pc <= pc + (X"FF" & rdata(7 downto 0));
--                    address <= pc + (X"FF" & rdata(7 downto 0));
--                end if;
            when X"0" => -- add : regC = regA + regB
                reg(to_integer(unsigned(regC))) <= regA + regB;
            when others =>
                null;
            end case;

        elsif state = S_LD then
            reg(to_integer(unsigned(regC_q))) <= rdata;
            address <= pc;
            state <= S_EXEC;

        elsif state = S_ST then
            address <= pc;
            state <= S_EXEC;

        elsif state = S_LDI then
            reg(to_integer(unsigned(regC_q))) <= rdata;
            pc <= pc + 1;
            address <= pc + 1;
            state <= S_EXEC;

        end if;

        reg(0) <= (others => '0');
    end if; -- rising_edge
    end process;

end;
