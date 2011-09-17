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

entity spi is
port
	(
	zclk		: in std_logic;
	ziord		: in std_logic;
	ziowr		: in std_logic;
	spiclk		: in std_logic;
	nreset		: in std_logic;
	zaddr		: in std_logic_vector(15 downto 0);
	zdata_i		: in std_logic_vector(7 downto 0);
	sd_di		: in std_logic;
	tx_busy		: in std_logic;
	di_floppy	: in std_logic_vector(15 downto 0);
	di_user		: in std_logic_vector(7 downto 0);
	sw			: in std_logic_vector(3 downto 0);
	zena		: in std_logic;
	zdata_o		: out std_logic_vector(7 downto 0);
	sd_cs 		: out std_logic_vector(7 downto 0);
	sd_clk 		: out std_logic;
	sd_do		: out std_logic;
	wait_o		: out std_logic;
	tx_data		: out std_logic_vector(7 downto 0);
	tx_start	: out std_logic;
	links		: out std_logic_vector(15 downto 0);
	rechts		: out std_logic_vector(15 downto 0);
	audata		: out std_logic;
	cd_clk		: out std_logic;
	do_user		: out std_logic_vector(7 downto 0);
	do_floppy	: out std_logic_vector(15 downto 0);
	hex0		: out std_logic_vector(6 downto 0);
	hex1		: out std_logic_vector(6 downto 0);
	hex2		: out std_logic_vector(6 downto 0);
	hex3		: out std_logic_vector(6 downto 0);
	ledr		: out std_logic_vector(9 downto 0)
	);
end;

architecture rtl of spi is

signal sd_out	: std_logic_vector(7 downto 0);
signal sd_di_in	: std_logic;
signal shiftcnt	: std_logic_vector(3 downto 0);
signal sck		: std_logic;
signal zscs		: std_logic;
signal zexe_dir		: std_logic;
signal scs		: std_logic_vector(7 downto 0);
signal SDcommand	: std_logic_vector(7 downto 0);
signal SD_busy		: std_logic;
signal links_tmp	: std_logic_vector(15 downto 0);
signal rechts_tmp	: std_logic_vector(7 downto 0);
signal clkgen: std_logic_vector(10 downto 0);
signal spi_div: std_logic_vector(7 downto 0);
signal spi_speed: std_logic_vector(7 downto 0);


BEGIN
	sd_cs <= NOT scs;
	sd_clk <= NOT sck;
	wait_o <= '1' WHEN zaddr/=x"fc09" OR (SD_busy='0' AND zexe_dir='0') OR (ziord AND ziowr)='1' ELSE '0';
--	sd_di_in <= sd_di;
	sd_do <= sd_out(7);
	SD_busy <= shiftcnt(3);
-----------------------------------------------------------------
--  Z80-Interface (RS232 & SPI)
-----------------------------------------------------------------	
	PROCESS (zclk, nreset, zaddr, ziord, tx_busy, di_floppy, di_user, sw, sd_out)
	BEGIN
		zdata_o <= "ZZZZZZZZ";	
		IF nreset ='0' THEN 
			Tx_Start <= '0';
			zexe_dir <= '0';
			Zscs <= '0';
			scs(7 downto 2) <= (OTHERS => '0');
			scs(0) <= '0';
			spi_speed <= "00000001";
