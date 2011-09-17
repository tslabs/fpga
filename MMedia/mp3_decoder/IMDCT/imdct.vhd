---------------------------------------------------------------------------------
-- File Name: imdct.vhd
-- Function Description:
--	This is the main module of component IMDCT. Two packages are 
--	used in this module: all_types.vhd, and imdct_package.vhd
---------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use work.all_types.all;	
use work.imdct_package.all;
use work.mul.all;

entity imdct is
  port( clk   : in  std_logic;		-- clock input signal
        rst   : in  std_logic;		-- reset signal (1 = reset)
        start : in  std_logic;		-- start=1 means that this block is activated
        done  : out std_logic;		-- generate a done signal for one clock pulse when finished
        din  : in  std_logic_vector(31 downto 0);	-- signals from memory
        dout  : out std_logic_vector(31 downto 0);	   -- signals to memory
		  memc: out mem_control_type;                   -- signals to memory
        frm   : in  frame_type);		-- contains all header and side information for the current frame
 end imdct;                                  

architecture behavioral of imdct is

  type state_type is (rst_prev_block,idle,judge1,send_addr,idle1,get_data,judge2,send_data_to_comp,calc,judge3,send_data,judge4,done1);
  signal present_state,next_state: state_type;
  type type_dct_out is array (0 to 575) of std_logic_vector(31 downto 0);
  signal dct_in,dct0_in,dct1_in,dct2_in,dct3_in,dct0_out,dct1_out,dct2_out,dct3_out : type_dct;
  signal prev_line0_in,prev_line1_in,prev_line2_in,prev_line3_in,prev_line0_out,prev_line1_out,prev_line2_out,prev_line3_out:type_dct;
  signal dct_out : type_dct_out;
  signal sig_memc: mem_control_type;
  signal memo_en:std_logic_vector(2 downto 0); 
  signal sig_block_type:std_logic_vector(1 downto 0);
  signal prev_block:type_dct_out; 
 
  component imdct0_gen
            port (dct_in: in type_dct;
				      dct_out: out type_dct;
						prev_line_in: in type_dct;
						prev_line_out: out type_dct);
			  end component;
			                  	  
  component imdct1_gen
             port( dct_in: in type_dct;
				      dct_out: out type_dct;
						prev_line_in: in type_dct;
						prev_line_out: out type_dct);
			   end component;
 
  component imdct2_gen
             port(dct_in: in type_dct;
				      dct_out: out type_dct;
						prev_line_in: in type_dct;
						prev_line_out: out type_dct); 
				end component;


  component imdct3_gen
             port(dct_in: in type_dct;
				      dct_out: out type_dct;
						prev_line_in: in type_dct;
						prev_line_out: out type_dct );
            end component;
 
  begin
    memc<=sig_memc;
 	 	
   c0: imdct0_gen
	   port map  ( dct_in => dct0_in, 
				      dct_out => dct0_out,
					  	prev_line_in => prev_line0_in,
						prev_line_out => prev_line0_out);

   c1: imdct1_gen
	   port map( dct_in => dct1_in,
				      dct_out => dct1_out,
					  	prev_line_in => prev_line1_in,
						prev_line_out => prev_line1_out);


  c2: imdct2_gen
	   port map( dct_in => dct2_in,
				      dct_out => dct2_out,
					  	prev_line_in => prev_line2_in,
						prev_line_out => prev_line2_out);

  c3:imdct3_gen
	   port map( dct_in => dct3_in,
				      dct_out => dct3_out,
					  	prev_line_in => prev_line3_in,
						prev_line_out => prev_line3_out);


 process(clk)  
     begin
       if(clk'event and clk='1')then
          if rst ='1' then               
	  present_state<= rst_prev_block;
     	   else
          present_state<=next_state;
         end if ;
      end if;
  end process;

 process(present_state)
    variable sb_count,ss_count,data_count:integer; 
 
     begin 
	         
	  case present_state is
	  when rst_prev_block =>
	                       for i in 0 to 575 loop
	                         prev_block(i) <=(others=>'0');
	                        end loop;
	                        next_state<=idle;
	           
	  when idle  => sig_memc.en<='0';
                        sig_memc.we<='0';
                        sig_memc.oe<='0';
	                
	                 sb_count:=0;
						  data_count:=0;
						  ss_count := 0;
						  done<='0';

						  for i in 0 to 17 loop
						  dct_in(i)<=(others=>'0');
						
						  end loop;
					   
						  
						  sig_memc.addr<=(others=>'0');
						 

						  next_state<= judge1;  

                                              


	when judge1=>
                    if start ='1' then
						    next_state<=send_addr;
						  else
                      next_state<=idle;
						  end if;
						  
						  
	when send_addr =>sig_memc.we<='0';
	                 sig_memc.en<='1';
			 sig_memc.oe<='1';
			 dout <= (others=>'0'); 
	                 sig_memc.addr<= conv_std_logic_vector((sb_count*18+ss_count),10); 					  
	                 
                       
                                     
			 next_state <= idle1;
                       
     when idle1 =>      next_state<= get_data;
                        
		 			  
	  	                 
    when get_data =>     ss_count:=ss_count+1;

	                 dct_in(ss_count-1)<=din;
                          			 
			  if ss_count=18 then			  
			  	next_state<= judge2;
			  else
			  	next_state <= send_addr;
			  end if;

    
    when judge2 =>  ss_count:=0;
                    if sb_count < 2 and frm.sideinfo.blocksplit_flag ='1' and frm.sideinfo.switch_point ='1' then       
    						  sig_block_type <="00";
                    else  						     
		     sig_block_type<=frm.sideinfo.block_type;
		    end if;
                     next_state<=send_data_to_comp;              	  
						  


   when send_data_to_comp => if sig_block_type ="00" then
                                  for i in 0 to 17 loop
				     dct0_in(i) <=  dct_in(i);
				     prev_line0_in(i)<=prev_block(sb_count*18+i);
			          end loop;	     
                             end if;     
   
                              if sig_block_type ="01" then
                                     for i in 0 to 17 loop
				      dct1_in(i) <=  dct_in(i);
				      prev_line1_in(i)<=prev_block(sb_count*18+i);
				     end loop;	     
                             end if;   
   
                              if sig_block_type = "10" then
	                              for i in 0 to 17 loop
				       dct2_in(i) <=  dct_in(i);
				       prev_line2_in(i)<=prev_block(sb_count*18+i);
				      end loop;	     
                              end if;   
   
                               if sig_block_type ="11" then
                                   for i in 0 to 17 loop
				    dct3_in(i) <=  dct_in(i);
				    prev_line3_in(i)<=prev_block(sb_count*18+i);
				   end loop;	     
                               end if;   
   
                          next_state<= calc;
   
   
   
   when calc =>
                 if sig_block_type ="00" then
                     			    for i in 0 to 17 loop
      			            prev_block(sb_count*18+i)<=prev_line0_out(i);
				
   				     dct_out(sb_count*18 +i)<=dct0_out(i);
    			    end loop;
      		 end if;
            
	            if sig_block_type ="01" then
                 
			        for i in 0 to 17 loop
					     prev_block(sb_count*18+i)<=prev_line1_out(i);
				        
 	  				dct_out(sb_count*18 +i)<=dct1_out(i);
   			     end loop;
               end if;
       	   	                
  		       if sig_block_type = "10" then
	               		    for i in 0 to 17 loop
					   prev_block(sb_count*18+i)<=prev_line2_out(i);
				     
 				    dct_out(sb_count*18 +i)<=dct2_out(i);
				    end loop;
   		   end if;

			 if sig_block_type ="11" then
              
				  for i in 0 to 17 loop
				     prev_block(sb_count*18+i)<=prev_line3_out(i);
				     dct_out(sb_count*18 +i)<=dct3_out(i); 
				  end loop;
	   	  end if;

			  sb_count:=sb_count+1;
			  next_state<=judge3;  
	  when judge3 => 
			  if sb_count = 32 then
			  sb_count:=0;
			  next_state <=send_data;
			  else
			  next_state<=send_addr;
			  end if;
		                              
	  when send_data=>       sig_memc.oe<='0';
 	 	                 sig_memc.en<='1';
		 		 sig_memc.we<='1';
				 sig_memc.addr<=conv_std_logic_vector(data_count,10);
				 dout<=dct_out(data_count);
				 data_count:=data_count+1;
             next_state<=judge4;  
	  when judge4=>				
				 if data_count =576 then
 				   next_state<= done1;
 				   data_count:=0;
				 else
				   next_state<=send_data;
				 end if;

    when done1 => done <='1';
                                 next_state<=idle;

 when others => next_state <=idle;
 end case;
 end process;
 end behavioral ;        
    
       
  
