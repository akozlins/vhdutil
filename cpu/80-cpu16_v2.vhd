library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use ieee.std_logic_unsigned."+";

entity cpu16_v2 is
    port (
        dbg_out :   out std_logic_vector(15 downto 0);
        dbg_in  :   in  std_logic_vector(15 downto 0);
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

architecture arch of cpu16_v2 is

    subtype word_t is std_logic_vector(15 downto 0);
    subtype ram_addr_t is std_logic_vector(7 downto 0);
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
    -- flags register (carry, overflow, sign, zero)
    signal flags : std_logic_vector(3 downto 0);

    signal ram_addr, ram_addr_q : ram_addr_t;
    signal ram_rd, ram_wd : word_t;
    signal ram_we : std_logic;

    signal reg_c_addr, reg_c_addr_q : reg_addr_t;
    signal reg_a_rd, reg_b_rd, reg_c_rd, reg_c_rd_q, reg_c_wd : word_t;
    signal reg_c_we : std_logic;

    signal alu_a, alu_b, alu_y : word_t;
    signal alu_z, alu_s, alu_v, alu_co : std_logic;

begin

    i_ram : entity work.ram_sp
    generic map (
        W => word_t'length,
        N => ram_addr_t'length,
        INIT_FILE_HEX => "../cpu/cpu_v2.hex"--,
    )
    port map (
        addr    => ram_addr,
        rd      => ram_rd,
        wd      => ram_wd,
        we      => ram_we,
        clk     => clk--,
    );

    ram_addr <= ram_addr_q when ( state = S_STORE or state = S_LOAD ) else pc;
    ram_wd <= reg_c_rd_q;
    ram_we <= '1' when ( state = S_STORE ) else '0';

    i_reg_file : entity work.reg_file_tp
    generic map (
        W => word_t'length,
        N => reg_addr_t'length--,
    )
    port map (
        a_addr  => ram_rd(3 downto 0),
        a_rd    => reg_a_rd,
        b_addr  => ram_rd(7 downto 4),
        b_rd    => reg_b_rd,
        c_addr  => reg_c_addr,
        c_rd    => reg_c_rd,
        c_wd    => reg_c_wd,
        c_we    => reg_c_we,
        rst_n   => rst_n,
        clk     => clk--,
    );

    reg_c_addr <= reg_c_addr_q when ( state = S_LOAD or state = S_LOADI ) else
                  ram_rd(11 downto 8);
    reg_c_wd <= ram_rd when ( state = S_LOAD or state = S_LOADI ) else
                alu_y  when ( state = S_EXEC and ir(ir'left) = '0' ) else
                X"CCCC";
    reg_c_we <= '1' when ( state = S_LOAD or state = S_LOADI ) else
                '1' when ( state = S_EXEC and ir(ir'left) = '0' ) else
                '0';

    i_alu : entity work.alu_v2
    generic map (
        W => word_t'length--,
    )
    port map (
        a   => alu_a,
        b   => alu_b,
        ci  => flags(3),
        op  => ir(2 downto 0),
        y   => alu_y,
        z   => alu_z,
        s   => alu_s,
        v   => alu_v,
        co  => alu_co--,
    );

    alu_a <= reg_a_rd;
    alu_b <= reg_b_rd;

    ir <= ram_rd(15 downto 12);

    process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        state <= S_RESET;
        --
    elsif rising_edge(clk) then
        state <= S_EXEC;
        ram_addr_q <= reg_b_rd(ram_addr_t'range) + reg_a_rd(ram_addr_t'range);
        reg_c_addr_q <= reg_c_addr;
        reg_c_rd_q <= reg_c_rd;

        case state is
        when S_EXEC =>
            pc <= pc + 1;

            case ir is
            when X"F" => -- STORE : *(reg_b + reg_a) = reg_c
                state <= S_STORE;
            when X"E" => -- LOAD : reg_c = *(reg_b + reg_a)
                state <= S_LOAD;
            when X"D" => -- LOADI : reg_c = *(pc + 1)
                state <= S_LOADI;
            when X"C" => -- DEBUG
                dbg_out <= reg_a_rd;
            when X"A" => -- JUMP : pc += rdata(7 downto 0)
                if ( (reg_c_addr and flags) = reg_c_addr ) then
                    pc <= pc + std_logic_vector(resize(signed(ram_rd(7 downto 0)), ram_addr_t'length));
                end if;
            when others =>
                null;
            end case;

            if ( ir(ir'left) = '0' ) then
                flags <= alu_co & alu_v & alu_s & alu_z;
            end if;

        when S_LOADI =>
            pc <= pc + 1;

        when S_RESET =>
            pc <= (others => '0');

        when others =>
            null;
        end case;

    end if; -- rising_edge
    end process;

end architecture;
