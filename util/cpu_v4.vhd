
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

    signal if_pc, id_pc, ex_pc : word_t;
    signal if_ir, id_ir, ex_ir, mem_ir, wb_ir : word_t;
    signal if_op, id_op, ex_op, mem_op, wb_op : std_logic_vector(3 downto 0);

    signal ex_reg_a, ex_reg_b : word_t;

    signal id_reg_a_addr, id_reg_b_addr, ex_reg_a_addr, wb_reg_b_addr : std_logic_vector(3 downto 0);

    signal mem_wd, mem_addr : word_t;
    signal wb_wd : word_t;

    signal ram_a_addr, ram_b_addr : word_t;
    signal ram_a_rd, ram_b_rd, ram_b_wd : word_t;
    signal ram_b_we : std_logic;

    signal reg_a_addr, reg_b_addr : std_logic_vector(3 downto 0);
    signal reg_a_rd, reg_b_rd, reg_b_wd : word_t;
    signal reg_b_we : std_logic;

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

    if_op <= if_ir(15 downto 12);
    id_op <= id_ir(15 downto 12);
    ex_op <= ex_ir(15 downto 12);
    mem_op <= mem_ir(15 downto 12);
    wb_op <= wb_ir(15 downto 12);

    reg_a_addr <= ex_reg_a_addr when ( ex_op = X"F" ) else
                  id_reg_a_addr;

    reg_b_addr <= wb_reg_b_addr when ( reg_b_we = '1' ) else
                  id_reg_b_addr;

    -- Instruction Fetch

    ram_a_addr <= if_pc;
    if_ir <= ram_a_rd;

    if_p : process(clk, areset)
    begin
    if areset = '1' then
        if_pc <= (others => '0');
        id_ir <= (others => '0');
        id_pc <= (others => '-');
        --
    elsif rising_edge(clk) then
    if ( reg_b_we = '1' or ex_op = X"F" ) then -- stall
        --
    else
        if ( if_op = X"A" ) then -- JUMP
            if_pc <= if_pc + ((7 downto 0 => if_ir(7)) & if_ir(7 downto 0));
        elsif ( if_op = X"D" ) then -- LOADI
            if_pc <= if_pc + 2;
        else
            if_pc <= if_pc + 1;
        end if;

        id_pc <= if_pc;
        id_ir <= if_ir;
        --
    end if; -- ena
    end if; -- rising_edge
    end process;

    -- Instruction Decode

    id_reg_a_addr <= id_ir(3 downto 0) when ( id_ir /= 0 and id_op(id_op'left) = '0' ) else -- ALU
                  id_ir(3 downto 0) when ( id_op = X"F" ) else -- STORE
                  id_ir(3 downto 0) when ( id_op = X"E" ) else -- LOAD
                  id_ir(3 downto 0) when ( id_op = X"C" ) else -- DEBUG
                  (others => '-');
    id_reg_b_addr <= id_ir(7 downto 4) when ( id_ir /= 0 and id_op(id_op'left) = '0' ) else -- ALU
                     id_ir(7 downto 4) when ( id_op = X"F" ) else -- STORE
                     id_ir(7 downto 4) when ( id_op = X"E" ) else -- LOAD
                     id_ir(7 downto 4) when ( id_op = X"C" ) else -- DEBUG
                     (others => '-');

    id_p : process(clk, areset)
    begin
    if areset = '1' then
        ex_ir <= (others => '0');
        ex_pc <= (others => '-');
        --
    elsif rising_edge(clk) then
    if ( reg_b_we = '1' or ex_op = X"F" ) then -- stall
        ex_ir <= (others => '0');
        -- TODO: allow LOADI
    else
        ex_reg_a <= reg_a_rd;
        ex_reg_b <= reg_b_rd;

        if ( id_op = X"C" ) then -- DEBUG
            dbg_out <= reg_b_rd & reg_a_rd;
        end if;

        ex_pc <= id_pc;
        ex_ir <= id_ir;
        --
    end if; -- ena
    end if; -- rising_edge
    end process;

    -- Execute

    ex_reg_a_addr <= ex_ir(11 downto 8) when ( ex_op = X"F" ) else -- STORE
                     (others => '-');

    ex_p : process(clk, areset)
    begin
    if areset = '1' then
        mem_ir <= (others => '0');
        --
    elsif rising_edge(clk) then
        mem_addr <= (others => '-');
        mem_wd <= (others => '-');

        if ( ex_ir /= 0 and ex_op(ex_op'left) = '0' ) then -- ALU
            case ex_op(2 downto 0) is
            when "000" => mem_wd <= ex_reg_a + ex_reg_b;
            when "001" => mem_wd <= ex_reg_a + ex_reg_b;
            when "010" => mem_wd <= ex_reg_a - ex_reg_b;
            when "011" => mem_wd <= ex_reg_a - ex_reg_b;
            when "100" => mem_wd <= ex_reg_a and ex_reg_b;
            when "101" => mem_wd <= ex_reg_a or ex_reg_b;
            when "110" => mem_wd <= ex_reg_a xor ex_reg_b;
            when "111" => mem_wd <= not (ex_reg_a or ex_reg_b);
            when others => mem_wd <= (others => 'X');
            end case;
        elsif ( ex_op = X"F" ) then -- STORE
            mem_wd <= reg_a_rd;
            mem_addr <= ex_reg_a + ex_reg_b;
        elsif ( ex_op = X"E" ) then -- LOAD
            mem_addr <= ex_reg_a + ex_reg_b;
        elsif ( ex_op = X"D" ) then -- LOADI
            mem_addr <= ex_pc + 1;
        end if;

        mem_ir <= ex_ir;
        --
    end if; -- rising_edge
    end process;

    -- Memory access

    ram_b_addr <= mem_addr when ( mem_op = X"F" ) else -- STORE
                  mem_addr when ( mem_op = X"E" or mem_op = X"D" ) else -- LOAD or LOADI
                  (others => '-');
    ram_b_wd <= mem_wd when ( mem_op = X"F" ) else -- STORE
                (others => '-');
    ram_b_we <= '1' when ( mem_op = X"F" ) else -- STORE
                '0';

    mem_p : process(clk, areset)
    begin
    if areset = '1' then
        wb_ir <= (others => '0');
        --
    elsif rising_edge(clk) then
        wb_wd <= (others => '-');

        if ( mem_ir /= 0 and mem_op(mem_op'left) = '0' ) then -- ALU
            wb_wd <= mem_wd;
        elsif ( mem_op = X"E" or mem_op = X"D" ) then -- LOAD or LOADI
            wb_wd <= ram_b_rd;
        end if;

        wb_ir <= mem_ir;
        --
    end if; -- rising_edge
    end process;

    -- Register write back

    wb_reg_b_addr <= wb_ir(11 downto 8) when ( wb_ir /= 0 and wb_op(wb_op'left) = '0' ) else -- ALU
                     wb_ir(11 downto 8) when ( wb_op = X"E" or wb_op = X"D" ) else -- LOAD or LOADI
                     (others => '-');
    reg_b_wd <= wb_wd when ( wb_ir /= 0 and wb_op(wb_op'left) = '0' ) else -- ALU
                wb_wd when ( wb_op = X"E" or wb_op = X"D" ) else -- LOAD or LOADI
                (others => '-');
    reg_b_we <= '1' when ( wb_ir /= 0 and wb_op(wb_op'left) = '0' ) else -- ALU
                '1' when ( wb_op = X"E" or wb_op = X"D" ) else -- LOAD or LOADI
                '0';

    wb_p : process(clk, areset)
    begin
    if areset = '1' then
        --
    elsif rising_edge(clk) then
        --
    end if; -- rising_edge
    end process;

end architecture;
