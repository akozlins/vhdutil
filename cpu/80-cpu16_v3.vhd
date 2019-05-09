--
-- Author: Alexandr Kozlinskiy
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cpu16_v3 is
    port (
        dbg_out :   out std_logic_vector(15 downto 0);
        dbg_in  :   in  std_logic_vector(15 downto 0);
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

architecture arch of cpu16_v3 is

    subtype word_t is std_logic_vector(15 downto 0);
    subtype ram_addr_t is std_logic_vector(7 downto 0);
    subtype reg_addr_t is std_logic_vector(3 downto 0);

    type state_t is (
        S_FETCH,
        S_REG,
        S_ALU,
        S_STORE,
        S_LOAD,
        S_LOADI,
        S_JUMP,
        S_RESET--,
    );
    signal state, state_next : state_t;

    -- program counter
    signal pc, pc_next : ram_addr_t;
    -- instruction register
    signal ir : word_t;
    -- flags register (carry, overflow, sign, zero)
    signal flags : std_logic_vector(3 downto 0);

    signal ram_addr : ram_addr_t;
    signal ram_rd, ram_wd : word_t;
    signal ram_we : std_logic;

    signal reg_a_addr, reg_b_addr : reg_addr_t;
    signal reg_a_rd, reg_a_rd_q, reg_b_rd, reg_b_rd_q, reg_b_wd : word_t;
    signal reg_b_we : std_logic;

    signal alu_op : std_logic_vector(2 downto 0);
    signal alu_a, alu_b, alu_y, alu_y_q : word_t;
    signal alu_ci, alu_z, alu_s, alu_v, alu_co : std_logic;

begin

    i_ram : entity work.ram_sp
    generic map (
        W => word_t'length,
        N => ram_addr_t'length,
        INIT_FILE_HEX => "../cpu/cpu_v3.hex"--,
    )
    port map (
        addr    => ram_addr,
        rd      => ram_rd,
        wd      => ram_wd,
        we      => ram_we,
        clk     => clk--,
    );

    i_reg_file : entity work.reg_file_dp
    generic map (
        W => word_t'length,
        N => reg_addr_t'length--,
    )
    port map (
        a_addr  => reg_a_addr,
        a_rd    => reg_a_rd,
        b_addr  => reg_b_addr,
        b_rd    => reg_b_rd,
        b_wd    => reg_b_wd,
        b_we    => reg_b_we,
        clk     => clk--,
    );

    i_alu : entity work.alu_v2
    generic map (
        W => word_t'length--,
    )
    port map (
        a   => alu_a,
        b   => alu_b,
        ci  => alu_ci,
        op  => alu_op,
        y   => alu_y,
        z   => alu_z,
        s   => alu_s,
        v   => alu_v,
        co  => alu_co--,
    );

    --
    --              FETCH       JUMP        REG         ALU         STORE       LOAD        LOADI
    --  ram_addr    pc          -           -           -           alu_y_q     alu_y_q     alu_y_q
    --  ram_wd      -           -           -           -           reg_b_rd    -           -
    --  ram_we      0           0           0           0           1           0           0
    --  reg_a_addr  -           -           ir(3..0)    -           -           -           -
    --  reg_b_addr  -           -           ir(7..4)    ir(11..8)   ir(11..8)   ir(11..8)   ir(11..8)
    --  reg_b_wd    -           -           -           alu_y       -           ram_rd      ram_rd
    --  reg_b_we    0           0           0           1           0           1           1
    --  alu_a       pc          pc          -           reg_a_rd_q  -           -           pc
    --  alu_b       1           ir(7..0)    -           reg_b_rd_q  -           -           2
    --

    ram_addr <= pc when ( state = S_FETCH ) else
                alu_y_q(ram_addr_t'range) when ( state = S_STORE or state = S_LOAD or state = S_LOADI) else
                (others => '-');
    ram_wd <= reg_b_rd when ( state = S_STORE ) else
              (others => '-');
    ram_we <= '1' when ( state = S_STORE ) else
              '0';

    reg_a_addr <= ir(3 downto 0) when ( state = S_REG ) else
                  (others => '-');
    reg_b_addr <= ir(7 downto 4) when ( state = S_REG ) else
                  ir(11 downto 8) when ( state = S_ALU and ir(ir'left) = '0' ) else
                  ir(11 downto 8) when ( state = S_STORE or state = S_LOAD or state = S_LOADI ) else
                  (others => '-');
    reg_b_wd <= alu_y when ( state = S_ALU and ir(ir'left) = '0' ) else
                ram_rd when ( state = S_LOAD or state = S_LOADI ) else
                (others => '-');
    reg_b_we <= '1' when ( state = S_ALU and ir(ir'left) = '0' ) else
                '1' when ( state = S_LOAD or state = S_LOADI ) else
                '0';

    alu_ci <= flags(3) when ( state = S_ALU and ir(ir'left) = '0' ) else
              '-';
    alu_a <= reg_a_rd_q when ( state = S_ALU ) else
             work.util.resize(pc, word_t'length) when ( state = S_FETCH or state = S_JUMP or state = S_LOADI ) else
             (others => '-');
    alu_b <= reg_b_rd_q when ( state = S_ALU ) else
             X"0001" when ( state = S_FETCH ) else
             std_logic_vector(resize(signed(ir(7 downto 0)), word_t'length)) when ( state = S_JUMP ) else
             X"0002" when ( state = S_LOADI ) else
             (others => '-');
    alu_op <= ir(14 downto 12) when ( state = S_ALU and ir(ir'left) = '0' ) else
              (others => '0') when ( state = S_FETCH or state = S_JUMP or state = S_ALU or state = S_LOADI ) else
              (others => '-');

    state_next <=
        -- STORE : *(reg_b + reg_a) = reg_c
        S_STORE when ( state = S_ALU and ir(15 downto 12) = X"F" ) else
        -- LOAD : reg_c = *(reg_b + reg_a)
        S_LOAD  when ( state = S_ALU and ir(15 downto 12) = X"E" ) else
        -- LOADI : reg_c = *(pc + 1)
        S_LOADI when ( state = S_FETCH and ram_rd(15 downto 12) = X"D" ) else
        -- DEBUG
        S_FETCH when ( state = S_REG and ir(15 downto 12) = X"C" ) else
        -- JUMP : pc += ram_rd(7 downto 0)
        S_JUMP  when ( state = S_FETCH and ram_rd(15 downto 12) = X"A" ) else
        --
        S_REG   when ( state = S_FETCH ) else
        S_ALU   when ( state = S_REG ) else
        S_FETCH;

    process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        state <= S_FETCH;
        pc <= (others => '0');
        --
    elsif rising_edge(clk) then

        alu_y_q <= alu_y;

        if ( state = S_REG ) then
            reg_a_rd_q <= reg_a_rd;
            reg_b_rd_q <= reg_b_rd;
        end if;

        if ( state = S_FETCH ) then
            ir <= ram_rd;
            pc_next <= alu_y(ram_addr_t'range); -- pc_next <= pc + 1
        end if;

        if ( state = S_REG and ir(15 downto 12) = X"C") then -- DEBUG
            dbg_out <= reg_a_rd;
        end if;

        if ( state = S_ALU and ir(ir'left) = '0' ) then
            flags <= alu_co & alu_v & alu_s & alu_z;
        end if;

        if ( state = S_JUMP or state = S_LOADI ) then
            pc <= alu_y(ram_addr_t'range);
        elsif ( state_next = S_FETCH ) then
            pc <= pc_next;
        end if;

        state <= state_next;

    end if; -- rising_edge
    end process;

end architecture;
