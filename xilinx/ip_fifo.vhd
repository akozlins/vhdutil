--
-- Author: Alexandr Kozlinskiy
--

library ieee;
use ieee.std_logic_1164.all;

entity ip_fifo is
generic (
    W   : positive := 8;
    N   : positive := 8--;
);
port (
    i_re        : in    std_logic;
    o_rdata     : out   std_logic_vector(W-1 downto 0);
    o_rempty    : out   std_logic;
    i_rreset_n  : in    std_logic;
    i_rclk      : in    std_logic;

    i_we        : in    std_logic;
    i_wdata     : in    std_logic_vector(W-1 downto 0);
    o_wfull     : out   std_logic;
    i_wreset_n  : in    std_logic;
    i_wclk      : in    std_logic--;
);
end entity;

library unimacro;
use unimacro.vcomponents.all;

architecture arch of ip_fifo is

    signal RST : std_logic;

    signal FULL, EMPTY : std_logic;
    signal WREN, RDEN : std_logic;
    signal wrerr, rderr : std_logic;

begin

    RST <= not (i_wreset_n and i_rreset_n);

    o_wfull <= FULL;
    o_rempty <= EMPTY;
    WREN <= i_we and not FULL;
    RDEN <= i_re and not EMPTY;

   -- FIFO_DUALCLOCK_MACRO: Dual-Clock First-In, First-Out (FIFO) RAM Buffer
   --                       Artix-7
   -- Xilinx HDL Language Template, version 2018.1

   -- Note -  This Unimacro model assumes the port directions to be "downto". 
   --         Simulation of this model with "to" in the port directions could lead to erroneous results.

   -----------------------------------------------------------------
   -- DATA_WIDTH | FIFO_SIZE | FIFO Depth | RDCOUNT/WRCOUNT Width --
   -- ===========|===========|============|=======================--
   --   37-72    |  "36Kb"   |     512    |         9-bit         --
   --   19-36    |  "36Kb"   |    1024    |        10-bit         --
   --   19-36    |  "18Kb"   |     512    |         9-bit         --
   --   10-18    |  "36Kb"   |    2048    |        11-bit         --
   --   10-18    |  "18Kb"   |    1024    |        10-bit         --
   --    5-9     |  "36Kb"   |    4096    |        12-bit         --
   --    5-9     |  "18Kb"   |    2048    |        11-bit         --
   --    1-4     |  "36Kb"   |    8192    |        13-bit         --
   --    1-4     |  "18Kb"   |    4096    |        12-bit         --
   -----------------------------------------------------------------

   FIFO_DUALCLOCK_MACRO_inst : FIFO_DUALCLOCK_MACRO
   generic map (
      DEVICE => "7SERIES",            -- Target Device: "VIRTEX5", "VIRTEX6", "7SERIES"
      ALMOST_FULL_OFFSET => X"0080",  -- Sets almost full threshold
      ALMOST_EMPTY_OFFSET => X"0080", -- Sets the almost empty threshold
      DATA_WIDTH => W,   -- Valid values are 1-72 (37-72 only valid when FIFO_SIZE="36Kb")
      FIFO_SIZE => "18Kb",            -- Target BRAM, "18Kb" or "36Kb"
      FIRST_WORD_FALL_THROUGH => TRUE) -- Sets the FIFO FWFT to TRUE or FALSE
   port map (
      ALMOSTEMPTY => open,          -- 1-bit output almost empty
      ALMOSTFULL => open,           -- 1-bit output almost full
      DO => rd,                     -- Output data, width defined by DATA_WIDTH parameter
      EMPTY => EMPTY,               -- 1-bit output empty
      FULL => FULL,                 -- 1-bit output full
      RDCOUNT => open,              -- Output read count, width determined by FIFO depth
      RDERR => RDERR,               -- 1-bit output read error
      WRCOUNT => open,              -- Output write count, width determined by FIFO depth
      WRERR => WRERR,               -- 1-bit output write error
      DI => wd,                     -- Input data, width defined by DATA_WIDTH parameter
      RDCLK => i_rclk,              -- 1-bit input read clock
      RDEN => RDEN,                 -- 1-bit input read enable
      RST => RST,                   -- 1-bit input reset
      WRCLK => i_wclk,              -- 1-bit input write clock
      WREN => WREN                  -- 1-bit input write enable
   );

end architecture;
