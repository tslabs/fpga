-- 
-- psg.vhd
--   Programmable Sound Generator (AY-3-8910/YM2149)
--   Revision 1.00
-- 
-- Copyright (c) 2006 Kazuhiro Tsujikawa (ESE Artists' factory)
-- All rights reserved.
-- 
-- Redistribution and use of this source code or any derivative works, are 
-- permitted provided that the following conditions are met:
--
-- 1. Redistributions of source code must retain the above copyright notice, 
--    this list of conditions and the following disclaimer.
-- 2. Redistributions in binary form must reproduce the above copyright 
--    notice, this list of conditions and the following disclaimer in the 
--    documentation and/or other materials provided with the distribution.
-- 3. Redistributions may not be sold, nor may they be used in a commercial 
--    product or activity without specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
-- "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED 
-- TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
-- PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR 
-- CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, 
-- EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
-- PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
-- OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
-- WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR 
-- OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF 
-- ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-- 

LIBRARY IEEE;
	USE IEEE.STD_LOGIC_1164.ALL;
	USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY PSG IS
	PORT(
		CLK21M		: IN	STD_LOGIC;
		RESET		: IN	STD_LOGIC;
		CLKENA		: IN	STD_LOGIC;
		REQ			: IN	STD_LOGIC;
		ACK			: OUT	STD_LOGIC;
		WRT			: IN	STD_LOGIC;
		ADR			: IN	STD_LOGIC_VECTOR( 15 DOWNTO 0 );
		DBI			: OUT	STD_LOGIC_VECTOR(  7 DOWNTO 0 );
		DBO			: IN	STD_LOGIC_VECTOR(  7 DOWNTO 0 );

		JOYA		: INOUT	STD_LOGIC_VECTOR(  5 DOWNTO 0 );
		STRA		: OUT	STD_LOGIC;
		JOYB		: INOUT	STD_LOGIC_VECTOR(  5 DOWNTO 0 );
		STRB		: OUT	STD_LOGIC;

		KANA		: OUT	STD_LOGIC;
		CMTIN		: IN	STD_LOGIC;
		KEYMODE		: IN	STD_LOGIC;

		WAVE		: OUT	STD_LOGIC_VECTOR(  7 DOWNTO 0 )
 );
END PSG;

ARCHITECTURE RTL OF PSG IS

	COMPONENT PSG_WAVE
		PORT (
			CLK21M		: IN	STD_LOGIC;
			RESET		: IN	STD_LOGIC;
			CLKENA		: IN	STD_LOGIC;
			REQ			: IN	STD_LOGIC;
			ACK			: OUT	STD_LOGIC;
			WRT			: IN	STD_LOGIC;
			ADR			: IN	STD_LOGIC_VECTOR( 15 DOWNTO 0 );
			DBI			: OUT	STD_LOGIC_VECTOR(  7 DOWNTO 0 );
			DBO			: IN	STD_LOGIC_VECTOR(  7 DOWNTO 0 );
			WAVE		: OUT	STD_LOGIC_VECTOR(  7 DOWNTO 0 )
		);
	END COMPONENT;

	-- PSG SIGNALS
	SIGNAL PSGDBI		: STD_LOGIC_VECTOR(  7 DOWNTO 0 );
	SIGNAL PSGREGPTR	: STD_LOGIC_VECTOR(  3 DOWNTO 0 );

	SIGNAL REGA			: STD_LOGIC_VECTOR(  7 DOWNTO 0 );
	SIGNAL REGB			: STD_LOGIC_VECTOR(  7 DOWNTO 0 );

BEGIN

	----------------------------------------------------------------
	-- PSG REGISTER READ
	----------------------------------------------------------------
	DBI <=	REGA	WHEN( PSGREGPTR = "1110" AND ADR(1 DOWNTO 0) = "10" )ELSE
			REGB	WHEN( PSGREGPTR = "1111" AND ADR(1 DOWNTO 0) = "10" )ELSE
			PSGDBI;

	----------------------------------------------------------------
	-- PSG REGISTER WRITE
	----------------------------------------------------------------
	PROCESS( RESET, CLK21M )
	BEGIN
		IF( RESET = '1' )THEN
			PSGREGPTR	<= (OTHERS => '0');
		ELSIF( CLK21M'EVENT AND CLK21M = '1' )THEN
			IF (REQ = '1' AND WRT = '1' AND ADR(1 DOWNTO 0) = "00") THEN
				-- REGISTER POINTER
				PSGREGPTR <= DBO(3 DOWNTO 0);
			END IF;
		END IF;
	END PROCESS;

	PROCESS( RESET, CLK21M )
	BEGIN
		IF( RESET = '1' )THEN
			REGA <= (OTHERS => '0');
		ELSIF( CLK21M'EVENT AND CLK21M = '1' )THEN
			-- PSG REGISTER #15 BIT6 - JOYSTICK SELECT : 0=PORTA, 1=PORTB
			IF( REGB(6) = '0' )THEN
				REGA(5 DOWNTO 0) <= JOYA;
			ELSE
				REGA(5 DOWNTO 0) <= JOYB;
			END IF;

			REGA(7) <= CMTIN;		-- CASSETE VOICE INPUT : ALWAYS '0' ON MSX TURBOR
			REGA(6) <= KEYMODE;		-- KEYBOARD MODE : 1=JIS
		END IF;
	END PROCESS;

	PROCESS( RESET, CLK21M )
	BEGIN
		IF( RESET = '1' )THEN
			REGB		<= (OTHERS => '0');
		ELSIF( CLK21M'EVENT AND CLK21M = '1' )THEN
			IF( REQ = '1' AND WRT = '1' AND ADR(1 DOWNTO 0) = "01" )THEN
				-- PSG REGISTERS
				IF( PSGREGPTR = "1111" )THEN
					REGB <= DBO;
				END IF;
			END IF;
		END IF;
	END PROCESS;

	PROCESS( CLK21M )
	BEGIN
		IF( CLK21M'EVENT AND CLK21M = '1' )THEN
			-- STROBE OUTPUT
			STRB <= REGB(5);
			STRA <= REGB(4);
		END IF;
	END PROCESS;

	PROCESS( RESET, CLK21M )
	BEGIN
		IF( RESET = '1' )THEN
			KANA <= '0';
		ELSIF( CLK21M'EVENT AND CLK21M = '1' )THEN
			IF( REGB(7) = '0' )THEN
				KANA <= '0'; -- KANA-LED : 0=ON, Z=OFF
			ELSE
				KANA <= '1'; -- KANA-LED : 0=ON, Z=OFF
			END IF;
		END IF;
	END PROCESS;

	PROCESS( RESET, CLK21M )
	BEGIN
		IF( RESET = '1' )THEN
			JOYA		<= (OTHERS => 'Z');
		ELSIF( CLK21M'EVENT AND CLK21M = '1' )THEN
			-- TRIGGER A/B OUTPUT JOYSTICK PORTA
			CASE REGB(1 DOWNTO 0) IS
				WHEN "00"	=> JOYA(5 DOWNTO 4) <= "00";
				WHEN "01"	=> JOYA(5 DOWNTO 4) <= "0Z";
				WHEN "10"	=> JOYA(5 DOWNTO 4) <= "Z0";
				WHEN OTHERS	=> JOYA(5 DOWNTO 4) <= "ZZ";
			END CASE;
		END IF;
	END PROCESS;

	PROCESS( RESET, CLK21M )
	BEGIN
		IF( RESET = '1' )THEN
			JOYB <= (OTHERS => 'Z');
		ELSIF( CLK21M'EVENT AND CLK21M = '1' )THEN
			-- TRIGGER A/B OUTPUT JOYSTICK PORTB
			CASE REGB( 3 DOWNTO 2 ) IS
				WHEN "00"	=> JOYB(5 DOWNTO 4) <= "00";
				WHEN "01"	=> JOYB(5 DOWNTO 4) <= "0Z";
				WHEN "10"	=> JOYB(5 DOWNTO 4) <= "Z0";
				WHEN OTHERS	=> JOYB(5 DOWNTO 4) <= "ZZ";
			END CASE;
		END IF;
	END PROCESS;

	----------------------------------------------------------------
	-- CONNECT COMPONENTS
	----------------------------------------------------------------
	U_PSGCH: PSG_WAVE
	PORT MAP(
		CLK21M		=> CLK21M	,
		RESET		=> RESET	,
		CLKENA		=> CLKENA	,
		REQ			=> REQ		,
		ACK			=> ACK		,
		WRT			=> WRT		,
		ADR			=> ADR		,
		DBI			=> PSGDBI	,
		DBO			=> DBO		,
		WAVE		=> WAVE		
	);

END RTL;
