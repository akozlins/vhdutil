library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.util.all;

entity cpu_v3 is
    port (
        dbg_out :   out std_logic_vector(31 downto 0);
        dbg_in  :   in  std_logic_vector(31 downto 0);
        clk     :   in  std_logic;
        areset  :   in  std_logic--;
    );
end entity cpu_v3;

architecture arch of cpu_v3 is

    subtype word_t is std_logic_vector(15 downto 0);

    type state_t is (
        S_FETCH,
        S_REG_READ,
        S_ALU,
        S_REG_WRITE,
        S_LOAD,
        S_LOADI,
        S_STORE,
        S_RESET--,
    );
    signal state : state_t;

    signal pc : word_t;

    signal ram_addr : word_t;
    signal ram_rd : word_t;
    signal ram_wd : word_t;
    signal ram_we : std_logic;

    -- instruction register
    signal ir : std_logic_vector(3 downto 0);
    -- flags register (carry, overflow, sign, zero)
    signal flags : std_logic_vector(3 downto 0);

    signal regA, regB, regC : word_t;
    signal regA_addr, regB_addr, regC_addr : std_logic_vector(3 downto 0);
    signal regC_wd : word_t;
    signal regC_we : std_logic;

    signal alu_op : std_logic_vector(2 downto 0);
    signal alu_a, alu_b, alu_y : word_t;
    signal alu_ci, alu_z, alu_s, alu_v, alu_co : std_logic;

begin

    ram_i : ram_v1
    generic map (
        W => 16,
        N => 8,
        INIT_FILE_HEX => "cpu_v2.hex"--,
    )
    port map (
        clk     => clk,
        addr    => ram_addr(7 downto 0),
        rd      => ram_rd,
        wd      => ram_wd,
        we      => ram_we--,
    );

    reg_file_i : reg_file
    generic map (
        W => 16,
        N => 4--,
    )
    port map (
        clk     => clk,
        a_addr  => regA_addr,
        b_addr  => regB_addr,
        c_addr  => regC_addr,
        a_dout  => regA,
        b_dout  => regB,
        c_dout  => regC,
        c_din   => regC_wd,
        c_we    => regC_we,
        areset  => areset--,
    );

    alu_i : alu_v2
    generic map (
        W => 16--,
    )
    port map (
        ci  => alu_ci,
        a   => alu_a,
        b   => alu_b,
        op  => alu_op,
        y   => alu_y,
        z   => alu_z,
        s   => alu_s,
        v   => alu_v,
        co  => alu_co--,
    );

    process(clk, areset)
    begin
    if areset = '1' then
        state <= S_FETCH;
        ram_addr <= (others => '0');
        pc <= (others => '0');

    elsif rising_edge(clk) then
        ram_we <= '0';
        regC_we <= '0';
    
        case state is
        when S_FETCH =>
            state <= S_REG_READ;
            ir <= ram_rd(15 downto 12);
            regC_addr <= ram_rd(11 downto 8);
            regB_addr <= ram_rd(7 downto 4);
            regA_addr <= ram_rd(3 downto 0);

        when S_REG_READ =>
            state <= S_ALU;
            alu_ci <= flags(3);
            alu_a <= regA;
            alu_b <= regB;
            alu_op <= "000";

            case ir is
            when X"F" => -- ST : *(regB + regA) = regC
                null;
            when X"E" => -- LD : regC = *(regB + regA)
                null;
            when X"D" => -- LDI : regC = *(pc + 1)
                state <= S_LOADI;
                ram_addr <= pc + 1;
                pc <= pc + 1;
            when X"C" => -- DBG
                dbg_out <= regB & regA;
                state <= S_FETCH;
                ram_addr <= pc + 1;
                pc <= pc + 1;
            when X"B" =>
                null;
            when X"A" => -- JMP : pc += ram_rd(7 downto 0)
                alu_a <= pc;
                alu_b <= ((7 downto 0 => regB_addr(regB_addr'left)) & regB_addr & regA_addr);
            when X"9" =>
                null;
            when X"8" =>
                null;
            when others =>
                alu_op <= ir(2 downto 0);
            end case;

        when S_ALU =>
            case ir is
            when X"F" => -- ST : *(regB + regA) = regC
                state <= S_STORE;
                ram_addr <= alu_y;
                ram_wd <= regC;
                ram_we <= '1';
            when X"E" => -- LD : regC = *(regB + regA)
                state <= S_LOAD;
                ram_addr <= alu_y;
            when X"D" =>
                null;
            when X"C" =>
                null;
            when X"B" =>
                null;
            when X"A" => -- JMP : pc += ram_rd(7 downto 0)
                state <= S_FETCH;
                ram_addr <= alu_y;
                pc <= alu_y;
            when X"9" =>
                null;
            when X"8" =>
                null;
            when others =>
                state <= S_REG_WRITE;
                regC_wd <= alu_y;
                regC_we <= '1';
                flags <= alu_co & alu_v & alu_s & alu_z;
            end case;

        when S_REG_WRITE | S_STORE =>
            state <= S_FETCH;
            ram_addr <= pc + 1;
            pc <= pc + 1;

        when S_LOAD | S_LOADI =>
            state <= S_REG_WRITE;
            regC_wd <= ram_rd;
            regC_we <= '1';

        when others =>
            null;
        end case;

    end if; -- rising_edge
    end process;

end;
