------------------------------------------------------------------------------
------------------------------------------------------------------------------
--                                                                          --
-- Copyright (c) 2007 Tobias Gubener <tobiflex@opencores.org>               -- 
--                                                                          --
-- This source file is free software: you can redistribute it and/or modify --
-- it under the terms of the GNU General Public License as published        --
-- by the Free Software Foundation, either version 3 of the License, or     --
-- (at your option) any later version.                                      --
--                                                                          --
-- This source file is distributed in the hope that it will be useful,      --
-- but WITHOUT ANY WARRANTY; without even the implied warranty of           --
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            --
-- GNU General Public License for more details.                             --
--                                                                          --
-- You should have received a copy of the GNU General Public License        --
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.    --
--                                                                          --
------------------------------------------------------------------------------
------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity sdram is
port
	(
	sdata		: inout std_logic_vector(15 downto 0);
	sdaddr		: out std_logic_vector(12 downto 0);
	dqm			: out std_logic_vector(3 downto 0);
	sd_cs		: out std_logic_vector(3 downto 0);
	ba			: buffer std_logic_vector(1 downto 0);
	sd_we		: out std_logic;
	sd_ras		: out std_logic;
	sd_cas		: out std_logic;

	sysclk		: in std_logic;
	reset		: in std_logic;
	
	zdatawr		: in std_logic_vector(7 downto 0);
	zAddr		: in std_logic_vector(22 downto 0);
	zwr			: in std_logic;
	datawr		: in std_logic_vector(15 downto 0);
	rAddr		: in std_logic_vector(22 downto 0);
	rwr			: in std_logic;
	dwrL		: in std_logic;
	dwrU		: in std_logic;
	zstate		: in std_logic_vector(2 downto 0);
	
	dataout		: out std_logic_vector(15 downto 0);
	zdataout		: out std_logic_vector(7 downto 0);
	c_56m		: out std_logic;
	zena_o		: out std_logic;
	c_28m		: out std_logic;
	c_7m		: out std_logic;
	reset_out	: out std_logic
	);
end;

architecture rtl of sdram is


signal initstate	:std_logic_vector(3 downto 0);
signal slow			:std_logic_vector(7 downto 0);
signal pass			:std_logic_vector(1 downto 0);
signal datard		:std_logic;
signal sdcom_ena	:std_logic;
signal isd_ras		:std_logic;
signal isd_cas		:std_logic;
signal isd_we 		:std_logic;
signal nanostate	:std_logic_vector(3 downto 0);
signal ras_pos		:std_logic;
signal wr_int		:std_logic;
signal rd_int		:std_logic;
signal init_done	:std_logic;
signal Addr			:std_logic_vector(22 downto 0);
signal isdaddr		:std_logic_vector(12 downto 0);
signal isd_cs		:std_logic_vector(3 downto 0);
signal datain		:std_logic_vector(15 downto 0);
signal casaddr		:std_logic_vector(10 downto 0);
signal casba		:std_logic_vector(1 downto 0);
signal wr 			:std_logic;
signal sdwrite 		:std_logic;
signal nextpix		:std_logic_vector(15 downto 0);


signal zena			:std_logic;
signal zcache		:std_logic_vector(63 downto 0);
signal zcache_addr	:std_logic_vector(22 downto 0);
signal zcache_recall	:std_logic;
signal fill_zcache	:std_logic;
signal match_zcache	:std_logic;
signal zvalid		:std_logic;
signal zequal		:std_logic;

signal V_cycle		:std_logic;
signal T_cycle		:std_logic;
signal R_cycle		:std_logic;
signal Z_cycle		:std_logic;

