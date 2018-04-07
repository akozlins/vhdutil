library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.util.all;

entity cpu_v2 is
    port (
        dbg_out :   out std_logic_vector(31 downto 0);
        dbg_in  :   in  std_logic_vector(31 downto 0);
        clk     :   in  std_logic;
        areset  :   in  std_logic--;
    );
end entity cpu_v2;

architecture arch of cpu_v2 is

    subtype word_t is std_logic_vector(15 downto 0);

    signal ram_addr : word_t;
    signal ram_addr_q : word_t;
    signal ram_dout : word_t;
    signal ram_din : word_t;
    signal ram_we : std_logic;

    signal pc : word_t;

    -- instruction register
    signal ir : std_logic_vector(3 downto 0);
    -- flags register (sign, msb, zero)
    signal fr : std_logic_vector(3 downto 0);

    signal regA, regB, regC, regC_q : word_t;
    signal regC_addr, regC_addr_q : std_logic_vector(3 downto 0);
    signal regC_din : word_t;
    signal regC_we : std_logic;

    type state_t is (
        S_EXEC,
        S_STORE,
        S_LOAD,
        S_LOADI,
        S_RESET--,
    );
    signal state : state_t;

    signal alu_a, alu_b, alu_z : word_t;
    signal alu_carry : std_logic;
    signal alu_add, alu_addc, alu_sub, alu_subb, alu_and, alu_or, alu_xor, alu_not : std_logic;

begin

    ram_i : ram
    generic map (
        W => 16,
        N => 8,
        INIT_FILE_HEX => "cpu_v2.hex"--,
    )
    port map (
        clk     => clk,
        addr    => ram_addr(7 downto 0),
        dout    => ram_dout,
        din     => ram_din,
        we      => ram_we--,
    );

    ram_addr <= ram_addr_q when ( state = S_STORE or state = S_LOAD ) else pc;
    ram_din <= regC_q;
    ram_we <= bool_to_logic( state = S_STORE );

    reg_file_i : reg_file
    generic map (
        W => 16,
        N => 4--,
    )
    port map (
        clk     => clk,
        a_addr  => ram_dout(3 downto 0),
        b_addr  => ram_dout(7 downto 4),
        c_addr  => regC_addr,
        a_dout  => regA,
        b_dout  => regB,
        c_dout  => regC,
        c_din   => regC_din,
        c_we    => regC_we,
        areset  => areset--,
    );

    regC_addr <= regC_addr_q when ( state = S_LOAD or state = S_LOADI ) else
                 ram_dout(11 downto 8);
    regC_din <= ram_dout when ( state = S_LOAD or state = S_LOADI ) else
                alu_z    when ( state = S_EXEC and ir(ir'left) = '0' ) else
                X"CCCC";
    regC_we <= '1' when ( state = S_LOAD or state = S_LOADI ) else
               '1' when ( state = S_EXEC and ir(ir'left) = '0' ) else
               '0';

    alu_i : alu
    generic map (
        W => 16--,
    )
    port map (
        mux(2) => alu_sub or alu_not,
        mux(1) => alu_or or alu_xor or alu_not,
        mux(0) => alu_and or alu_xor,
        a   => alu_a,
        b   => alu_b,
        z   => alu_z,
        ci  => (fr(2) and alu_addc) or alu_sub,
        co  => alu_carry--,
    );

    alu_add  <= bool_to_logic(state = S_EXEC and ir = "0000");
    alu_addc <= bool_to_logic(state = S_EXEC and ir = "0001");
    alu_sub  <= bool_to_logic(state = S_EXEC and ir = "0010");
    alu_subb <= bool_to_logic(state = S_EXEC and ir = "0010");
    alu_and  <= bool_to_logic(state = S_EXEC and ir = "0100");
    alu_or   <= bool_to_logic(state = S_EXEC and ir = "0101");
    alu_xor  <= bool_to_logic(state = S_EXEC and ir = "0110");
    alu_not  <= bool_to_logic(state = S_EXEC and ir = "0111");
    alu_a <= regA;
    alu_b <= regB;

    ir <= ram_dout(15 downto 12);

    process(clk, areset)
    begin
    if areset = '1' then
        state <= S_RESET;
    elsif rising_edge(clk) then
        state <= S_EXEC;
        ram_addr_q <= regB + regA;
        regC_addr_q <= regC_addr;
        regC_q <= regC;

        case state is
        when S_EXEC =>
            pc <= pc + 1;

            case ir is
            when X"F" => -- ST : *(regB + regA) = regC
                state <= S_STORE;
            when X"E" => -- LD : regC = *(regB + regA)
                state <= S_LOAD;
            when X"D" => -- LDI : regC = *(pc + 1)
                state <= S_LOADI;
            when X"C" => -- DBG
                dbg_out <= regB & regA;
            when X"A" => -- JMP : pc += rdata(7 downto 0)
                if ( (regC_addr and fr) = regC_addr ) then
                    pc <= pc + ((7 downto 0 => ram_dout(7)) & ram_dout(7 downto 0));
                end if;
            when others =>
                null;
            end case;

            if ( ir(ir'left) = '0' ) then
                fr(0) <= bool_to_logic(alu_z = 0);
                fr(1) <= alu_z(alu_z'left);
                fr(2) <= alu_carry;
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

end;
