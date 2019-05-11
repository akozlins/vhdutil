--
-- Author: Alexandr Kozlinskiy
--

library ieee;
use ieee.std_logic_1164.all;

-- 16bit cpu
-- 5-stage pipeline:
-- * if - instruction fetch
-- * id - instruction decode
-- * ex - execute
-- * mm - memory access
-- * wb - register writeback
entity cpu16_v4 is
    port (
        dbg_out :   out std_logic_vector(15 downto 0);
        dbg_in  :   in  std_logic_vector(15 downto 0);
        rst_n   :   in  std_logic;
        clk     :   in  std_logic--;
    );
end entity;

library ieee;
use ieee.numeric_std.all;

architecture arch of cpu16_v4 is

    function "/=" (
        l : in std_logic_vector;
        r : in integer--;
    ) return boolean is
    begin
        return unsigned(l) /= r;
    end function;



    subtype word_t is std_logic_vector(15 downto 0);
    subtype ram_addr_t is unsigned(7 downto 0);
    subtype reg_addr_t is std_logic_vector(3 downto 0);

    type stage_t is record
        pc : ram_addr_t;
        op : std_logic_vector(3 downto 0);
        op_alu, op_store, op_load, op_loadi, op_debug, op_jump : boolean;
        reg_a_addr, reg_b_addr, reg_c_addr : reg_addr_t;
        reg_a_re, reg_b_re, reg_c_re, reg_c_we : boolean;
    end record;

    constant NOP : stage_t := (
        pc => (others => '0'),
        op => (others => '0'),
        reg_a_addr => (others => '0'), reg_b_addr => (others => '0'), reg_c_addr => (others => '0'),
        others => false
    );

    signal s_if, s_id, s_ex, s_mm, s_wb : stage_t;

    signal ex_reg_a, ex_reg_b : word_t;

    signal mm_addr : ram_addr_t;
    signal mm_wd, wb_wd : word_t;

    signal if_stall, id_stall, ex_stall : boolean;

    type ram_port_t is record
        addr : ram_addr_t;
        rd, wd : word_t;
        we : std_logic;
    end record;

    signal ram_a, ram_b : ram_port_t := ( addr => (others => '0'), we => '-', others => (others => '-'));

    type reg_port_t is record
        addr : reg_addr_t;
        rd, wd : word_t;
        we : std_logic;
    end record;

    signal reg_a, reg_b : reg_port_t := ( we => '-', others => (others => '-'));

    type alu_port_t is record
        op : std_logic_vector(2 downto 0);
        a, b, y : word_t;
        ci, z, s, v, co : std_logic;
    end record;

    signal alu : alu_port_t;

    signal pc_next : ram_addr_t;

