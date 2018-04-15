library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.util.all;

entity cpu_v4 is
    port (
        dbg_out :   out std_logic_vector(31 downto 0);
        dbg_in  :   in  std_logic_vector(31 downto 0);
        areset  :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

architecture arch of cpu_v4 is

    subtype word_t is std_logic_vector(15 downto 0);

    type state_t is record
        pc : word_t;
        ir : word_t;
        reg_a_re, reg_b_re, reg_c_re, reg_c_we : boolean;
        op : std_logic_vector(3 downto 0);
        op_alu, op_store, op_load, op_loadi, op_debug, op_jump : boolean;
    end record;

    constant NOP : state_t := (
        pc => (others => '0'),
        ir => (others => '0'),
        op => (others => '0'),
        others => false
    );

    signal s_if, s_id, s_ex, s_mm, s_wb : state_t;

    signal ex_reg_a, ex_reg_b : word_t;
    signal mm_wd, mm_addr : word_t;
    signal wb_wd : word_t;

    signal id_stall : boolean;

    signal ram_a_addr, ram_b_addr : word_t;
    signal ram_a_rd, ram_b_rd, ram_b_wd : word_t;
    signal ram_b_we : std_logic;

    signal reg_a_addr, reg_b_addr : std_logic_vector(3 downto 0);
    signal reg_a_rd, reg_b_rd, reg_b_wd : word_t;
    signal reg_b_we : std_logic;

    signal alu_op : std_logic_vector(2 downto 0);
    signal alu_a, alu_b, alu_y : word_t;
    signal alu_ci, alu_co : std_logic;

begin

    ram_i : component ram_v3
    generic map (
        W => 16,
        N => 8,
        INIT_FILE_HEX => "cpu_v4.hex"--,
    )
    port map (
        a_addr  => ram_a_addr(7 downto 0),
        a_rd    => ram_a_rd,
        b_addr  => ram_b_addr(7 downto 0),
        b_rd    => ram_b_rd,
        b_wd    => ram_b_wd,
        b_we    => ram_b_we,
        clk     => clk--,
    );

    reg_file_i : component reg_file_v3
    generic map (
        W => 16,
        N => 4--,
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
        z   => open,
        s   => open,
        v   => open,
        co  => alu_co--,
    );

    reg_a_addr <= s_ex.ir(11 downto 8) when ( s_ex.reg_c_re ) else
                  s_id.ir(3 downto 0) when ( s_id.reg_a_re ) else
                  (others => '-');

    reg_b_addr <= s_wb.ir(11 downto 8) when ( s_wb.reg_c_we ) else
                  s_id.ir(7 downto 4) when ( s_id.reg_b_re ) else
                  (others => '-');

    id_stall <= ( s_ex.reg_c_re and s_id.reg_a_re )
             or ( s_wb.reg_c_we and s_id.reg_b_re )
             or ( s_ex.reg_c_we and s_ex.ir(11 downto 8) = s_id.ir(3 downto 0) and s_id.reg_a_re )
             or ( s_ex.reg_c_we and s_ex.ir(11 downto 8) = s_id.ir(7 downto 4) and s_id.reg_b_re )
             or ( s_mm.reg_c_we and s_mm.ir(11 downto 8) = s_id.ir(3 downto 0) and s_id.reg_a_re )
             or ( s_mm.reg_c_we and s_mm.ir(11 downto 8) = s_id.ir(7 downto 4) and s_id.reg_b_re )
             or ( s_wb.reg_c_we and s_wb.ir(11 downto 8) = s_id.ir(3 downto 0) and s_id.reg_a_re )
             or ( s_wb.reg_c_we and s_wb.ir(11 downto 8) = s_id.ir(7 downto 4) and s_id.reg_b_re );

    -- Instruction Fetch

    ram_a_addr <= s_if.pc;
    s_if.ir <= ram_a_rd;
    s_if.reg_a_re <= s_if.ir(3 downto 0) /= 0 and ( s_if.op_alu or s_if.op_store or s_if.op_load or s_if.op_debug );
    s_if.reg_b_re <= s_if.ir(7 downto 4) /= 0 and ( s_if.op_alu or s_if.op_store or s_if.op_load or s_if.op_debug );
    s_if.reg_c_re <= s_if.ir(11 downto 8) /= 0 and ( s_if.op_store );
    s_if.reg_c_we <= s_if.ir(11 downto 8) /= 0 and ( s_if.op_alu or s_if.op_load or s_if.op_loadi);
    s_if.op <= s_if.ir(15 downto 12);
    s_if.op_alu <= s_if.ir /= 0 and s_if.op(s_if.op'left) = '0';
    s_if.op_store <= s_if.op = X"F";
    s_if.op_load <= s_if.op = X"E";
    s_if.op_loadi <= s_if.op = X"D";
    s_if.op_debug <= s_if.op = X"C";
    s_if.op_jump <= s_if.op = X"A";

    if_p : process(clk, areset)
    begin
    if areset = '1' then
        s_if.pc <= (others => '0');
        s_id <= NOP;
        --
    elsif rising_edge(clk) then
    if ( id_stall ) then
        --
    else
        if ( s_if.op_jump ) then
            s_if.pc <= s_if.pc + ((7 downto 0 => s_if.ir(7)) & s_if.ir(7 downto 0));
        elsif ( s_if.op_loadi ) then
            s_if.pc <= s_if.pc + 2;
        else
            s_if.pc <= s_if.pc + 1;
        end if;

        s_id <= s_if;
        --
    end if; -- ena
    end if; -- rising_edge
    end process;

    -- Instruction Decode

    id_p : process(clk, areset)
    begin
    if areset = '1' then
        s_ex <= NOP;
        --
    elsif rising_edge(clk) then
    if ( id_stall ) then
        s_ex <= NOP;
        --
    else
        ex_reg_a <= (others => '0');
        ex_reg_b <= (others => '0');

        if s_id.reg_a_re then
            ex_reg_a <= reg_a_rd;
        end if;
        if s_id.reg_b_re then
            ex_reg_b <= reg_b_rd;
        end if;

        if ( s_id.op_debug ) then -- DEBUG
            dbg_out <= reg_b_rd & reg_a_rd;
        end if;

        s_ex <= s_id;
        --
    end if; -- ena
    end if; -- rising_edge
    end process;

    -- Execute

    alu_a <= ex_reg_a when ( s_ex.reg_a_re ) else
             s_ex.pc when ( s_ex.op_loadi ) else
             (others => '0');
    alu_b <= ex_reg_b when ( s_ex.reg_b_re ) else
             X"0001" when ( s_ex.op_loadi ) else
             (others => '0');
    alu_op <= s_ex.op(alu_op'range) when ( s_ex.op_alu ) else
              (others => '0');

    ex_p : process(clk, areset)
    begin
    if areset = '1' then
        s_mm <= NOP;
        --
    elsif rising_edge(clk) then
        mm_addr <= (others => '-');
        mm_wd <= (others => '-');

        if ( s_ex.op_alu ) then
            mm_wd <= alu_y;
            alu_ci <= alu_co;
        elsif ( s_ex.op_store ) then
            mm_addr <= alu_y;
            mm_wd <= reg_a_rd;
        elsif ( s_ex.op_load or s_ex.op_loadi ) then
            mm_addr <= alu_y;
        end if;

        s_mm <= s_ex;
        --
    end if; -- rising_edge
    end process;

    -- Memory access

    ram_b_addr <= mm_addr when ( s_mm.op_store or s_mm.op_load or s_mm.op_loadi ) else
                  (others => '-');
    ram_b_wd <= mm_wd when ( s_mm.op_store ) else
                (others => '-');
    ram_b_we <= '1' when ( s_mm.op_store ) else
                '0';

    mem_p : process(clk, areset)
    begin
    if areset = '1' then
        s_wb <= NOP;
        --
    elsif rising_edge(clk) then
        wb_wd <= (others => '-');

        if ( s_mm.op_alu ) then
            wb_wd <= mm_wd;
        elsif ( s_mm.op_load or s_mm.op_loadi ) then
            wb_wd <= ram_b_rd;
        end if;

        s_wb <= s_mm;
        --
    end if; -- rising_edge
    end process;

    -- Register write back

    reg_b_wd <= wb_wd when ( s_wb.reg_c_we ) else
                (others => '-');
    reg_b_we <= '1' when ( s_wb.reg_c_we ) else
                '0';

end architecture;
