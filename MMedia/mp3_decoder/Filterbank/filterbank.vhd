---------------------------------------------------------------------------------
-- File Name: filterbank.vhd
-- Function Description:
--	This is the main module of component filterbank. Three packages are 
--	used in this module: all_types.vhd, mul.vhd and filterbank_package.vhd
---------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.std_logic_arith.all;
use work.all_types.all;			-- this file contains all the type declarations
use work.mul.all;			-- contains divider and fixpoint multiplier
use work.filterbank_package.all;	-- constants, types and functions for this module

entity filterbank is
  port( clk   : in  std_logic;		-- clock input signal
        rst   : in  std_logic;		-- reset signal (active high)
        start : in  std_logic;		-- start=1 activated
        done  : out std_logic;		-- done=1 when finished
        din   : in  std_logic_vector(31 downto 0);	-- signals from memory
        dout  : out std_logic_vector(31 downto 0);	-- signals to memory
        memc  : out mem_control_type;	-- singals to control memory
        frm   : in  frame_type		-- header and side information
      );
end;

architecture behavioral of filterbank is

  type state_type is ( IDLE, IDLE2, STARTSTATE, SEND_READ_ADDR, DO_NOTHING, READDATA, FILTERBANK, SEND_WRITE_ADDR, WRITEDATA, READY );
  signal cs, ns : state_type;
  
begin

  process( cs, frm, start)
    type V_type is array(0 to 1023) of integer;
    variable V : V_type;
    variable Voffset, sum, v_offset, index, V_index, counter_ss, counter_sb : integer;
    variable sample_value, t_sample_value : std_logic_vector(31 downto 0);
    variable samples, bandPtr_fix : samples_type;
    variable temp_V : pre_gen_return_type;
    
  begin

    case (cs) is
      when IDLE   =>		-- when rst is acivated
         V := (others=>0);
         Voffset := 64;
         v_offset := 0;

	 ns <= IDLE2;
	 
      when IDLE2 =>		-- enter once every channel
       
         index := 0;
         V_index:=0;
         sum := 0;
         sample_value:=(others=>'0');
         t_sample_value:=(others=>'0');
         for i in 0 to 31 loop
            samples(i):=(others=>'0');
            bandPtr_fix(i):=(others=>'0');
            temp_V(i):=0;
         end loop;
         counter_sb := 0;
         counter_ss := 0;
         done <= '0';
         
         ns <= STARTSTATE;
         
      when STARTSTATE =>         
         if (start = '1') then
            ns <= SEND_READ_ADDR;
         else 
            ns <= IDLE2;
         end if;
         
      when SEND_READ_ADDR =>		-- read memory
         memc.addr <= conv_std_logic_vector(counter_ss*32+counter_sb, 10);	
         memc.en <= '1';		-- active high
         memc.oe <= '1';		-- active high
         memc.we <= '0';		-- active high
	       
         ns <= DO_NOTHING;
         
      when DO_NOTHING =>		-- wait 1 cycle until data is available
         ns <= READDATA;
            
      when READDATA =>
         bandPtr_fix(counter_sb) := din;
 
         counter_sb := counter_sb+1; 
         if counter_sb=32 then
            counter_sb := 0;
            ns <= FILTERBANK;
         else
            ns <= SEND_READ_ADDR;
         end if;
         
      when FILTERBANK   => 
         v_offset := VOffset - 64 ;
         if v_offset<0 then
             v_offset:=v_offset+1024;
         end if;
         
         VOffset := v_offset;
         
         temp_V := subsyn_pre_gen(bandPtr_fix, v_offset ); -- matrixing calculation

         V(v_offset+17) := temp_V(0);
         V(v_offset+33) := temp_V(1);
         V(v_offset+25) := temp_V(2);
         V(v_offset+41) := temp_V(3);
         V(v_offset+21) := temp_V(4);
         V(v_offset+37) := temp_V(5);
         V(v_offset+29) := temp_V(6);
         V(v_offset+45) := temp_V(7);
         V(v_offset+19) := temp_V(8);
         V(v_offset+35) := temp_V(9);
         V(v_offset+27) := temp_V(10);
         V(v_offset+43) := temp_V(11);
         V(v_offset+23) := temp_V(12);
         V(v_offset+39) := temp_V(13);
         V(v_offset+31) := temp_V(14);
         V(v_offset+47) := temp_V(15);
         V(v_offset+18) := temp_V(16);
         V(v_offset+34) := temp_V(17);
         V(v_offset+26) := temp_V(18);
         V(v_offset+42) := temp_V(19);
         V(v_offset+22) := temp_V(20);
         V(v_offset+38) := temp_V(21);
         V(v_offset+30) := temp_V(22);
         V(v_offset+46) := temp_V(23);
         V(v_offset+20) := temp_V(24);
         V(v_offset+36) := temp_V(25);
         V(v_offset+28) := temp_V(26);
         V(v_offset+44) := temp_V(27);
         V(v_offset+24) := temp_V(28);
         V(v_offset+40) := temp_V(29);
         V(v_offset+32) := temp_V(30);
         V(v_offset+48) := temp_V(31);

    
         V(v_offset+16):=0;

         for i in 0 to 15 loop
             V(v_offset+i) := 0 - V(v_offset+32-i);
             V(v_offset+i+48) := V(v_offset+48-i);
         end loop;     
     
         for j in 0 to 31 loop
             sum := 0;
             index := j;
	     
	     -- subsyn_post_gen.c
	     for i in 0 to 15 loop
	        V_index := index + divide((i+1),2)*64 + v_offset;
	        if V_index > 1023 then
	           V_index := V_index-1024;
	        end if;
	        sum := sum + fix_mul(D(index), V(V_index));
	        index:=index+32;
	     end loop;


             t_sample_value := conv_std_logic_vector( (sum + 16384), 32 );
             if( t_sample_value(31)='0' ) then
	        sample_value := "000000000000000" & t_sample_value(31 downto 15);
	     else
	        sample_value := "111111111111111" & t_sample_value(31 downto 15);	       
	     end if;   
	     
             if (sample_value > MAX_OUTPUT_LIMIT) then
                 sample_value := conv_std_logic_vector(MAX_OUTPUT_LIMIT, 32);
	     end if;
	     
             if (sample_value < (0-MAX_OUTPUT_LIMIT)) then
                 sample_value := conv_std_logic_vector((0-MAX_OUTPUT_LIMIT), 32);
             end if;

             samples(j) := sample_value;

         end loop;
       
          ns <= SEND_WRITE_ADDR;	
          	
      when SEND_WRITE_ADDR =>		-- write back  to main memory
         dout <= samples(counter_sb);
         memc.addr <= conv_std_logic_vector(counter_ss*32+counter_sb, 10);
         memc.we <= '1';		-- active high	
         memc.en <= '1';		-- active high	
         memc.oe <= '0';		-- active high
      
         ns <= WRITEDATA;
      
      
      when WRITEDATA =>
         counter_sb := counter_sb+1;
         if counter_sb=32 then
            counter_sb:=0;
            counter_ss:=counter_ss+1;
            if counter_ss=18 then
                ns <= READY;
            else
                ns <= SEND_READ_ADDR;
            end if;    
         else
            ns <= SEND_WRITE_ADDR;
         end if;
      
          
      when READY  => 
         done <= '1';		
         ns <= IDLE2;
         
      when others => 
      
    end case;
    
  end process;
  
  -- sequentional update -------------------------------------------------------------------------

  process(clk, rst)
  begin
    if rst='1' then
       cs <= IDLE;
    elsif rising_edge(clk) then
      cs <= ns;
    end if;
  end process;

end;