begin

    i_ram : entity work.ram_dp
    generic map (
        W => word_t'length,
        N => ram_addr_t'length,
        INIT_FILE_HEX => "../cpu/cpu_v4.hex"--,
    )
    port map (
        a_addr  => std_logic_vector(ram_a.addr),
        a_rd    => ram_a.rd,
        b_addr  => std_logic_vector(ram_b.addr),
        b_rd    => ram_b.rd,
        b_wd    => ram_b.wd,
        b_we    => ram_b.we,
        clk     => clk--,
    );

    i_reg_file : entity work.ram_dp
    generic map (
        W => word_t'length,
        N => reg_addr_t'length--,
    )
    port map (
        a_addr  => std_logic_vector(reg_a.addr),
        a_rd    => reg_a.rd,
        b_addr  => std_logic_vector(reg_b.addr),
        b_rd    => reg_b.rd,
        b_wd    => reg_b.wd,
        b_we    => reg_b.we,
        clk     => clk--,
    );

    i_alu : entity work.alu_v2
    generic map (
        W => word_t'length--,
    )
    port map (
        a   => alu.a,
        b   => alu.b,
        ci  => alu.ci,
        op  => alu.op,
        y   => alu.y,
        z   => alu.z,
        s   => alu.s,
        v   => alu.v,
        co  => alu.co--,
    );

    reg_a.addr <= s_ex.reg_c_addr when ( s_ex.reg_c_re ) else
                  s_id.reg_a_addr when ( s_id.reg_a_re ) else
                  (others => '-');

    reg_b.addr <= s_wb.reg_c_addr when ( s_wb.reg_c_we ) else
                  s_id.reg_b_addr when ( s_id.reg_b_re ) else
                  (others => '-');

    if_stall <= false;
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

    ram_a.addr <= s_if.pc;

    s_if.op <= ram_a.rd(15 downto 12);
    s_if.op_store <= s_if.op = X"F";
    s_if.op_load <= s_if.op = X"E";
    s_if.op_loadi <= s_if.op = X"D";
    s_if.op_debug <= s_if.op = X"C";
    s_if.op_jump <= s_if.op = X"A";
    s_if.op_alu <= ram_a.rd /= 0 and s_if.op(s_if.op'left) = '0';

    s_if.reg_a_addr <= reg_addr_t(ram_a.rd(3 downto 0));
    s_if.reg_b_addr <= reg_addr_t(ram_a.rd(7 downto 4));
    s_if.reg_c_addr <= reg_addr_t(ram_a.rd(11 downto 8));

    s_if.reg_a_re <= s_if.reg_a_addr /= 0 and ( s_if.op_alu or s_if.op_store or s_if.op_load or s_if.op_debug );
    s_if.reg_b_re <= s_if.reg_b_addr /= 0 and ( s_if.op_alu or s_if.op_store or s_if.op_load or s_if.op_debug );
    s_if.reg_c_re <= s_if.reg_c_addr /= 0 and ( s_if.op_store );
    s_if.reg_c_we <= s_if.reg_c_addr /= 0 and ( s_if.op_alu or s_if.op_load or s_if.op_loadi);

    blk_pc :
    block
        signal a, b, s : std_logic_vector(ram_addr_t'range);
    begin
        i_adder : entity work.adder
        generic map (
            W => ram_addr_t'length--,
        )
        port map (
            a => a,
            b => b,
            ci => '0',
            s => s,
            co => open--,
        );
        a <= std_logic_vector(s_id.pc) when ( s_id.op_jump ) else
             std_logic_vector(s_if.pc);
        b <= s_id.reg_b_addr & s_id.reg_a_addr when ( s_id.op_jump ) else
             X"01";
        pc_next <= ram_addr_t(s);
    end block;

    proc_fetch :
    process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        s_if.pc <= (others => '0');
        s_id <= NOP;
        --
    elsif rising_edge(clk) then
    if ( if_stall ) then
        s_id <= NOP;
        --
    elsif ( id_stall or ex_stall ) then
        --
    else
        s_if.pc <= pc_next;

        s_id <= s_if;

        if ( s_id.op_loadi or s_id.op_jump ) then
            s_id <= NOP;
        end if;
        --
    end if; -- ena
    end if; -- rising_edge
    end process;

    -- Instruction Decode

    proc_decode :
    process(clk, rst_n)
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
            ex_reg_a <= reg_a.rd;
        end if;
        if ( s_id.reg_b_re ) then
            ex_reg_b <= reg_b.rd;
        end if;

        if ( s_id.op_debug ) then
            dbg_out <= reg_a.rd;
        end if;

        s_ex <= s_id;
        --
    end if; -- ena
    end if; -- rising_edge
    end process;

    -- Execute

    alu.a <= ex_reg_a when ( s_ex.reg_a_re ) else
             std_logic_vector(resize(s_ex.pc, word_t'length)) when ( s_ex.op_loadi ) else
             (others => '0');
    alu.b <= ex_reg_b when ( s_ex.reg_b_re ) else
             X"0001" when ( s_ex.op_loadi ) else
             (others => '0');
    alu.op <= s_ex.op(alu.op'range) when ( s_ex.op_alu ) else
              (others => '0');

    proc_exec :
    process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        alu.ci <= '0';
        s_mm <= NOP;
        --
    elsif rising_edge(clk) then
    if ( ex_stall ) then
        s_mm <= NOP;
        --
    else
        mm_addr <= (others => '-');
        mm_wd <= (others => '-');

        if ( s_ex.op_alu ) then
            mm_wd <= alu.y;
            alu.ci <= alu.co;
        elsif ( s_ex.op_store ) then
            mm_addr <= ram_addr_t(alu.y(mm_addr'range));
            mm_wd <= reg_a.rd;
        elsif ( s_ex.op_load or s_ex.op_loadi ) then
            mm_addr <= ram_addr_t(alu.y(mm_addr'range));
        end if;

        s_mm <= s_ex;
        --
    end if; -- ena
    end if; -- rising_edge
    end process;

    -- Memory access

    ram_b.addr <= mm_addr when ( s_mm.op_store or s_mm.op_load or s_mm.op_loadi ) else
                  (others => '-');
    ram_b.wd <= mm_wd when ( s_mm.op_store ) else
                (others => '-');
    ram_b.we <= '1' when ( s_mm.op_store ) else
                '0';

    proc_mem :
    process(clk, rst_n)
    begin
    if ( rst_n = '0' ) then
        s_wb <= NOP;
        --
    elsif rising_edge(clk) then
        wb_wd <= (others => '-');

        if ( s_mm.op_alu ) then
            wb_wd <= mm_wd;
        elsif ( s_mm.op_load or s_mm.op_loadi ) then
            wb_wd <= ram_b.rd;
        end if;

        s_wb <= s_mm;
        --
    end if; -- rising_edge
    end process;

    -- Register write back

    reg_b.wd <= wb_wd when ( s_wb.reg_c_we ) else
                (others => '-');
    reg_b.we <= '1' when ( s_wb.reg_c_we ) else
                '0';

end architecture;
