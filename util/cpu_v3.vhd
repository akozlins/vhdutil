library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.util.all;

entity cpu_v3 is
    port (
        dbg_out :   out std_logic_vector(31 downto 0);
        dbg_in  :   in  std_logic_vector(31 downto 0);
        areset  :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

architecture arch of cpu_v3 is

    subtype word_t is std_logic_vector(15 downto 0);

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
    signal state, next_state : state_t;

    signal ram_addr : word_t;
    signal ram_rd : word_t;
    signal ram_wd : word_t;
    signal ram_we : std_logic;

    signal regA_rd, regB_rd, regA_rd_q, regB_rd_q : word_t;
    signal regA_addr, regB_addr : std_logic_vector(3 downto 0);
    signal regB_wd : word_t;
    signal regB_we : std_logic;

    signal alu_op : std_logic_vector(2 downto 0);
    signal alu_a, alu_b, alu_y, alu_y_q : word_t;
    signal alu_ci, alu_z, alu_s, alu_v, alu_co : std_logic;

    -- program counter
    signal pc, next_pc : word_t;
    -- instruction register
    signal ir : word_t;
    -- flags register (carry, overflow, sign, zero)
    signal flags : std_logic_vector(3 downto 0);

begin

    ram_i : component ram_v1
    generic map (
        W => 16,
        N => 8,
        INIT_FILE_HEX => "cpu_v3.hex"--,
    )
    port map (
        addr    => ram_addr(7 downto 0),
        rd      => ram_rd,
        wd      => ram_wd,
        we      => ram_we,
        clk     => clk--,
    );

    reg_file_i : component reg_file_v3
    generic map (
        W => 16,
        N => 4--,
    )
    port map (
        a_addr  => regA_addr,
        a_rd    => regA_rd,
        b_addr  => regB_addr,
        b_rd    => regB_rd,
        b_wd    => regB_wd,
        b_we    => regB_we,
        clk     => clk--,
    );

    alu_i : component alu_v2
    generic map (
        W => 16--,
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
    --  ram_wd      -           -           -           -           regB_rd     -           -
    --  ram_we      0           0           0           0           1           0           0
    --  regA_addr   -           -           ir(3..0)    -           -           -           -
    --  regB_addr   -           -           ir(7..4)    ir(11..8)   ir(11..8)   ir(11..8)   ir(11..8)
    --  regB_wd     -           -           -           alu_y       -           ram_rd      ram_rd
    --  regB_we     0           0           0           1           0           1           1
    --  alu_a       pc          pc          -           regA_rd_q   -           -           pc
    --  alu_b       1           ir(7..0)    -           regB_rd_q   -           -           2
    --

    ram_addr <= pc when ( state = S_FETCH ) else
                alu_y_q when ( state = S_STORE or state = S_LOAD or state = S_LOADI) else
                (others => '-');
    ram_wd <= regB_rd when ( state = S_STORE ) else
              (others => '-');
    ram_we <= '1' when ( state = S_STORE ) else
              '0';

    regA_addr <= ir(3 downto 0) when ( state = S_REG ) else
                 (others => '-');
    regB_addr <= ir(7 downto 4) when ( state = S_REG ) else
                 ir(11 downto 8) when ( state = S_ALU and ir(ir'left) = '0' ) else
                 ir(11 downto 8) when ( state = S_STORE or state = S_LOAD or state = S_LOADI ) else
                 (others => '-');
    regB_wd <= alu_y when ( state = S_ALU and ir(ir'left) = '0' ) else
               ram_rd when ( state = S_LOAD or state = S_LOADI ) else
               (others => '-');
    regB_we <= '1' when ( state = S_ALU and ir(ir'left) = '0' ) else
               '1' when ( state = S_LOAD or state = S_LOADI ) else
               '0';

    alu_ci <= flags(3) when ( state = S_ALU and ir(ir'left) = '0' ) else
              '-';
    alu_a <= regA_rd_q when ( state = S_ALU ) else
             pc when ( state = S_FETCH or state = S_JUMP or state = S_LOADI ) else
             (others => '-');
    alu_b <= regB_rd_q when ( state = S_ALU ) else
             X"0001" when ( state = S_FETCH ) else
             (7 downto 0 => ir(7)) & ir(7 downto 0) when ( state = S_JUMP ) else
             X"0002" when ( state = S_LOADI ) else
             (others => '-');
    alu_op <= ir(14 downto 12) when ( state = S_ALU and ir(ir'left) = '0' ) else
              (others => '0') when ( state = S_FETCH or state = S_JUMP or state = S_ALU or state = S_LOADI ) else
              (others => '-');

    next_state <=
        -- STORE : *(regB + regA) = regC
        S_STORE when ( state = S_ALU and ir(15 downto 12) = X"F" ) else
        -- LOAD : regC = *(regB + regA)
        S_LOAD  when ( state = S_ALU and ir(15 downto 12) = X"E" ) else
        -- LOADI : regC = *(pc + 1)
        S_LOADI when ( state = S_FETCH and ram_rd(15 downto 12) = X"D" ) else
        -- DEBUG
        S_FETCH when ( state = S_REG and ir(15 downto 12) = X"C" ) else
        -- JUMP : pc += ram_rd(7 downto 0)
        S_JUMP  when ( state = S_FETCH and ram_rd(15 downto 12) = X"A" ) else
        --
        S_REG   when ( state = S_FETCH ) else
        S_ALU   when ( state = S_REG ) else
        S_FETCH;

    process(clk, areset)
    begin
    if areset = '1' then
        state <= S_FETCH;
        pc <= (others => '0');

    elsif rising_edge(clk) then

        alu_y_q <= alu_y;

        if ( state = S_REG ) then
            regA_rd_q <= regA_rd;
            regB_rd_q <= regB_rd;
        end if;

        if ( state = S_FETCH ) then
            ir <= ram_rd;
            next_pc <= alu_y; -- next_pc <= pc + 1
        end if;

        if ( state = S_REG and ir(15 downto 12) = X"C") then -- DEBUG
            dbg_out <= regB_rd & regA_rd;
        end if;

        if ( state = S_ALU and ir(ir'left) = '0' ) then
            flags <= alu_co & alu_v & alu_s & alu_z;
        end if;

        if ( state = S_JUMP or state = S_LOADI ) then
            pc <= alu_y;
        elsif ( next_state = S_FETCH ) then
            pc <= next_pc;
        end if;

        state <= next_state;

    end if; -- rising_edge
    end process;

end architecture;
