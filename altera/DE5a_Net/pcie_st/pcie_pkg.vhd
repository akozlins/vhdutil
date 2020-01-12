library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package pcie is

    type tl_cfg_t is array (0 to 15) of std_logic_vector(31 downto 0);

    -- see "5.12.2. Configuration Space Register Access"
    type cfg_t is record
        busdev          :   std_logic_vector(12 downto 0);
        -- Device Control
        dev_ctrl        :   std_logic_vector(15 downto 0);
        dev_ctrl2       :   std_logic_vector(15 downto 0);
        -- Link Control
        link_ctrl       :   std_logic_vector(15 downto 0);
        link_ctrl2      :   std_logic_vector(15 downto 0);
        -- Base/Primary Command
        prm_cmd         :   std_logic_vector(15 downto 0);
        -- MSI
        msixcsr         :   std_logic_vector(15 downto 0);
        msicsr          :   std_logic_vector(15 downto 0);
        msi_data        :   std_logic_vector(15 downto 0);
        msi_addr        :   std_logic_vector(63 downto 0);
        -- Configuration TC/VC mapping
        tcvcmap         :   std_logic_vector(23 downto 0);

        -- Root Port registers
--        slot_ctrl       :   std_logic_vector(15 downto 0);
--        root_ctrl       :   std_logic_vector(7 downto 0);
--        sec_ctrl        :   std_logic_vector(15 downto 0);
--        secbus          :   std_logic_vector(7 downto 0);
--        subbus          :   std_logic_vector(7 downto 0);
--        io_bas          :   std_logic_vector(19 downto 0);
--        io_lim          :   std_logic_vector(19 downto 0);
--        np_bas          :   std_logic_vector(11 downto 0);
--        np_lim          :   std_logic_vector(11 downto 0);
--        pr_bas          :   std_logic_vector(43 downto 0);
--        pr_lim          :   std_logic_vector(43 downto 0);
--        pmcsr           :   std_logic_vector(31 downto 0);
    end record;

    function to_cfg (
        tl_cfg : tl_cfg_t--;
    ) return cfg_t;



    type st_t is record
        data            :   std_logic_vector(255 downto 0);
        sop             :   std_logic;
        eop             :   std_logic;
        empty           :   std_logic_vector(1 downto 0);
        valid           :   std_logic;
        err             :   std_logic;
        ready           :   std_logic;
    end record;

end package;

package body pcie is

    function to_cfg (
        tl_cfg : tl_cfg_t--;
    ) return cfg_t is
        variable cfg : cfg_t := (others => (others => '0'));
    begin
        cfg.busdev      := tl_cfg(15)(12 downto 0);
        cfg.dev_ctrl    := tl_cfg(0)(31 downto 16);
        cfg.dev_ctrl2   := tl_cfg(0)(15 downto 0);
        cfg.link_ctrl   := tl_cfg(2)(31 downto 16);
        cfg.link_ctrl2  := tl_cfg(2)(15 downto 0);
        cfg.prm_cmd     := tl_cfg(3)(23 downto 8);
        cfg.msixcsr     := tl_cfg(13)(31 downto 16);
        cfg.msicsr      := tl_cfg(13)(15 downto 0);
        cfg.msi_data    := tl_cfg(15)(31 downto 16);
        cfg.msi_addr    := tl_cfg(11)(31 downto 12) & tl_cfg(6)(31 downto 20) &
                           tl_cfg(9)(31 downto 12) & tl_cfg(5)(31 downto 20);
        cfg.tcvcmap     := tl_cfg(14)(23 downto 0);

        return cfg;
    end function;

end package body;
