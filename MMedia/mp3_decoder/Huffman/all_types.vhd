library IEEE;
use IEEE.std_logic_1164.all;

package all_types is
 
  type header_type is record
    id         : std_logic;
    layer      : std_logic_vector(1 downto 0);
    protection : std_logic;
    bitrate    : std_logic_vector(3 downto 0);
    frequency  : std_logic_vector(1 downto 0);
    padding    : std_logic;
    private    : std_logic;
    mode       : std_logic_vector(1 downto 0);
    mode_ext   : std_logic_vector(1 downto 0);
    copyright  : std_logic;
    original   : std_logic;
    emphasis   : std_logic_vector(1 downto 0);
    channels   : std_logic;
  end record;

  type scfsi_type is array(0 to 3) of std_logic;				
  type table_select_type is array(0 to 2) of std_logic_vector(4 downto 0);	
  type subblock_gain_type is array(0 to 2) of std_logic_vector(2 downto 0);	

  type sideinfo_type is record
    main_data          : std_logic_vector(9 downto 0);  
    private_bits       : std_logic_vector(4 downto 0);
    scfsi              : scfsi_type;
    part2_3_length     : std_logic_vector(11 downto 0);
    big_values         : std_logic_vector(8 downto 0);
    global_gain        : std_logic_vector(7 downto 0);
    scalefac_compress  : std_logic_vector(3 downto 0);
    blocksplit_flag    : std_logic;
    block_type         : std_logic_vector(1 downto 0);
    switch_point       : std_logic;
    table_select       : table_select_type;
    subblock_gain      : subblock_gain_type;
    region_address1    : std_logic_vector(3 downto 0);
    region_address2    : std_logic_vector(2 downto 0);
    preflag            : std_logic;
    scalefac_scale     : std_logic;
    count1table_select : std_logic;
  end record;

  type frame_type is record
    header   : header_type;
    crc      : std_logic_vector(15 downto 0);
    sideinfo : sideinfo_type;
  end record;

  type scalefac_l_type is array(0 to 22) of std_logic_vector(3 downto 0);
  type scalefac_s_window_type is array(0 to 2) of std_logic_vector(3 downto 0);
  type scalefac_s_type is array(0 to 12) of scalefac_s_window_type;

  type scalefac_type is record
    scalefac_l : scalefac_l_type;
    scalefac_s : scalefac_s_type;
  end record;

  type mem_control_type is record
    addr  : std_logic_vector(9 downto 0);
    we    : std_logic;
    oe    : std_logic;
    en    : std_logic;
  end record;

end;