--
-- Author: Alexandr Kozlinskiy
--

library ieee;
use ieee.std_logic_1164.all;

-- 16bit cpu
--
-- instructions:
--  - STORE
--  - LOAD
--  - LOADI
--  - JUMP
--  - ADD
--
entity cpu16_v1 is
    port (
        dbg_out :   out std_logic_vector(15 downto 0);
        dbg_in  :   in  std_logic_vector(15 downto 0);
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

library ieee;
use ieee.numeric_std.all;

architecture arch of cpu16_v1 is

    subtype word_t is std_logic_vector(15 downto 0);
    subtype ram_addr_t is unsigned(7 downto 0);
    subtype reg_addr_t is std_logic_vector(3 downto 0);

    type state_t is (
        S_EXEC,
        S_STORE,
        S_LOAD,
        S_LOADI,
        S_RESET--,
    );
    signal state : state_t;

    -- program counter
    signal pc : ram_addr_t;
    -- instruction register
    signal ir : std_logic_vector(3 downto 0);

    type ram_t is array (natural range <>) of word_t;

    signal ram : ram_t(0 to 2**ram_addr_t'length-1) := (
       X"D100", X"0001", -- LDI : reg(1) = 1
       X"DC00", X"0000", -- LDI : reg(C) = 0
       X"0CC1", -- ADD : reg(C) = reg(C) + reg(1)
       X"A0FF", -- JMP : pc -= 1
       others => (others => '0')
    );

    signal ram_addr : ram_addr_t;
    signal ram_rd, ram_wd : word_t;
    signal ram_we : std_logic;

    signal reg : ram_t(0 to 2**reg_addr_t'length-1);

    alias reg_a_addr : reg_addr_t is ram_rd(3 downto 0);
    alias reg_b_addr : reg_addr_t is ram_rd(7 downto 4);
    alias reg_c_addr : reg_addr_t is ram_rd(11 downto 8);

    signal reg_a_rd, reg_b_rd : word_t;
    signal reg_c_addr_q : reg_addr_t;

begin

    dbg_out <= reg(16#C#);

    process(clk)
    begin
    if rising_edge(clk) then
        if ( ram_we = '1' ) then
            ram(to_integer(ram_addr)) <= ram_wd;
        end if;
    end if; -- rising_edge
    end process;

    ram_rd <= ram(to_integer(ram_addr));

    ir <= ram_rd(15 downto 12);
    reg_b_rd <= reg(to_integer(unsigned(reg_b_addr)));
    reg_a_rd <= reg(to_integer(unsigned(reg_a_addr)));

    process(clk, rst_n)
        variable addr_v : ram_addr_t;
    begin
    if ( rst_n = '0' ) then
        state <= S_RESET;
        --
    elsif rising_edge(clk) then
        ram_we <= '0';

        case state is
        when S_EXEC =>
            pc <= pc + 1;
            ram_addr <= pc + 1;

            case ir is
            when X"F" => -- STORE : *(reg_b + reg_a) = reg_c
                ram_addr <= unsigned(reg_b_rd(ram_addr_t'range)) + unsigned(reg_a_rd(ram_addr_t'range));
                ram_wd <= reg(to_integer(unsigned(reg_c_addr)));
                ram_we <= '1';
                state <= S_STORE;
            when X"E" => -- LOAD : reg_c = *(reg_b + reg_a)
                ram_addr <= unsigned(reg_b_rd(ram_addr_t'range)) + unsigned(reg_a_rd(ram_addr_t'range));
                reg_c_addr_q <= reg_c_addr;
                state <= S_LOAD;
            when X"D" => -- LOADI : reg_c = *(pc + 1)
                reg_c_addr_q <= reg_c_addr;
                state <= S_LOADI;
            when X"A" => -- JUMP : pc += rdata(7 downto 0)
                addr_v := (others => ram_rd(7));
                addr_v(7 downto 0) := unsigned(ram_rd(7 downto 0));
                pc <= pc + addr_v;
                ram_addr <= pc + addr_v;
            when X"0" => -- ADD : reg_c = reg_b + reg_a
                reg(to_integer(unsigned(reg_c_addr))) <= word_t(unsigned(reg_b_rd) + unsigned(reg_a_rd));
            when others =>
                null;
            end case;

        when S_STORE =>
            ram_addr <= pc;
            state <= S_EXEC;

        when S_LOAD =>
            reg(to_integer(unsigned(reg_c_addr_q))) <= ram_rd;
            ram_addr <= pc;
            state <= S_EXEC;

        when S_LOADI =>
            reg(to_integer(unsigned(reg_c_addr_q))) <= ram_rd;
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

        --
    end if; -- rising_edge
    end process;

end architecture;
