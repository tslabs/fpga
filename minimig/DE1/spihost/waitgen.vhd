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

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


entity waitgen is
   port (
	clk: in std_logic;
	nreset: in std_logic;
	addr: in std_logic_vector(23 downto 0);		
	data_in: in std_logic_vector(7 downto 0);		
	mem_ce: in std_logic;				

	memwait: in std_logic;				
	spiwait: in std_logic;				
	wrfull: in std_logic;				
	state: in std_logic_vector(1 downto 0);		
	dataIO: in std_logic_vector(7 downto 0);		
	clkena: out std_logic;
	data_out: out std_logic_vector(7 downto 0);			
	romled: out std_logic
   );

end waitgen;


architecture waitgen of waitgen is

COMPONENT hostrom
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (10 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END COMPONENT;
COMPONENT bigrom
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
		clock		: IN STD_LOGIC ;
		q			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
END COMPONENT;

signal data_rom: std_logic_vector(7 downto 0);
signal romena: std_logic;

begin
	rom: hostrom
		PORT MAP
		(
			address =>addr(10 downto 0),	--: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
			clock => NOT clk,		--: IN STD_LOGIC ;
			q => data_rom			--: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
		
--	rom: bigrom
--		PORT MAP
--		(
--			address =>addr(13 downto 0),	--: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
--			clock => NOT clk,		--: IN STD_LOGIC ;
--			q => data_rom			--: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
--		);
		
--	data_out <= dataIO WHEN mem_ce='1' ELSE data_rom WHEN romena='0' AND addr(15)='0' ELSE data_in;
	data_out <= dataIO WHEN mem_ce='1' ELSE data_rom WHEN romena='0' AND addr(23 downto 15)="010000000" ELSE data_in;
--	data_out <= data_rom WHEN romena='0' AND addr(15 downto 14)="00" ELSE data_in;
--	clkena <= '1' WHEN wrfull='0' AND spiwait='1' AND (state="01" OR memwait='1' OR mem_ce='1' OR(romena='0' AND addr(15)='0' AND mem_ce='0')) ELSE '0';
--	clkena <= '1' WHEN wrfull='0' AND spiwait='1' AND (state="01" OR memwait='1' OR mem_ce='1') ELSE '0';
	clkena <= '1' WHEN wrfull='0' AND spiwait='1' AND ( memwait='1') ELSE '0';
	romled <= romena;	
	
	process(clk, nreset)
	begin
		if nreset='0' THEN
			romena <= '0';
		elsif clk'event and clk = '1' then
--			if addr(15 downto 8)="11111111" AND mem_ce='0' AND state="11" THEN	--ld sp,0000h:call 0 startet spihost.rom ab 0000
			if addr(15 downto 14)="11" AND state="00" THEN	--JP c000 startet spihost.rom ab 0000
				romena <= '1';
			end if;
		end if;
	end process; 

end waitgen;  
