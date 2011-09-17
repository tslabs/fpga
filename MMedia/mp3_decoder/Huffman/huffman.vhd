library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_arith.all;
use work.all_types.all;			
use work.huffman_types.all;  -- this file contains all the tables of huffman decoders

entity huffman is
  port( clk   : in  std_logic;      -- input clock signal
        rst   : in  std_logic;      -- reset signal ('1' = reset)
        start : in  std_logic;      -- start='1' means that this component is activated
        done  : out std_logic;      -- produce a done signal when process is finished
        gr    : in  std_logic;      -- granule ('0'=granule0, '1'=granule1)
        bin   : in  std_logic_vector(7 downto 0);    -- input main data for huffman
        addr  : out std_logic_vector(9 downto 0);    -- address for main data
        dout  :  out std_logic_vector(31 downto 0);   -- data to memory
	      memc  : out mem_control_type;  -- memeory controll signal
	      sco   : out scalefac_type;  -- output scale factors 
        frm   : in  frame_type      -- contains all header and side information for the current frame
      );
end;

architecture behavioral of huffman is

  type state_type is 
  ( IDLE1,IDLE2,IDLE3,READ,READ1,READ2,READREADY,SCALE,HUFFMAN,HUFFBIGVALUE,TABLELOOKUP1,HUFFCOUNT1,TABLELOOKUP2,HUFFEND,DATAREADY,READY );
  signal cs,ns:state_type;
  
  type is_type is array (0 to 575) of integer;
  signal isg : is_type;

  signal addrcount1:std_logic_vector(9 downto 0);
  signal valuebuffer : std_logic_vector(0 to 8191 );
 