begin

	Addr <= rAddr when R_cycle='1' else zAddr;
	wr <= '0' when (R_cycle='1' AND rwr='0') OR (Z_cycle='1' AND zwr='0') else '1';
	c_7m <= T_cycle;

	sd_ras <= isd_ras or sdcom_ena;
	sd_cas <= isd_cas or sdcom_ena;
	sd_we  <= isd_we  or sdcom_ena;
	sdaddr <= isdaddr;
	sd_cs <= isd_cs when sdcom_ena='0' else "1111";
	
	zena_o <= '1' when zena='1' or match_zcache='1' else '0'; 
	
	reset_out <= init_done AND reset;
	
	process (sysclk, zAddr, zcache_addr, zcache, zstate, zequal, zvalid, match_zcache, nextpix) begin
		if zaddr(22 downto 3)=zcache_addr(22 downto 3) then
			zequal <='1';
		else	
			zequal <='0';
		end if;	
		if (zstate(2)='1' or zstate(1 downto 0)="01" or (zstate="00" and zequal='1' and zvalid='1')) then
--			match_zcache <='1';
			match_zcache <='0';
		else	
			match_zcache <='0';
		end if;	
		case match_zcache&(zaddr(2 downto 1)-zcache_addr(2 downto 1)) is
			when "100"=>
				if zaddr(0)='1' then
					zdataout <= zcache(55 downto 48);
				else
					zdataout <= zcache(63 downto 56);
				end if;
			when "101"=>
				if zaddr(0)='1' then
					zdataout <= zcache(39 downto 32);
				else
					zdataout <= zcache(47 downto 40);
				end if;
			when "110"=>
				if zaddr(0)='1' then
					zdataout <= zcache(23 downto 16);
				else
					zdataout <= zcache(31 downto 24);
				end if;
			when "111"=>
				if zaddr(0)='1' then
					zdataout <= zcache(7 downto 0);
				else
					zdataout <= zcache(15 downto 8);
				end if;
			when others=>
				if zaddr(0)='1' then
					zdataout <= nextpix(7 downto 0);
				else
					zdataout <= nextpix(15 downto 8);
				end if;
	
		end case;	
	end process;		
		
	process (sysclk) begin
			if (sysclk'event and sysclk='1') then
				if nanostate(2 downto 0)="111" then
					R_cycle <= '0';
					V_cycle <= '0';
					T_cycle <= '1';
					Z_cycle <= '0';
					
					IF slow(2 downto 0)=5 THEN
						slow <= slow+3;
					ELSE
						slow <= slow+1;
					END IF;
					case slow(3 downto 0) is
						when "0001" => V_cycle <= '1';		--refresh cycle
						when "0000"|"1000"|"0010"|"0100"|"1010"|"1100" => R_cycle <= '1';
																		  T_cycle <= '0';
						when others =>  Z_cycle <= '1';
					end case;
				end if;
			end if;
	end process;		
	
	
--Datenübernahme
	process (sysclk, reset) begin
		if reset = '0' then
			zcache_recall <= '0';
			zvalid <= '0';
			zena <= '0';
	
		elsif (sysclk'event and sysclk='1') then
				nextpix <= sdata;
				if zequal='1' and zstate="11" then
					zvalid <= '0';
				end if;
					case nanostate(2 downto 0) is	
						when "000" =>	
										c_56m <= '0';
										if fill_zcache='1' then
											zcache(47 downto 32) <= nextpix;
										end if;
						when "001" =>	
										c_28m <= '0';
										c_56m <= '1';
										if fill_zcache='1' then
											zcache(31 downto 16) <= nextpix;
										end if;
						when "010" =>	
										zcache_recall <= match_zcache;
										c_56m <= '0';
										if fill_zcache='1' then
											zcache(15 downto 0) <= nextpix;
										end if;
										fill_zcache <= '0';
						when "011" =>	
										c_28m <= '1';
										c_56m <= '1';
										if Z_cycle='1'  then
											if zcache_recall='0' then
												zena <= '1';
												if zstate="00" then
													zcache_addr <= zaddr;
													fill_zcache <= '1';
													zvalid <= '1';
												end if;
											end if;
										end if;
						when "100" =>	
										c_56m <= '0';
						when "101" =>
										c_28m <= '0';
										c_56m <= '1';
						when "110" =>	
										c_56m <= '0';
										if fill_zcache='1' then
											zcache(63 downto 48) <= sdata;
										end if;
										if R_cycle='1' then
											dataout <= sdata;
										end if;
						when "111" =>	
										c_28m <= '1';
										zena <= '0';
										c_56m <= '1'; 
						when others =>
					end case;	
			end if;
	end process;		
	
	

	process (sysclk, reset, sdwrite, datain) begin
		IF sdwrite='1' THEN
			sdata <= datain;
		ELSE
			sdata <= "ZZZZZZZZZZZZZZZZ";
		END IF;
		if reset = '0' then
			initstate <= (others => '0');
			init_done <= '0';
			nanostate <= "0000";
		else
			if (sysclk'event and sysclk='1') then
				sdcom_ena <= '1';
				ras_pos <= '0';				
				nanostate <='0'&nanostate(2 downto 0)+1;
				if ras_pos='1' then
					casaddr <= addr(10 downto 0);
					casba <= ba;
					IF R_cycle='1' THEN
						datain <= datawr;
					ELSE	
						datain <= zdatawr&zdatawr;
					END IF;	
				end if;
					case nanostate(2 downto 0) is	--LATENCY=2
						when "000" =>	pass <= "00";
						when "001" =>	sdcom_ena <= '0';
										ras_pos <= '1';				
						when "010" =>	pass <= "01";
										sdwrite <= '1';
										if V_cycle='1' then
											wr_int <= '1';
											rd_int <= '1';
										else
											wr_int <= wr ;
											rd_int <= '0';
										end if;
						when "011" =>	
										sdcom_ena <= '0';
						when "100" =>	
										pass <= "11";
										sdwrite <= '0';
						when "101" =>   
						when "110" =>	
						when "111" =>	
										if initstate /= "1111" then
											initstate <= initstate+1;
										else
											init_done <='1';	
										end if;
						when others =>
					end case;	
			end if;
		end if;	
	end process;		


	
	process (initstate, pass, addr, wr, datain, init_done, casaddr, rd_int, wr_int, dwrU, dwrL, casba, Z_cycle, V_cycle, zaddr) begin
		isdaddr<="XXXXXXXXXXXXX";
		isd_cs <= "1111"; --NOP
		isd_ras <= '1';
		isd_cas <= '1';
		isd_we <= '1';
		ba <= Addr(22 downto 21);

			if wr_int='0' then
				if Z_cycle='1' THEN
					dqm <= ("11"&  zaddr(0)& not zaddr(0));
				else
					dqm <= ("11"&  dwrU& dwrL);
				end if;
			else
				dqm <= "1100";
			end if;	



			if init_done='0' then
				case initstate & pass is
					when "001000" => --PRECHARGE
						isdaddr(10) <= '1'; 	--all banks
						isd_cs <="0000";
						isd_ras <= '0';
						isd_cas <= '1';
						isd_we <= '0';
					when "001100"|"010000"|"010100"|"011000"|"011100"|"100000"|"100100"|"101000"|"101100"|"110000" => --AUTOREFRESH
						isd_cs <="0000"; 
						isd_ras <= '0';
						isd_cas <= '0';
						isd_we <= '1';
					when "110100" => --LOAD MODE REGISTER
						isd_cs <="0000";
						isd_ras <= '0';
						isd_cas <= '0';
						isd_we <= '0';
						ba <= "00";
						isdaddr <= "0001000100010"; --BURST=4 LATENCY=2
					when others =>		--NOP
				end case;
			else		
				case pass is
					when "00" => --ACTIVE
						isdaddr <= "0"& addr(20 downto 9);
						isd_ras <= '0';
						isd_we <= '1';
						if V_cycle='1' then
							isd_cs <="0000"; --AUTOREFRESH
							isd_cas <= '0';
						else
							isd_cas <= '1';
							isd_cs <= "1110"; --ACTIVE
						end if;	
					when "01" => --READ or Write
						ba <= casba;
						isdaddr <= '0'& '0' & '1' & "00" & casaddr(8 downto 1);--auto precharge
						isd_cs <= "1110"; 
						isd_ras <= '1';
						isd_cas <= rd_int;
						isd_we  <= wr_int;
					when others =>		--NOP
				end case;
			end if;	
	end process;		
end;
