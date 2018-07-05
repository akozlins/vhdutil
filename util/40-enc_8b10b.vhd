library ieee;
use ieee.std_logic_1164.all;

-- 8b10b encoder
-- https://en.wikipedia.org/wiki/8b/10b_encoding
entity enc_8b10b is
    port (
        -- input data (K bit & 8 data bits)
        datain  :   in  std_logic_vector(8 downto 0);
        -- input disparity
        dispin  :   in  std_logic;
        -- output 10-bit data (8b10b encoded)
        dataout :   out std_logic_vector(9 downto 0);
        -- output disparity
        dispout :   out std_logic;
        -- error if invalid control symbol
        err     :   out std_logic--;
    );
end entity;

library ieee;
use ieee.numeric_std.all;

architecture arch of enc_8b10b is

    signal K28, Kx7 : std_logic;

    -- 6-bit group --
    -- disp & 5 bits
    signal G6sel : std_logic_vector(5 downto 0);
    -- disp & 6 bits
    signal G6 : std_logic_vector(6 downto 0);
    signal A7 : std_logic;

    -- 4-bit group --
    -- disp & 3 bits
    signal G4sel : std_logic_vector(3 downto 0);
    -- disp & 4 bits
    signal G4 : std_logic_vector(4 downto 0);

    signal a, b, c : std_logic;