begin

  process(cs, frm, gr, start)
   
    variable scalefac : integer;
    variable count : integer ;
    variable memaddrcount : std_logic_vector(9 downto 0);
    variable scout : scalefac_type;
    variable bitpos:std_logic_vector(12 downto 0);
    variable region1start,region2start,bigvalues,count1s,start_bit1,start_bit2,start_bit,tempbit: integer;
    variable line,line1,region,old_region : integer;
    variable u,w,x,y,linbits:integer;
    variable level,level1,value,temp,templevel:integer;
    variable tindex:integer range 0 to 33;
    variable tempvector : std_logic_vector(7 downto 0);
    variable tempvector1 : std_logic_vector(3 downto 0);
    variable slenval0,slenval1:integer;
    variable tempval,tempdata,temphuff,temphuff1,temppos:integer;
    variable tempcount1:std_logic;

  begin

    case cs is
      when IDLE1   =>  
                       addrcount1 <= (others =>'0');
		       ns<=IDLE2;
      when IDLE2   =>  
                       done <= '0';
                       count :=0;
		       line :=0;
		       line1 :=0;
		       bigvalues:=0;
		       count1s:=0;
		       start_bit:=0;
		       linbits:=0;
		       tempvector1:=(others =>'0');
		       tempvector:=(others =>'0');
		       tindex:=0;
		       temp:=0;
		       value:=0;
		       isg<=(others=>0);   
         	       ns<=IDLE3;
      when IDLE3  => 
                     if (start = '1') then
		         memaddrcount :=(others =>'0');
                     end if;
                     ns<=READ;
      when READ   => 
                    
                     addr <= addrcount1;
                     ns<=READ1;
                          
      when READ1=>
		    ns<=READREADY;
           
      when READREADY => 
      			valuebuffer(count to count+7 ) <= bin;
      			count := count +8;
      		        addrcount1 <= addrcount1 +1;
      		       
                        if count=8192 then
                           if gr='0' then
			      bitpos:=conv_std_logic_vector((conv_integer(frm.sideinfo.main_data)*8),13);
         	           else
		              start_bit2:=conv_integer(bitpos);
                       	   end if;
                              ns<= SCALE;
                        else
                            ns<= READ;
                        end if;
                  
      when SCALE  => scalefac := conv_integer(frm.sideinfo.scalefac_compress);
                  
                     slenval0:= slen(0,scalefac);
                     slenval1:= slen(1,scalefac);
                     if (frm.sideinfo.blocksplit_flag = '1') and (frm.sideinfo.block_type = "10") then
        			if (frm.sideinfo.switch_point = '1' ) then
	    		   for sfb in 0 to 7 loop 
	      		       if 8191-conv_integer(bitpos)+1>=slenval0 then
	      		       	  scout.scalefac_l(sfb)	:= conv_std_logic_vector(conv_integer(valuebuffer(conv_integer(bitpos) to conv_integer(bitpos)+slenval0-1)),4);
		     	          if 8191-conv_integer(bitpos)+1=slenval0 then
		     	             bitpos:=(others=>'0');
		     	             tempcount1:='1';
		     	          else
		     	             bitpos := conv_std_logic_vector((conv_integer(bitpos) + slenval0),13);
		     	          end if;
		     	       else
	                          temppos:=conv_integer(bitpos);
	                          tempval:=8191-temppos+1;	
	                              
		     	          scout.scalefac_l(sfb)	:=
		     	          conv_std_logic_vector(conv_integer(valuebuffer(temppos to 8191)& valuebuffer(0 to slenval0-tempval-1)),4);
		     	          bitpos:=(others=>'0'); 
	                          tempcount1:='1';    	   
		     	          bitpos := conv_std_logic_vector((slenval0-tempval),13);
		     	       end if;
	
		     	   end loop;   
		     	   for sfb in 3 to 11 loop
		       	       for window in 0 to 2 loop 
			          if (sfb < 6) then 
			              if 8191-conv_integer(bitpos)+1>=slenval0 then
	      		       	  	scout.scalefac_s(sfb)(window):= conv_std_logic_vector(conv_integer(valuebuffer(conv_integer(bitpos) to conv_integer(bitpos)+slenval0-1)),4);
		     	          		if 8191-conv_integer(bitpos)+1=slenval0 then
		     	                   bitpos:=(others=>'0');
		     	                   tempcount1:='1';
		     	                else
		     	          		   bitpos := conv_std_logic_vector((conv_integer(bitpos) + slenval0),13);
		     	       	        end if;
		     	       	      else
	                          			   temppos:=conv_integer(bitpos);
	                                tempval:=8191-temppos+1;
	                          		   
		     	                scout.scalefac_s(sfb)(window):=
		     	                conv_std_logic_vector(conv_integer(valuebuffer(temppos to 8191)& valuebuffer(0 to slenval0-tempval-1)),4);
		     	                bitpos:=(others=>'0');
	                          		    tempcount1:='1';      	       
		     	                bitpos := conv_std_logic_vector((slenval0-tempval),13);
		     	              end if;			
			          else  
			             if 8191-conv_integer(bitpos)+1>=slenval1 then
	      		       	  	scout.scalefac_s(sfb)(window):=
	      		       	  	conv_std_logic_vector(conv_integer(valuebuffer(conv_integer(bitpos) to conv_integer(bitpos)+slenval1-1)),4);
		     	          		if 8191-conv_integer(bitpos)+1=slenval1 then
		     	             		   bitpos:=(others=>'0');
		     	                   tempcount1:='1';
		     	                else
		     	          		   bitpos := conv_std_logic_vector((conv_integer(bitpos) + slenval1),13);
		     	                end if;
		     	             else
	                          			   temppos:=conv_integer(bitpos);
	                                tempval:=8191-temppos+1;
	                          		    
		     	                scout.scalefac_s(sfb)(window):=
		     	                conv_std_logic_vector(conv_integer(valuebuffer(temppos to 8191)& valuebuffer(0 to slenval1-tempval-1)),4);
		     	                bitpos:=(others=>'0'); 
	                          		    tempcount1:='1';     	       
		     	                bitpos := conv_std_logic_vector((slenval1-tempval),13);
		     	            end if;		

				    	
			          end if;
			       end loop;
		           end loop;
	                 
	               else 
	  		    for sfb in 0 to 11 loop 
	                       for window in 0 to 2 loop 
		  	           if (sfb < 6) then 
		  	               if 8191-conv_integer(bitpos)+1>=slenval0 then
	      		       	  	scout.scalefac_s(sfb)(window):= conv_std_logic_vector(conv_integer(valuebuffer(conv_integer(bitpos) to conv_integer(bitpos)+slenval0-1)),4);
		     	          		if 8191-conv_integer(bitpos)+1=slenval0 then
		     	                   bitpos:=(others=>'0');
		     	                   tempcount1:='1';
		     	                else
		     	          		   bitpos := conv_std_logic_vector((conv_integer(bitpos) + slenval0),13);
		     	          		end if;
		     	       	      else
	                          			   temppos:=conv_integer(bitpos);
	                                tempval:=8191-temppos+1;
	                          		   
		     	                scout.scalefac_s(sfb)(window):=
		     	                conv_std_logic_vector(conv_integer(valuebuffer(temppos to 8191)& valuebuffer(0 to slenval0-tempval-1)),4);
		     	                bitpos:=(others=>'0'); 
	                          		    tempcount1:='1';     	       
		     	                bitpos := conv_std_logic_vector((slenval0-tempval),13);
		     	              end if;			
		    		   else 
		    		       if 8191-conv_integer(bitpos)+1>=slenval1 then
	      		       	  	scout.scalefac_s(sfb)(window):= 
	      		       	  	conv_std_logic_vector(conv_integer(valuebuffer(conv_integer(bitpos) to conv_integer(bitpos)+slenval1-1)),4);
		     	          		if 8191-conv_integer(bitpos)+1=slenval1 then
		     	                   bitpos:=(others=>'0');
		     	                   tempcount1:='1';
		     	                else
		     	          		   bitpos := conv_std_logic_vector((conv_integer(bitpos) + slenval1),13);
		     	       	        end if;
		     	       	      else
	                          			   temppos:=conv_integer(bitpos);
	                                tempval:=8191-temppos+1;
	                          		    
		     	                scout.scalefac_s(sfb)(window):=
		     	                conv_std_logic_vector(conv_integer(valuebuffer(temppos to 8191)& valuebuffer(0 to slenval1-tempval-1)),4);
		     	                bitpos:=(others=>'0');
	                          		    tempcount1:='1';      	       
		     	                bitpos := conv_std_logic_vector((slenval1-tempval),13);
		     	              end if;			
			  	       
		     		   end if;
			       end loop;
	   		   end loop;
                      end if;
			
                    else 
	                if (frm.sideinfo.scfsi(0) = '0') or (gr = '0') then
	                   for sfb in 0 to 5 loop 
	                       if 8191-conv_integer(bitpos)+1>=slenval0 then
	      		       	  	scout.scalefac_l(sfb):= conv_std_logic_vector(conv_integer(valuebuffer(conv_integer(bitpos) to conv_integer(bitpos)+slenval0-1)),4);
		     	          		if 8191-conv_integer(bitpos)+1=slenval0 then
		     	                   bitpos:=(others=>'0');
		     	                   tempcount1:='1';
		     	                else
		     	          		   bitpos := conv_std_logic_vector((conv_integer(bitpos) + slenval0),13);
		     	       	        end if;
		     	       	else
	                          			   temppos:=conv_integer(bitpos);
	                                tempval:=8191-temppos+1;
	                          		    
		     	                scout.scalefac_l(sfb):=
		     	                conv_std_logic_vector(conv_integer(valuebuffer(temppos to 8191)& valuebuffer(0 to slenval0-tempval-1)),4);
		     	                bitpos:=(others=>'0'); 
	                          		    tempcount1:='1';     	       
		     	                bitpos := conv_std_logic_vector((slenval0-tempval),13);
		     	        end if;			
	
	                   end loop;
                        end if;
	                if (frm.sideinfo.scfsi(1)= '0') or (gr = '0') then
	                   for sfb in 6 to 10 loop 
	                       if 8191-conv_integer(bitpos)+1>=slenval0 then
	      		       	  scout.scalefac_l(sfb)	:= conv_std_logic_vector(conv_integer(valuebuffer(conv_integer(bitpos) to conv_integer(bitpos)+slenval0-1)),4);
		     	          if 8191-conv_integer(bitpos)+1=slenval0 then
		     	             bitpos:=(others=>'0');
		     	             tempcount1:='1';
		     	          else
		     	             bitpos := conv_std_logic_vector((conv_integer(bitpos) + slenval0),13);
		     	          end if;
		     	       else
	                          temppos:=conv_integer(bitpos);
	                          tempval:=8191-temppos+1;
	                         
		     	          scout.scalefac_l(sfb)	:=
		     	          conv_std_logic_vector(conv_integer(valuebuffer(temppos to 8191)& valuebuffer(0 to slenval0-tempval-1)),4);
		     	           bitpos:=(others=>'0');
	                          tempcount1:='1';      	       
		     	          bitpos := conv_std_logic_vector((slenval0-tempval),13);
		     	       end if;
	                       
	                   end loop;
	                end if;
	                if (frm.sideinfo.scfsi(2) = '0') or (gr = '0') then
	                   for sfb in 11 to 15 loop 
	                       if 8191-conv_integer(bitpos)+1>=slenval1 then
	      		       	  	scout.scalefac_l(sfb)	:=
	      		       	  	conv_std_logic_vector(conv_integer(valuebuffer(conv_integer(bitpos) to conv_integer(bitpos)+slenval1-1)),4);
		     	          		if 8191-conv_integer(bitpos)+1=slenval1 then
		     	                   bitpos:=(others=>'0');
		     	                   tempcount1:='1';
		     	                else
		     	          		   bitpos := conv_std_logic_vector((conv_integer(bitpos) + slenval1),13);
		     	                end if;
		     	       else
	                          			   temppos:=conv_integer(bitpos);
	                                tempval:=8191-temppos+1;
	                          		   
		     	                scout.scalefac_l(sfb)	:=
		     	                conv_std_logic_vector(conv_integer(valuebuffer(temppos to 8191)& valuebuffer(0 to slenval1-tempval-1)),4);
		     	                bitpos:=(others=>'0');
	                          		    tempcount1:='1';      	       
		     	                bitpos := conv_std_logic_vector((slenval1-tempval),13);
		     	      end if;		
	                      
	                   end loop;
	                end if;
	                if (frm.sideinfo.scfsi(3) = '0') or (gr = '0') then
	                   for sfb in 16 to 20 loop 
	                       if 8191-conv_integer(bitpos)+1>=slenval1 then
	      		       	  	scout.scalefac_l(sfb)	:=
	      		       	  	conv_std_logic_vector(conv_integer(valuebuffer(conv_integer(bitpos) to conv_integer(bitpos)+slenval1-1)),4);
		     	          		if 8191-conv_integer(bitpos)+1=slenval1 then
		     	                   bitpos:=(others=>'0');
		     	                   tempcount1:='1';
		     	                else
		     	          		   bitpos := conv_std_logic_vector((conv_integer(bitpos) + slenval1),13);
		     	                end if;
		     	       else
	                          			   temppos:=conv_integer(bitpos);
	                                tempval:=8191-temppos+1;
	                          		    
		     	                scout.scalefac_l(sfb)	:=
		     	                conv_std_logic_vector(conv_integer(valuebuffer(temppos to 8191)& valuebuffer(0 to slenval1-tempval-1)),4);
		     	                bitpos:=(others=>'0');
	                          		    tempcount1:='1';      	       
		     	                bitpos := conv_std_logic_vector((slenval1-tempval),13);
		     	      end if;		

		              
                           end loop;
                        end if;		
                     end if;
    		     scout.scalefac_l(21) := "0000";
		     scout.scalefac_l(22) := "0000";
    		     for window in 0 to 2 loop
			scout.scalefac_s(12)(window) := "0000";
    		     end loop;  
    		     
    		     ns<= HUFFMAN;  
      when HUFFMAN =>  
                       if (frm.sideinfo.blocksplit_flag = '1') and (frm.sideinfo.block_type = "10") then
      			  region1start := 36;
      			  region2start :=576;
      		       else
      		          region1start := sfBandIndex_l(conv_integer(frm.header.frequency),conv_integer(frm.sideinfo.region_address1)+1);
      		          if (frm.sideinfo.blocksplit_flag = '1') then
      		             region2start :=576;
      		          else
      		             region2start := 
      		             sfBandIndex_l(conv_integer(frm.header.frequency),conv_integer(frm.sideinfo.region_address1)+conv_integer(frm.sideinfo.region_address2)+2);
      		          end if;
      		       end if;
      		       bigvalues := conv_integer(frm.sideinfo.big_values);
      		       old_region :=3;
      		        
      		       ns<= HUFFBIGVALUE;
      when HUFFBIGVALUE =>		       
      		       if (line < region1start) then
      		          	region :=0;
      		       elsif line < region2start then
      		             region :=1;
      		       else
      		             region :=2;
      		       end if;
      		       if (region /= old_region) then
      		          tindex := conv_integer(frm.sideinfo.table_select(region));
      		          
      		          linbits :=table(tindex,3);
      		          
      		          old_region :=region;
      		       end if;
      		            
      		       ns<= TABLELOOKUP1;
      when TABLELOOKUP1 =>
			
                       level :=0;
                       loop
                          temp := get_value(tindex,level,0);
      		          if temp = 0 then
      		         	   value :=get_value(tindex,level,1);
      		          end if;
      		          exit when temp =0;
            		          if conv_integer(valuebuffer(conv_integer(bitpos)))=1 then
      		             templevel:=get_value(tindex,level,1);
      	  		     if templevel>=250 then
           	  		        loop
      	  		        level:=level+ templevel;
      	  		        templevel:=get_value(tindex,level,1);
      	  		        exit when templevel<250;
      	  		        end loop;
      	  		     end if;
      		             level := level+ templevel;
      	  		  else
      	  		     templevel:=get_value(tindex,level,0);
      	  		     if templevel>=250 then
      	  		        
      	  		        loop
      	  		        level:=level+ templevel;
      	  		        templevel:=get_value(tindex,level,0);
      	  		        exit when templevel<250;
      	  		        end loop;
      	  		     end if;
      		             level := level+ templevel;
      	  		  end if;
      		          if conv_integer(bitpos)=8191 then
                       			   bitpos:=(others=>'0');
                             tempcount1:='1';  			      
                       		 else
                       			   bitpos := bitpos + '1';
                       			end if;
      		       end loop;
		       	       
		       level:=0;
      		       tempvector :=conv_std_logic_vector(value,8);
      		       x := conv_integer(tempvector(7 downto 4));
      		       y := conv_integer(tempvector(3 downto 0));
      		       if x = 15 and linbits > 0 then
      		          if 8191-conv_integer(bitpos)+1 >=linbits then
      		          	  x := x + conv_integer(valuebuffer(conv_integer(bitpos) to conv_integer(bitpos)+linbits-1));
         		             if 8191-conv_integer(bitpos)+1 =linbits then
         		                bitpos:=(others=>'0');
         		                tempcount1:='1';
         		             else
         		                bitpos := conv_std_logic_vector((conv_integer(bitpos) + linbits),13);
         		             end if;
         		          else
         		             temppos:=conv_integer(bitpos);
         		             temphuff:= 8191 - temppos+1;
         		             x := x + conv_integer(valuebuffer(temppos to 8191) & valuebuffer(0 to linbits-temphuff-1));
         		             bitpos:=(others=>'0');
         		             tempcount1:='1';
         		             bitpos:=conv_std_logic_vector((linbits-temphuff),13);
         		          end if;
         		       end if;
                       if x > 0 then
                          if conv_integer(valuebuffer(conv_integer(bitpos)))=1 then              
                             x := -x;
                          end if;
                       			if conv_integer(bitpos)=8191 then
                       			   bitpos:=(others=>'0');
                             tempcount1:='1';  			      
                       		 else
                       			   bitpos := bitpos + '1';
                       			end if;
                       end if;
                       if y = 15 and linbits > 0 then
      		          if 8191-conv_integer(bitpos)+ 1 >=linbits then
      		             y := y + conv_integer(valuebuffer(conv_integer(bitpos) to conv_integer(bitpos)+linbits-1));
         		             if 8191-conv_integer(bitpos)+ 1 =linbits then
         		                bitpos:=(others=>'0');
         		                tempcount1:='1';
         		             else
         		                bitpos := conv_std_logic_vector((conv_integer(bitpos) + linbits),13);
         		             end if;
         		          else
         		             temppos:=conv_integer(bitpos);
         		             temphuff:= 8191 - temppos+1;
         		             
         		             y:=y+conv_integer(valuebuffer(temppos to 8191) & valuebuffer(0 to linbits-temphuff-1));
         		             bitpos:=(others=>'0');
         		             tempcount1:='1';
         		             bitpos:=conv_std_logic_vector((linbits-temphuff),13);
         		          end if;
         		       end if;
                       if y > 0 then
                          if conv_integer(valuebuffer(conv_integer(bitpos)))=1 then              
                             y := -y;
                          end if;
                       		
                       		 if conv_integer(bitpos)=8191 then
                       			   bitpos:=(others=>'0');
                             tempcount1:='1';  			      
                       		 else
                       			   bitpos := bitpos + '1';
                       			end if;
                       end if;
                       
		       isg(line) <= x;
                       isg(line+1) <= y;
                             
                       line := line +2;
                       if (line >= bigvalues*2 ) then
          		          temp:=0;
      		          tempvector:=(others=>'0');
			  if gr='0' then
			     start_bit1 := conv_integer(frm.sideinfo.main_data)*8;
		 	     if  tempcount1='0' then
			         count1s:=conv_integer(frm.sideinfo.part2_3_length)-(conv_integer(bitpos)-start_bit1);
			     else
	   	                count1s:=conv_integer(frm.sideinfo.part2_3_length)-(8191-start_bit1+conv_integer(bitpos)+1);
                                tempcount1:='0';
			     end if;
			  else
			     if tempcount1='0' then
			        count1s:=conv_integer(frm.sideinfo.part2_3_length)-(conv_integer(bitpos)-start_bit2);
			     else
			        count1s:=conv_integer(frm.sideinfo.part2_3_length)-(8191-start_bit2+conv_integer(bitpos)+1);
			        tempcount1:='0';
			     end if;
			     
			  end if;
			
      		          ns<= HUFFCOUNT1;
      		       else
      		          ns<= HUFFBIGVALUE;
      		       end if;
      when HUFFCOUNT1 =>
                        if count1s>0 and line< 576 then
      			   start_bit := conv_integer(bitpos);
      			   
                           ns<= TABLELOOKUP2;
                        else
                           ns<=HUFFEND;
			end if;
      when TABLELOOKUP2	=>
                       if conv_integer(frm.sideinfo.count1table_select)=0 then
      		          level1 :=0;
      		          loop
      		              temp := get_value(32,level1,0);
      		              if temp=0 then
      		                 value := get_value(32,level1,1);
      		              end if;
      		              exit when temp=0;
      		              
      		              if conv_integer(valuebuffer(conv_integer(bitpos)))=1 then
      		                 level1 := level1+ get_value(32,level1,1);
      	  		      else
      		                 level1 := level1+ get_value(32,level1,0);
      	  		      end if;
      		              if conv_integer(bitpos)=8191 then
                       			       bitpos:=(others=>'0');
                                 tempcount1:='1';  			      
                       		     else
                       			       bitpos := bitpos + '1';
                       			    end if;
      		          end loop;
      		       else
      		          if 8191-conv_integer(bitpos)+1>= 4 then
      		             value := 15- conv_integer(valuebuffer(conv_integer(bitpos) to conv_integer(bitpos)+3));
      		             if 8191-conv_integer(bitpos)+1= 4 then
      		                bitpos:=(others=>'0');
                                tempcount1:='1';  			      
      		             else
      		                bitpos := bitpos+"100";
      		             end if;
      		          else
      		             temppos:=conv_integer(bitpos);
      		             temphuff:= 8191 - temppos+1;
         		             
         		             value:=15- conv_integer(valuebuffer(temppos to 8191)& valuebuffer(0 to 3-temphuff));
      		             bitpos:=(others=>'0');
         		             tempcount1:='1';
      		             bitpos:=conv_std_logic_vector((4-temphuff),13);
      		          end if;
      		       end if;
      		       tempvector1 := conv_std_logic_vector(value,4);
                       u := conv_integer(tempvector1(3));
                       w := conv_integer(tempvector1(2));
                       x := conv_integer(tempvector1(1));
                       y := conv_integer(tempvector1(0));
                       if u>0 then
                          if conv_integer(valuebuffer(conv_integer(bitpos)))=1 then              
                             u := -u;
                          end if;
                          	if conv_integer(bitpos)=8191 then
                       			       bitpos:=(others=>'0');
                                 tempcount1:='1';  			      
                       		  else
                       			       bitpos := bitpos + '1';
                       			 end if;
                       end if;
                       if w>0 then
                          if conv_integer(valuebuffer(conv_integer(bitpos)))=1 then              
                             w := -w;
                          end if;
                          if conv_integer(bitpos)=8191 then
                       			       bitpos:=(others=>'0');
                                 tempcount1:='1';  			      
                       		 else
                       			       bitpos := bitpos + '1';
                       		 end if;
                       end if;
                       if x>0 then
                          if conv_integer(valuebuffer(conv_integer(bitpos)))=1 then              
                             x := -x;
                          end if;
                          if conv_integer(bitpos)=8191 then
                       			       bitpos:=(others=>'0');
                                 tempcount1:='1';  			      
                       		 else
                       			       bitpos := bitpos + '1';
                       			end if;
                       end if;
                       if y>0 then
                          if conv_integer(valuebuffer(conv_integer(bitpos)))=1 then              
                             y := -y;
                          end if;
                          if conv_integer(bitpos)=8191 then
                       			       bitpos:=(others=>'0');
                                 tempcount1:='1';  			      
                       		 else
                       			       bitpos := bitpos + '1';
                       			end if;
                       end if;
                       if tempcount1='0' then
                          count1s :=count1s-(conv_integer(bitpos)-start_bit);
                       else
                          count1s :=count1s-(8191-start_bit+conv_integer(bitpos)+1);
                          tempcount1:='0';
                       end if;
                                             
                       isg(line) <= u;
                       isg(line+1) <= w;
                       isg(line+2) <= x;
                       isg(line+3) <= y;
                       
                       line :=line+4;
                       ns<= HUFFCOUNT1;
 
      when HUFFEND =>  
                       
                     --  if gr='0' then
                       --   tempbit:=conv_integer(bitpos) - start_bit1 - conv_integer(frm.sideinfo.part2_3_length);
                       --else
                         -- tempbit:=conv_integer(bitpos) - start_bit2 - conv_integer(frm.sideinfo.part2_3_length);
                       --end if;
                       --if (tempbit<0) then
                        --  bitpos:=conv_std_logic_vector((conv_integer(bitpos)-tempbit),13);
                       --end if;
   		       --if tempbit>0 then
   			  --bitpos:=conv_std_logic_vector((conv_integer(bitpos)+tempbit),13);
                       -- end if;   
                       loop
                          isg(line) <=0;
                          line := line+1;
                          exit when line >= 576;
                       end loop;
                       ns<= DATAREADY;  
     
      when DATAREADY =>
                     memc.en <= '1';		-- active high
                     memc.oe <= '0';		-- active high
		                memc.we <= '1';		-- active high
                     
                     memc.addr <= memaddrcount;
                     ns<= READY;		     
      when READY  => 
                     dout <= conv_std_logic_vector(isg(line1),32);
                     line1 :=line1+1;
      		             memaddrcount := memaddrcount+1;
      		             if line1 >=576 then
                        done <= '1';		
                        ns<= IDLE2;
                     else
                        ns<= DATAREADY;
                     end if;
     when others =>  null; 
    end case;
           
    sco <= scout; -- output scale factors
    
  end process;
  
 process(clk,rst)
 begin
    if rst='1' then
       cs<=IDLE1;
    elsif rising_edge(clk) then
       cs<=ns;
    end if;
 end process;
end;