--			spi_speed <= "00000000";
		ELSIF (zclk'event and zclk='1') THEN
		
			if clkgen/=0 then
				clkgen <= clkgen-1;
				cd_clk <= '0';
			else	
	--			clkgen <= "1101000000";--832;		--96MHz/115200
	--			clkgen <= "0011110010";--243;		--28MHz/115200
	--			clkgen <= "1001100100";--612;		--27MHz/44100
				clkgen <= "01010001001";--649;		--28,69MHz/44100
--				clkgen <= "10100010100";--1300;		--56MHz/44100
				cd_clk <= '1';
			end if;

			audata <= '0';
			Tx_Start <= '0';
			IF SD_busy='1' THEN
				zexe_dir <= '0';
			END IF;
			IF zaddr=x"fc07" AND ziowr='0' AND zena='1' THEN	--OUT FC07 UART
				Tx_Data <= zdata_i;		
				Tx_Start <= '1';
			END IF;		
			IF zaddr=x"fc08" AND ziowr='0' AND zena='1' THEN	--Status IN FC08
--				zscs <= not zdata_i(0);
--				scs(7 downto 1) <= not zdata_i(7 downto 1);
				scs(0) <= not zdata_i(0);
				IF zdata_i(7)='1' THEN
					scs(7) <= not zdata_i(0);
				END IF;
				IF zdata_i(6)='1' THEN
					scs(6) <= not zdata_i(0);
				END IF;
				IF zdata_i(5)='1' THEN
					scs(5) <= not zdata_i(0);
				END IF;
				IF zdata_i(4)='1' THEN
					scs(4) <= not zdata_i(0);
				END IF;
				IF zdata_i(3)='1' THEN
					scs(3) <= not zdata_i(0);
				END IF;
				IF zdata_i(2)='1' THEN
					scs(2) <= not zdata_i(0);
				END IF;
				IF zdata_i(1)='1' THEN
					zscs <= not zdata_i(0);
				END IF;
			END IF;		
			IF zaddr=x"fc09" AND ziowr='0' AND SD_busy='0' AND zena='1' THEN	--OUT FC09 --SD write
				zexe_dir <= '1';
				SDcommand <= zdata_i;		
			END IF;		
			IF zaddr=x"fc0A" AND ziowr='0' AND zena='1' THEN	--OUT FC0A --SD speed
				spi_speed <= zdata_i;		
			END IF;		
			IF zaddr=x"fc0C" AND ziowr='0' AND zena='1' THEN	--OUT FC0C --USER
				do_user <= zdata_i;		
			END IF;		
			IF zaddr=x"fc20" AND ziowr='0' AND zena='1' THEN	--OUT FC20 --floppy
				do_floppy(7 downto 0) <= zdata_i;		
			END IF;		
			IF zaddr=x"fc21" AND ziowr='0' AND zena='1' THEN	--OUT FC21 --floppy
				do_floppy(15 downto 8) <= zdata_i;		
			END IF;		
			IF zaddr=x"fc28" AND ziowr='0' AND zena='1' THEN	--OUT FC28 --HEX0
				hex0 <= zdata_i(6 downto 0);		
			END IF;		
			IF zaddr=x"fc29" AND ziowr='0' AND zena='1' THEN	--OUT FC29 --HEX1
				hex1 <= zdata_i(6 downto 0);		
			END IF;		
			IF zaddr=x"fc2a" AND ziowr='0' AND zena='1' THEN	--OUT FC2a --HEX2
				hex2 <= zdata_i(6 downto 0);		
			END IF;		
			IF zaddr=x"fc2b" AND ziowr='0' AND zena='1' THEN	--OUT FC2b --HEX3
				hex3 <= zdata_i(6 downto 0);		
			END IF;		
			IF zaddr=x"fc2c" AND ziowr='0' AND zena='1' THEN	--OUT FC2c --ledr
				ledr(7 downto 0) <= zdata_i;		
			END IF;		
			IF zaddr=x"fc2d" AND ziowr='0' AND zena='1' THEN	--OUT FC2d --ledr
				ledr(9 downto 8) <= zdata_i(1 downto 0);		
			END IF;		
			IF zaddr=x"fc10" AND ziowr='0' AND zena='1' THEN	--links low
				links_tmp(7 downto 0) <= zdata_i;		
			END IF;		
			IF zaddr=x"fc11" AND ziowr='0' AND zena='1' THEN	--links high
				links_tmp(15 downto 8) <= zdata_i;		
			END IF;		
			IF zaddr=x"fc12" AND ziowr='0' AND zena='1' THEN	--rechs low
				rechts_tmp(7 downto 0) <= zdata_i;		
--				links_tmp(15) <= NOT links_tmp(15);
			END IF;		
			IF zaddr=x"fc13" AND ziowr='0' AND zena='1' THEN	--rechs high
				rechts(14 downto 8) <= zdata_i(6 downto 0);	
				rechts(15) <= zdata_i(7);	
				links <= links_tmp;
				rechts(7 downto 0) <= rechts_tmp;	
				audata <= '1';
			END IF;		
		END IF;		
		IF zaddr=x"fc08" AND ziord='0' THEN	--Status IN FC08
			zdata_o(7) <= tx_busy;	
			zdata_o(3 downto 0) <= sw;	
		END IF;		
		IF zaddr=x"fc09" AND ziord='0' THEN	--SD_in IN FC09
			zdata_o <= sd_out;	
		END IF;		
		IF zaddr=x"fc0C" AND ziord='0' THEN	--User_in IN FC0C
			zdata_o <= di_user;	
		END IF;		
		IF zaddr=x"fc20" AND ziord='0' THEN	--floppy_in IN FC20
			zdata_o <= di_floppy(7 downto 0);	-- bufdout[7:0]
		END IF;		
		IF zaddr=x"fc21" AND ziord='0' THEN	--floppy_in IN FC21
			zdata_o <= di_floppy(15 downto 8);	-- bufdout[15:8]
		END IF;		
--		IF zaddr=x"fc22" AND ziord='0' THEN	--floppy_in IN FC22
--			zdata_o <= di_floppy(23 downto 16);	-- track[7:0]
--		END IF;		
--		IF zaddr=x"fc23" AND ziord='0' THEN	--floppy_in IN FC23
--			zdata_o <= di_floppy(31 downto 24);	-- user[2:0],2'b00,trackch,trackrd,trackwr
--		END IF;		
	END PROCESS;
	
-----------------------------------------------------------------
-- SPI-Interface
-----------------------------------------------------------------	
	PROCESS (spiclk, nreset) BEGIN
		IF (spiclk'event and spiclk='0') THEN
			sd_di_in <= sd_di;
		END IF;

	
		IF nreset ='0' THEN 
			shiftcnt <= (OTHERS => '0');
			spi_div <= (OTHERS => '0');
			scs(1) <= '0';
			sck <= '0';
		ELSIF (spiclk'event and spiclk='1') THEN
			IF SD_busy='0' THEN
				scs(1) <= zscs;
			END IF;
			IF zexe_dir='1' AND SD_busy='0' THEN	 --SD write
				spi_div <= spi_speed;
				shiftcnt <= "1111";
				sd_out <= SDcommand;
				sck <= '1';
			ELSE
				IF spi_div="00000000" THEN
					spi_div <= spi_speed;
					IF SD_busy='1' THEN
						IF sck='0' THEN
							IF shiftcnt(2 downto 0)/="000" THEN
								sck <='1';
							END IF;
							shiftcnt <= shiftcnt-1;
							sd_out <= sd_out(6 downto 0)&sd_di_in;
						ELSE	
							sck <='0';
						END IF;
					END IF;
				ELSE
					spi_div <= spi_div-1;
				END IF;
			END IF;		
		END IF;		
	END PROCESS;
END;