begin

    Kx7 <= datain(8) and work.util.to_std_logic(
        datain(7 downto 0) = "111" & "10111" or -- K.23.7
        datain(7 downto 0) = "111" & "11011" or -- K.27.7
        datain(7 downto 0) = "111" & "11101" or -- K.29.7
        datain(7 downto 0) = "111" & "11110" or -- K.30.7
        datain(7 downto 0) = "111" & "11100" -- K.28.7
    );

    -- disp & 5 bits in
    G6sel <= dispin & datain(4 downto 0);
    -- disp & 6 bits out
    process(G6sel)
    begin
        A7 <= '0';
        K28 <= '0';

        case G6sel is
        when '0' & "00000" => G6 <= '1' & "111001";
        when '1' & "00000" => G6 <= '0' & "000110";
        when '0' & "00001" => G6 <= '1' & "101110";
        when '1' & "00001" => G6 <= '0' & "010001";
        when '0' & "00010" => G6 <= '1' & "101101";
        when '1' & "00010" => G6 <= '0' & "010010";
        when '0' & "00011" => G6 <= '0' & "100011";
        when '1' & "00011" => G6 <= '1' & "100011";
        when '0' & "00100" => G6 <= '1' & "101011";
        when '1' & "00100" => G6 <= '0' & "010100";
        when '0' & "00101" => G6 <= '0' & "100101";
        when '1' & "00101" => G6 <= '1' & "100101";
        when '0' & "00110" => G6 <= '0' & "100110";
        when '1' & "00110" => G6 <= '1' & "100110";
        when '0' & "00111" => G6 <= '0' & "000111"; -- D.07
        when '1' & "00111" => G6 <= '1' & "111000"; -- D.07
        when '0' & "01000" => G6 <= '1' & "100111";
        when '1' & "01000" => G6 <= '0' & "011000";
        when '0' & "01001" => G6 <= '0' & "101001";
        when '1' & "01001" => G6 <= '1' & "101001";
        when '0' & "01010" => G6 <= '0' & "101010";
        when '1' & "01010" => G6 <= '1' & "101010";
        when '0' & "01011" => G6 <= '0' & "001011";
        when '1' & "01011" => G6 <= '1' & "001011"; A7 <= '1'; -- D.11.A7
        when '0' & "01100" => G6 <= '0' & "101100";
        when '1' & "01100" => G6 <= '1' & "101100";
        when '0' & "01101" => G6 <= '0' & "001101";
        when '1' & "01101" => G6 <= '1' & "001101"; A7 <= '1'; -- D.13.A7
        when '0' & "01110" => G6 <= '0' & "001110";
        when '1' & "01110" => G6 <= '1' & "001110"; A7 <= '1'; -- D.14.A7
        when '0' & "01111" => G6 <= '1' & "111010";
        when '1' & "01111" => G6 <= '0' & "000101";
        when '0' & "10000" => G6 <= '1' & "110110";
        when '1' & "10000" => G6 <= '0' & "001001";
        when '0' & "10001" => G6 <= '0' & "110001"; A7 <= '1'; -- D.17.A7
        when '1' & "10001" => G6 <= '1' & "110001";
        when '0' & "10010" => G6 <= '0' & "110010"; A7 <= '1'; -- D.18.A7
        when '1' & "10010" => G6 <= '1' & "110010";
        when '0' & "10011" => G6 <= '0' & "010011";
        when '1' & "10011" => G6 <= '1' & "010011";
        when '0' & "10100" => G6 <= '0' & "110100"; A7 <= '1'; -- D.20.A7
        when '1' & "10100" => G6 <= '1' & "110100";
        when '0' & "10101" => G6 <= '0' & "010101";
        when '1' & "10101" => G6 <= '1' & "010101";
        when '0' & "10110" => G6 <= '0' & "010110";
        when '1' & "10110" => G6 <= '1' & "010110";
        when '0' & "10111" => G6 <= '1' & "010111";
        when '1' & "10111" => G6 <= '0' & "101000";
        when '0' & "11000" => G6 <= '1' & "110011";
        when '1' & "11000" => G6 <= '0' & "001100";
        when '0' & "11001" => G6 <= '0' & "011001";
        when '1' & "11001" => G6 <= '1' & "011001";
        when '0' & "11010" => G6 <= '0' & "011010";
        when '1' & "11010" => G6 <= '1' & "011010";
        when '0' & "11011" => G6 <= '1' & "011011";
        when '1' & "11011" => G6 <= '0' & "100100";
        when '0' & "11100" => G6 <= '0' & "011100"; -- D.28
            if ( datain(8) = '1' ) then G6 <= '1' & "111100"; K28 <= '1'; end if; -- K.28
        when '1' & "11100" => G6 <= '1' & "011100"; -- D.28
            if ( datain(8) = '1' ) then G6 <= '0' & "000011"; K28 <= '1'; end if; -- K.28
        when '0' & "11101" => G6 <= '1' & "011101";
        when '1' & "11101" => G6 <= '0' & "100010";
        when '0' & "11110" => G6 <= '1' & "011110";
        when '1' & "11110" => G6 <= '0' & "100001";
        when '0' & "11111" => G6 <= '1' & "110101";
        when '1' & "11111" => G6 <= '0' & "001010";
        when others => G6 <= (others => 'X');
        end case;
    end process;

    -- disp & 3 bits in
    G4sel <= G6(6) & datain(7 downto 5);
    -- disp & 4 bits out
    process(G4sel, A7, K28, Kx7)
    begin
        case G4sel is
        when '0' & "000" => G4 <= '1' & "1101"; -- D.x.0
        when '1' & "000" => G4 <= '0' & "0010"; -- D.x.0
        when '0' & "001" => G4 <= '0' & "1001"; -- D.x.1
        when '1' & "001" => G4 <= '1' & "1001"; -- D.x.1
            if ( K28 = '1' ) then G4 <= '1' & "0110"; end if; -- K.x.1
        when '0' & "010" => G4 <= '0' & "1010"; -- D.x.2
        when '1' & "010" => G4 <= '1' & "1010"; -- D.x.2
            if ( K28 = '1' ) then G4 <= '1' & "0101"; end if; -- K.x.2
        when '0' & "011" => G4 <= '0' & "0011"; -- D.x.3
        when '1' & "011" => G4 <= '1' & "1100"; -- D.x.3
        when '0' & "100" => G4 <= '1' & "1011"; -- D.x.4
        when '1' & "100" => G4 <= '0' & "0100"; -- D.x.4
        when '0' & "101" => G4 <= '0' & "0101"; -- D.x.5
        when '1' & "101" => G4 <= '1' & "0101"; -- D.x.5
            if ( K28 = '1' ) then G4 <= '1' & "1010"; end if; -- K.x.5
        when '0' & "110" => G4 <= '0' & "0110"; -- D.x.6
        when '1' & "110" => G4 <= '1' & "0110"; -- D.x.6
            if ( K28 = '1' ) then G4 <= '1' & "1001"; end if; -- K.x.6
        when '0' & "111" => G4 <= '1' & "0111"; -- D.x.P7
            if ( A7 = '1' or Kx7 = '1' ) then G4 <= '1' & "1110"; end if; -- D.x.A7, K.x.7
        when '1' & "111" => G4 <= '0' & "1000"; -- D.x.P7
            if ( A7 = '1' or Kx7 = '1' ) then G4 <= '0' & "0001"; end if; -- D.x.A7, K.x.7
        when others => G4 <= (others => 'X');
        end case;
    end process;

    dataout <= G4(3 downto 0) & G6(5 downto 0);
    dispout <= G4(4);

    err <= datain(8) and not (K28 or Kx7);

end architecture;
