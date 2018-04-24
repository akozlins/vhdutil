library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity cpu_v4 is
    port (
        dbg_out :   out std_logic_vector(31 downto 0);
        dbg_in  :   in  std_logic_vector(31 downto 0);
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

architecture arch of cpu_v4 is

    subtype word_t is std_logic_vector(15 downto 0);
    subtype ram_addr_t is std_logic_vector(7 downto 0);
    subtype reg_addr_t is std_logic_vector(3 downto 0);

    type op_t is (
        OP_ALU,
        OP_STORE,
        OP_LOAD, OP_LOADI,
        OP_DEBUG,
        OP_JUMP,
        OP_NOP--,
    );

    type stage_t is record
        pc : ram_addr_t;
        op : op_t;
        alu_op : std_logic_vector(2 downto 0);
        reg_a_addr, reg_b_addr, reg_c_addr : reg_addr_t;
        reg_a_re, reg_b_re, reg_c_re, reg_c_we : boolean;
    end record;

    constant NOP : stage_t := (
        pc => (others => '0'),
        op => OP_NOP,
        alu_op => (others => '0'),
        reg_a_addr => (others => '0'), reg_b_addr => (others => '0'), reg_c_addr => (others => '0'),
        reg_a_re => false, reg_b_re => false, reg_c_re => false, reg_c_we => false
    );

    signal s_if, s_id, s_ex, s_mm, s_wb : stage_t;

    signal ex_reg_a, ex_reg_b : word_t;

    signal mm_addr : ram_addr_t;
    signal mm_wd, wb_wd : word_t;

    signal id_stall, ex_stall : boolean;

    signal ram_a_addr, ram_b_addr : ram_addr_t;
    signal ram_a_rd, ram_b_rd, ram_b_wd : word_t;
    signal ram_b_we : std_logic;

    signal reg_a_addr, reg_b_addr : reg_addr_t;
    signal reg_a_rd, reg_b_rd, reg_b_wd : word_t;
    signal reg_b_we : std_logic;

    signal alu_op : std_logic_vector(2 downto 0);
    signal alu_a, alu_b, alu_y : word_t;
    signal alu_ci, alu_co : std_logic;

    signal pc_adder_b, pc_adder_s : ram_addr_t;

begin

    i_ram : entity work.ram_dp
    generic map (
        W => word_t'length,
        N => ram_addr_t'length,
        INIT_FILE_HEX => "cpu_v4.hex"--,
    )
    port map (
        a_addr  => ram_a_addr,
        a_rd    => ram_a_rd,
        b_addr  => ram_b_addr,
        b_rd    => ram_b_rd,
        b_wd    => ram_b_wd,
        b_we    => ram_b_we,
        clk     => clk--,
    );

    i_reg_file : entity work.ram_dp
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

    reg_a_addr <= s_ex.reg_c_addr when ( s_ex.reg_c_re ) else
                  s_id.reg_a_addr when ( s_id.reg_a_re ) else
                  (others => '-');

    reg_b_addr <= s_wb.reg_c_addr when ( s_wb.reg_c_we ) else
                  s_id.reg_b_addr when ( s_id.reg_b_re ) else
                  (others => '-');

    id_stall <= ( s_ex.reg_c_re and s_id.reg_a_re )
             or ( s_wb.reg_c_we and s_id.reg_b_re )
             or ( s_ex.reg_c_we and s_ex.reg_c_addr = s_id.reg_a_addr and s_id.reg_a_re )
             or ( s_ex.reg_c_we and s_ex.reg_c_addr = s_id.reg_b_addr and s_id.reg_b_re )
             or ( s_mm.reg_c_we and s_mm.reg_c_addr = s_id.reg_a_addr and s_id.reg_a_re )
             or ( s_mm.reg_c_we and s_mm.reg_c_addr = s_id.reg_b_addr and s_id.reg_b_re )
             or ( s_wb.reg_c_we and s_wb.reg_c_addr = s_id.reg_a_addr and s_id.reg_a_re )
             or ( s_wb.reg_c_we and s_wb.reg_c_addr = s_id.reg_b_addr and s_id.reg_b_re );
    ex_stall <= ( s_mm.reg_c_we and s_mm.reg_c_addr = s_ex.reg_c_addr and s_ex.reg_c_re )
             or ( s_wb.reg_c_we and s_wb.reg_c_addr = s_ex.reg_c_addr and s_ex.reg_c_re );

    -- Instruction Fetch

    ram_a_addr <= s_if.pc;
    s_if.reg_a_addr <= ram_a_rd(3 downto 0);
    s_if.reg_b_addr <= ram_a_rd(7 downto 4);
    s_if.reg_c_addr <= ram_a_rd(11 downto 8);

    s_if.op <= OP_ALU   when ram_a_rd /= 0 and ram_a_rd(ram_a_rd'left) = '0' else
               OP_STORE when ram_a_rd(15 downto 12) = X"F" else
               OP_LOAD  when ram_a_rd(15 downto 12) = X"E" else
               OP_LOADI when ram_a_rd(15 downto 12) = X"D" else
               OP_DEBUG when ram_a_rd(15 downto 12) = X"C" else
               OP_JUMP  when ram_a_rd(15 downto 12) = X"A" else
               OP_NOP;
    s_if.alu_op <= ram_a_rd(14 downto 12) when ( s_if.op = OP_ALU ) else
                   (others => '0');

    s_if.reg_a_re <= s_if.reg_a_addr /= 0 and ( s_if.op = OP_ALU or s_if.op = OP_STORE or s_if.op = OP_LOAD or s_if.op = OP_DEBUG );
    s_if.reg_b_re <= s_if.reg_b_addr /= 0 and ( s_if.op = OP_ALU or s_if.op = OP_STORE or s_if.op = OP_LOAD or s_if.op = OP_DEBUG );
    s_if.reg_c_re <= s_if.reg_c_addr /= 0 and ( s_if.op = OP_STORE );
    s_if.reg_c_we <= s_if.reg_c_addr /= 0 and ( s_if.op = OP_ALU or s_if.op = OP_LOAD or s_if.op = OP_LOADI);

    i_pc_adder : entity work.adder
    generic map (
        W => 8--,
    )
    port map (
        a => s_if.pc,
        b => pc_adder_b,
        ci => '0',
        s => pc_adder_s,
        co => open--,
    );
    pc_adder_b <= s_if.reg_b_addr & s_if.reg_a_addr when ( s_if.op = OP_JUMP ) else
                  X"02" when ( s_if.op = OP_LOADI ) else
                  X"01";

    if_p : process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        s_if.pc <= (others => '0');
        s_id <= NOP;
        --
    elsif rising_edge(clk) then
    if ( id_stall or ex_stall ) then
        --
    else
        s_if.pc <= pc_adder_s;

        s_id <= s_if;
        --
    end if; -- ena
    end if; -- rising_edge
    end process;

    -- Instruction Decode

    id_p : process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        s_ex <= NOP;
        --
    elsif rising_edge(clk) then
    if ( id_stall ) then
        s_ex <= NOP;
        --
    elsif ( ex_stall ) then
        --
    else
        ex_reg_a <= (others => '-');
        ex_reg_b <= (others => '-');

        if ( s_id.reg_a_re ) then
            ex_reg_a <= reg_a_rd;
        end if;
        if ( s_id.reg_b_re ) then
            ex_reg_b <= reg_b_rd;
        end if;

        if ( s_id.op = OP_DEBUG ) then
            dbg_out <= reg_b_rd & reg_a_rd;
        end if;

        s_ex <= s_id;
        --
    end if; -- ena
    end if; -- rising_edge
    end process;

    -- Execute

    alu_a <= ex_reg_a when ( s_ex.reg_a_re ) else
             X"00" & s_ex.pc when ( s_ex.op = OP_LOADI ) else
             (others => '0');
    alu_b <= ex_reg_b when ( s_ex.reg_b_re ) else
             X"0001" when ( s_ex.op = OP_LOADI ) else
             (others => '0');
    alu_op <= s_ex.alu_op;

    ex_p : process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        alu_ci <= '0';
        s_mm <= NOP;
        --
    elsif rising_edge(clk) then
    if ( ex_stall ) then
        s_mm <= NOP;
        --
    else
        mm_addr <= (others => '-');
        mm_wd <= (others => '-');

        case s_ex.op is
        when OP_STORE =>
            mm_addr <= alu_y(mm_addr'range);
            mm_wd <= reg_a_rd;
        when OP_LOAD | OP_LOADI =>
            mm_addr <= alu_y(mm_addr'range);
        when OP_ALU =>
            mm_wd <= alu_y;
            alu_ci <= alu_co;
        when others =>
            null;
        end case;

        s_mm <= s_ex;
        --
    end if; -- ena
    end if; -- rising_edge
    end process;

    -- Memory access

    ram_b_addr <= mm_addr when ( s_mm.op = OP_STORE or s_mm.op = OP_LOAD or s_mm.op = OP_LOADI ) else
                  (others => '-');
    ram_b_wd <= mm_wd when ( s_mm.op = OP_STORE ) else
                (others => '-');
    ram_b_we <= '1' when ( s_mm.op = OP_STORE ) else
                '0';

    mem_p : process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        s_wb <= NOP;
        --
    elsif rising_edge(clk) then
        wb_wd <= (others => '-');

        case s_mm.op is
        when OP_LOAD | OP_LOADI =>
            wb_wd <= ram_b_rd;
        when OP_ALU =>
            wb_wd <= mm_wd;
        when others =>
            null;
        end case;

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
