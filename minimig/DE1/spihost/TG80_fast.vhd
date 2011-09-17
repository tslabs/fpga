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

-- neue Opcodes:
-- ED A5  LDA ;LD A,(CHL)
-- ED B5  STA ;LD (CHL),A
-- address(23 downto 16) auskommentieren

entity TG80_fast is
   port(data_in           : in std_logic_vector(7 downto 0);
        IO_in             : in std_logic_vector(7 downto 0);
        clk               : in std_logic;
        reset             : in std_logic;
        interrupt		  : in std_logic;
        clkena_in         : in std_logic;
		data_write        : out std_logic_vector(7 downto 0);
        address           : buffer std_logic_vector(23 downto 0);
		io_wr			  : buffer std_logic;
		io_rd			  : buffer std_logic;
   		int_ack           : buffer std_logic;
		mem_wr			  : buffer std_logic;
		mem_ce			  : buffer std_logic;
		
        opcode        	  : buffer std_logic_vector(7 downto 0);
		registerin        : buffer std_logic_vector(15 downto 0);
		microaddr         : buffer std_logic_vector(7 downto 0);
        prefix            : buffer std_logic_vector(3 downto 0);
        state        	  : buffer std_logic_vector(1 downto 0);
        fetchOPC          : buffer std_logic;
        decodeOPC         : buffer std_logic;
        o_wordread        : out std_logic;
        o_worddone        : out std_logic;
        o_wordreaddirect  : out std_logic;
        execOPC           : buffer std_logic;
		wr				  : out std_logic;
		o_Flags			  : out std_logic_vector(7 downto 0);
		memaddr           : buffer std_logic_vector(15 downto 0);
		clkena_o          : out std_logic;
		refresh           : out std_logic;
   		wrena	          : buffer std_logic;
		o_BC              : buffer std_logic_vector(15 downto 0);
		o_DE              : buffer std_logic_vector(15 downto 0);
		o_HL              : buffer std_logic_vector(15 downto 0);
		o_AF              : buffer std_logic_vector(15 downto 0);
		o_SP              : buffer std_logic_vector(15 downto 0);
		o_IX              : buffer std_logic_vector(15 downto 0);
		o_IY              : buffer std_logic_vector(15 downto 0);
		i_state		      :out std_logic_vector(10 downto 0)
        );
end TG80_fast;

architecture logic of TG80_fast is
--   signal io_wr	      : std_logic;
--   signal io_rd	      : std_logic;

    signal clkena	      : std_logic;
--    signal wrena	      : std_logic;
    signal TG80_PC         : std_logic_vector(15 downto 0);
    signal TG80_PC_add     : std_logic_vector(15 downto 0);
    signal lastaddr       : std_logic_vector(15 downto 0);
--    signal memaddr        : std_logic_vector(31 downto 0);
    signal memaddr_in     : std_logic_vector(15 downto 0);
    signal data_write_tmp : std_logic_vector(15 downto 0);
    signal PC_dataa, PC_datab, PC_result  : std_logic_vector(15 downto 0);
    signal datatype       : std_logic;			--0 Byte  1 Word
    signal wordread	      : std_logic;
    signal wordreaddirect : std_logic;
    signal worddone	      : std_logic;
--    signal prefix	        : std_logic;
    signal presub	      : std_logic;
    signal ERegpresub	  : std_logic;
    signal addsub_a       : std_logic_vector(15 downto 0);
    signal addsub_b       : std_logic_vector(15 downto 0);
    signal addsub_q       : std_logic_vector(15 downto 0);
    signal addsub	      : std_logic;
    signal c_in	          : std_logic_vector(3 downto 0);
    signal c_out	      : std_logic_vector(2 downto 0);
    signal addsub_ofl     : std_logic_vector(2 downto 0);

    signal last_datain    : std_logic_vector(15 downto 0);
    signal data_read      : std_logic_vector(15 downto 0);
--    signal microaddr      : std_logic_vector(7 downto 0);
    signal microstep	  : std_logic;

--    signal registerin          : std_logic_vector(31 downto 0);
    signal Regwrena	      : std_logic;
--    signal opcode			: std_logic_vector(15 downto 0);
--    signal state			: std_logic_vector(1 downto 0);
    signal laststate	  : std_logic_vector(1 downto 0);
    signal setstate	      : std_logic_vector(1 downto 0);

    signal memaddr_a      : std_logic_vector(15 downto 0);
    signal memaddr_b      : std_logic_vector(15 downto 0);
	signal TG80_PC_br8     : std_logic;
	signal set_store_in_tmp    : std_logic;
	signal store_in_tmp   : std_logic;
	signal write_back     : std_logic;
	signal writePC_add    : std_logic;
	signal directPC       : std_logic;
	signal set_directPC   : std_logic;
--	signal execOPC          : std_logic;
	signal exec_DIRECT    : std_logic;
	signal exec_write_back  : std_logic;
	signal set_exec_MOVE  : std_logic;

    signal bit_bits       : std_logic_vector(1 downto 0);
    signal bit_number_reg : std_logic_vector(4 downto 0);
    signal bit_number     : std_logic_vector(4 downto 0);
    signal bits_out       : std_logic_vector(7 downto 0);
    signal one_bit_in	  : std_logic;
    signal one_bit_out	  : std_logic;

    signal dummy_a		  : std_logic_vector(8 downto 0);
    signal niba_l		  : std_logic_vector(5 downto 0);
    signal niba_h		  : std_logic_vector(5 downto 0);
    signal niba_lc		  : std_logic;
    signal niba_hc		  : std_logic;
    signal bcda_lc		  : std_logic;
    signal bcda_hc		  : std_logic;

    signal dummy_s		  : std_logic_vector(8 downto 0);
    signal nibs_l		  : std_logic_vector(5 downto 0);
    signal nibs_h		  : std_logic_vector(5 downto 0);
    signal nibs_lc		  : std_logic;
    signal nibs_hc		  : std_logic;
    signal pre_V_Flag	  : std_logic;
    signal SP_incdec  	  : std_logic;
    signal HL_incdec  	  : std_logic;
    signal DE_incdec  	  : std_logic;
    signal BC_inc  	      : std_logic;
    signal BC_dec  	      : std_logic;
    signal SP_to_memaddr  : std_logic;
    signal data_read_to_SP     : std_logic;
    signal HL_to_SP	      : std_logic;
    signal write_direkt	  : std_logic;
    signal set_write_direkt    : std_logic;
    signal arith_A	      : std_logic;
    signal arith_AF	      : std_logic_vector(7 downto 0);
    signal arith_AP	      : std_logic;
    signal arith_AV	      : std_logic;
    signal arith_AH	      : std_logic;
    signal arith_HL	      : std_logic;
    signal arith_HLF	  : std_logic_vector(7 downto 0);
    signal arith_HLV	  : std_logic;
    signal arith_HLH	  : std_logic;
    signal arith_HLZ	  : std_logic;
    signal Reg_A_in	      : std_logic_vector(9 downto 0);
    signal Reg_HL_in	  : std_logic_vector(17 downto 0);
    signal con1	          : std_logic;
    signal con2	          : std_logic;
    signal exdehl	      : std_logic;
    signal exx	          : std_logic;
    signal exaf	          : std_logic;
    signal dec_B	      : std_logic;
    signal HL_to_PC	      : std_logic;
    signal rst	          : std_logic;
    signal set_nn_to_mem  : std_logic;
    signal nn_to_mem	  : std_logic;
    signal An_to_mem	  : std_logic;
    signal use_A	      : std_logic;
    signal incdecOP	      : std_logic;
    signal EReg_a	      : std_logic_vector(7 downto 0);
    signal rotout	      : std_logic_vector(7 downto 0);
    signal rotcout	      : std_logic;
    signal rot_AOP	      : std_logic;
    signal rot_OP	      : std_logic;
    signal rot_FP	      : std_logic;
    signal rot_F		  : std_logic_vector(7 downto 0);
    signal registerin_F	  : std_logic_vector(7 downto 0);
    signal registerin_FV  : std_logic;
    signal registerin_FP  : std_logic;
    signal registerin_FH  : std_logic;
    signal daa_b	      : std_logic_vector(7 downto 0);
    signal daa_q	      : std_logic_vector(8 downto 0);
    signal i_daa	      : std_logic;
    signal i_scf	      : std_logic;
    signal i_ccf	      : std_logic;
    signal i_cpl	      : std_logic;
    signal i_di	          : std_logic;
    signal i_ei	          : std_logic;
--    signal int_ack        : std_logic;
    signal int_IFF        : std_logic_vector(1 downto 0);
    signal dirio          : std_logic;
    signal set_dirio      : std_logic;
    signal set_prefix     : std_logic_vector(3 downto 0);
    signal HL_to_memaddr  : std_logic;
    signal DE_to_memaddr  : std_logic;
    signal BC_to_memaddr  : std_logic;
    signal Reg_BCZ 	      : std_logic;
    signal Reg_BZ 	      : std_logic;
    signal block_loop	  : std_logic;
    signal block_OP	      : std_logic;
    signal bitmask	      : std_logic_vector(7 downto 0);
    signal cpi_q	      : std_logic_vector(7 downto 0);
    signal cpi_hq	      : std_logic_vector(7 downto 0);
    signal ldi_q	      : std_logic_vector(7 downto 0);
    signal cpi_z	      : std_logic;
    signal daa_F	      : std_logic_vector(7 downto 0);
    signal wrixy	      : std_logic_vector(1 downto 0);
    signal ixye	          : std_logic;
    signal set_halt	      : std_logic;
    signal halt	          : std_logic;
    signal i_ldia	      : std_logic;
    signal i_ldra	      : std_logic;
    signal i_ldai	      : std_logic;
    signal i_ldar	      : std_logic;
    signal i_IM	          : std_logic;
    signal i_in	          : std_logic;
    signal wait_three	  : std_logic;
    signal wait_four	  : std_logic;
    signal wait_five	  : std_logic;
    signal wait_seven	  : std_logic;
    signal wait_jr	      : std_logic;
    signal exsp	          : std_logic;

    signal 	regsource, regdest, wraddr	: std_logic_vector(4 downto 0);
    signal 	reg_datain	  : std_logic_vector(15 downto 0);
    signal 	exde          : std_logic;
    signal Reg_SP         : std_logic_vector(15 downto 0);
    signal Reg_SP_a       : std_logic_vector(15 downto 0);
    signal Reg_HL_a       : std_logic_vector(15 downto 0);
    signal Reg_DE_a       : std_logic_vector(15 downto 0);
    signal Reg_BC_a       : std_logic_vector(15 downto 0);
    signal Reg_HL         : std_logic_vector(15 downto 0);
    signal Reg_DE         : std_logic_vector(15 downto 0);
    signal Reg_BC         : std_logic_vector(15 downto 0);
    signal Reg_A          : std_logic_vector(7 downto 0);
    signal Reg_F          : std_logic_vector(7 downto 0);
    signal RegEx_HL       : std_logic_vector(15 downto 0);
    signal RegEx_DE       : std_logic_vector(15 downto 0);
    signal RegEx_BC       : std_logic_vector(15 downto 0);
    signal RegEx_A        : std_logic_vector(7 downto 0);
    signal RegEx_F        : std_logic_vector(7 downto 0);
    signal Reg_IX         : std_logic_vector(15 downto 0);
    signal Reg_IY         : std_logic_vector(15 downto 0);
    signal Reg_HLXY       : std_logic_vector(15 downto 0);
    signal Reg_I          : std_logic_vector(7 downto 0);
    signal Reg_R          : std_logic_vector(7 downto 0);
    signal DReg_out       : std_logic_vector(15 downto 0);
    signal ERegl_out      : std_logic_vector(7 downto 0);
    signal ERegh_out      : std_logic_vector(7 downto 0);
    signal set_ext_mem    : std_logic;
    signal ext_mem        : std_logic;

--    signal IMode        	: std_logic_vector(1 downto 0);

begin 
		i_state(9 downto 0) <= wait_seven & (ixye OR wait_five OR wait_jr OR TG80_PC_br8) & wait_four & wait_three & int_ack & fetchOPC & decodeOPC & dirio & state;
--		io_wr_o <= io_wr OR NOT clkena_in;
--		io_rd_o <= io_rd OR NOT clkena_in;
 
        o_wordread <= wordread;
        o_worddone <= worddone;
        o_wordreaddirect <= wordreaddirect;
		clkena_o <=clkena;
		o_BC <= Reg_BC;
		o_DE <= Reg_DE;
		o_HL <= Reg_HL;
		o_AF <= Reg_A&Reg_F;
		o_SP <= Reg_SP;
		o_IX <= Reg_IX;
		o_IY <= Reg_IY;
		o_Flags <= Reg_F;
		wrena <= regwrena;
		
	address(23 downto 16) <= "01000000" when ext_mem='0' ELSE Reg_BC(7 downto 0);	
	address(15 downto 0) <= last_datain(7 downto 0)&last_datain(15 downto 8) WHEN nn_to_mem='1' ELSE 
--			   Reg_A&last_datain(7 downto 0) WHEN An_to_mem='1' ELSE TG80_PC when state="00" ELSE Reg_I&Reg_R WHEN decodeOPC='1' ELSE memaddr;
			   Reg_A&last_datain(7 downto 0) WHEN An_to_mem='1' ELSE TG80_PC when state="00" ELSE lastaddr when state="01" AND decodeOPC='0' ELSE memaddr;
--	address <= TG80_PC when state="00" else memaddr;
	wr <= '0' WHEN state="11" ELSE '1';
	refresh <= '0' WHEN state="01" ELSE '1';
-----------------------------------------------------------------------------
-- MEM_IO 
-----------------------------------------------------------------------------
PROCESS (clk, reset, clkena_in, wordread, memaddr_a, memaddr_b, fetchOPC, Reg_I, Reg_R, SP_to_memaddr, Reg_HL,
         DE_to_memaddr, Reg_DE, BC_to_memaddr, Reg_BC, decodeOPC, opcode, prefix, DReg_out, Reg_HLXY, Reg_SP,
         HL_to_memaddr, last_datain, nn_to_mem, memaddr, presub, state, ixye, datatype, write_direkt, worddone,
         data_write_tmp)
	BEGIN
		clkena <= clkena_in AND NOT wordread;
		
		memaddr_a(1 downto 0) <= "00";
		memaddr_a(7 downto 2) <= (OTHERS=>memaddr_a(1));
		memaddr_a(15 downto 8) <= (OTHERS=>memaddr_a(7));
		IF fetchOPC='1' THEN
			memaddr_b <= Reg_I&Reg_R;
		ELSIF SP_to_memaddr='1' THEN
 			memaddr_b <= Reg_SP;
		ELSIF HL_to_memaddr='1' THEN
 			memaddr_b <= Reg_HL;
		ELSIF DE_to_memaddr='1' THEN
 			memaddr_b <= Reg_DE;
		ELSIF BC_to_memaddr='1' THEN
 			memaddr_b <= Reg_BC;
		ELSIF decodeOPC='1' THEN
			IF opcode(7 downto 5)="000" AND prefix(0)='0' THEN
				memaddr_b <= DReg_out;
			ELSE
				memaddr_b <= Reg_HLXY;
			END IF;	
		ELSIF nn_to_mem='1' THEN
			memaddr_b <= last_datain(7 downto 0)&last_datain(15 downto 8);
--		ELSIF setstate="01" THEN	
--			memaddr_b <= address;	--nur der schönheit wegen
		ELSE
			memaddr_b <= memaddr;
		END IF;
		
		IF presub='1' AND fetchOPC='0' THEN
			memaddr_a(1 downto 0) <= "11";
		ELSIF state(1)='1' AND wordread='1' THEN
			memaddr_a(0) <= '1';
		ELSIF ixye='1' THEN
			memaddr_a(7 downto 0) <= last_datain(7 downto 0);
		END IF;	 
		memaddr_in <= memaddr_b+memaddr_a;
		
		data_read(15 downto 8) <= last_datain(7 downto 0);
		IF datatype='1' THEN
			data_read(7 downto 0) <= last_datain(15 downto 8);
		ELSE
			data_read(7 downto 0) <= last_datain(7 downto 0);
		END IF;	
		
		IF write_direkt='1' THEN
			data_write <= last_datain(7 downto 0);
		ELSIF worddone='1' THEN
			data_write <= data_write_tmp(15 downto 8);
		ELSE	
			data_write <= data_write_tmp(7 downto 0);
		END IF;	
		
		IF reset='0' THEN
			wordread <= '0';
			worddone <= '0';
			lastaddr <= (others => '0');
			ext_mem <= '0';
		ELSIF rising_edge(clk) THEN
        	IF clkena='1' THEN
				lastaddr <= address(15 downto 0);	--nur für die schönheit
				ext_mem <= set_ext_mem;
 			END IF;
       		IF clkena_in='1' THEN
				write_direkt <= set_write_direkt;
				worddone <= wordread;
				memaddr <= memaddr_in;
				IF state(0)='0' THEN
					last_datain(15 downto 8) <= last_datain(7 downto 0);
					IF io_rd='0' THEN
						last_datain(7 downto 0) <= IO_in;
					ELSE
						last_datain(7 downto 0) <= data_in;
					END IF;
				END IF;
				
				IF ((setstate(1)='1' AND datatype='1') OR wordreaddirect='1') AND wordread='0' THEN
					wordread <= '1';
				ELSE	
					wordread <= '0';
				END IF;	
				
			END IF;
		END IF;
    END PROCESS;

-----------------------------------------------------------------------------
-- PC Calc + fetch opcode
-----------------------------------------------------------------------------
process (clk, reset, TG80_PC_br8, PC_datab, last_datain, rst, int_ack, halt, block_loop, TG80_PC)
	begin
		PC_datab(1 downto 0) <= "01";
		PC_datab(7 downto 2) <= (others => PC_datab(1));
		PC_datab(15 downto 8) <= (others => PC_datab(7));
		IF TG80_PC_br8='1' THEN
			PC_datab(7 downto 0) <= last_datain(7 downto 0);
		ELSIF rst='1' OR int_ACK='1' OR halt='1' THEN
			PC_datab(0) <= '0';
		ELSIF block_loop='1' THEN
			PC_datab(1 downto 0) <= "10";
		END IF;
		TG80_PC_add <= TG80_PC+PC_datab;
		
      	IF reset = '0' THEN
			opcode <= (others =>'0');
			TG80_PC <= (others =>'0');
			state <= "01";
			dirio <= '0';
 			fetchOPC <= '0';
			execOPC <= '0';
			directPC <= '0';
			int_IFF <= "00";
			int_ACK <= '0';
			io_wr <= '1';
			io_rd <= '1';
			mem_wr <= '1';
			mem_ce <= '0';
	  	ELSIF rising_edge(clk) THEN
        	IF clkena_in='1' THEN
				IF directPC='1' AND clkena='1' THEN
					TG80_PC <= data_in & last_datain(7 downto 0);
				ELSIF HL_to_PC='1' THEN	
					TG80_PC <= Reg_HLXY;
				ELSIF rst='1' THEN	
					TG80_PC <= "0000000000"&opcode(5 downto 3)&"000";
				ELSIF state ="00" OR TG80_PC_br8='1' OR block_loop='1' THEN				
					TG80_PC <= TG80_PC_add;
				END IF;	
			END IF;	
			
        	IF clkena='1' THEN
				io_wr <= '1';
				io_rd <= '1';
				mem_wr <= '1';
				mem_ce <= '0';
				IF fetchOPC='1' OR (state="10" AND write_back='1' AND setstate/="10") THEN
					state <= "01";		--decode cycle, execute cycle
					dirio <= '0';
				ELSE
					state <= setstate;
					dirio <= set_dirio;
					IF setstate(1)='1' AND set_dirio='1' THEN
						io_wr <= NOT setstate(0);
						io_rd <= setstate(0);
						mem_ce <= '1';
					END IF;
					IF setstate="11" AND set_dirio='0' THEN
						mem_wr <= '0';
					END IF;
				END IF;
			END IF;	
			
        	IF clkena='1' THEN
				fetchOPC <= '0';
				execOPC <= '0';
				directPC <= set_directPC;
				
				IF decodeOPC='1' THEN
					halt <= set_halt;
				END IF;
				IF execOPC='1' THEN
	--halt verlassen noch korrigieren			
--					halt <= set_halt;
					IF i_EI='1' THEN
						int_IFF <= "11";
					END IF;
					IF i_DI='1' THEN
						int_IFF <= "00";
					END IF;
				END IF;
				IF microstep='0' AND setstate="00" AND fetchOPC='0' THEN
					IF state/="10" OR write_back='0' THEN
						fetchOPC <= '1';
						IF ((int_IFF(1) AND NOT interrupt AND NOT i_DI)='1') AND set_prefix="0000" THEN
							int_ACK <= '1';
	--IM-Mode noch einbauen						
							int_IFF <= "00";
						ELSE
							int_ACK <= '0';
						END IF;	
					END IF;
					IF exec_write_back='0' THEN
						execOPC <= '1';
					END IF;
				END IF;
				IF fetchOPC='1' OR (ixye='1' AND prefix(0)='1') THEN
					IF int_ACK='1' THEN
						opcode <= X"FF";
					ELSE 	
						IF halt='0' THEN
							opcode <= data_in;
						END IF;
					END IF;
				END IF;
        	end if;
      	end if;
   end process;

-----------------------------------------------------------------------------
-- Reg_IR
-----------------------------------------------------------------------------
PROCESS (clk, clkena, reset)
	BEGIN
      	IF reset = '0' THEN
--			IMode <= "00";	
			Reg_R <= X"00";	
			Reg_I <= X"00";	
	  	ELSIF rising_edge(clk) THEN
			IF clkena='1'  THEN
				IF decodeOPC='1' THEN
					IF i_ldra='1' THEN
						Reg_R <= Reg_A;	
					ELSE
						Reg_R(6 downto 0) <= Reg_R(6 downto 0)+1;
					END IF;
				END IF;
				IF i_ldia='1' THEN
					Reg_I <= Reg_A;	
				END IF;
--				IF i_IM='1' THEN
--					IMode <= opcode(4 downto 3);	
--				END IF;
			END IF;	
		END IF;	
	END PROCESS;
-----------------------------------------------------------------------------
-- Reg_HLXY
-----------------------------------------------------------------------------
PROCESS (IXYe, wrixy, Reg_HLXY, Reg_IX, Reg_IY, Reg_HL)
	BEGIN
		CASE IXYe&wrixy IS
			WHEN "010" => Reg_HLXY <= Reg_IX;
			WHEN "011" => Reg_HLXY <= Reg_IY;
			WHEN OTHERS => Reg_HLXY <= Reg_HL;
		END CASE;	
	END PROCESS;
-----------------------------------------------------------------------------
-- DReg_out
-----------------------------------------------------------------------------
PROCESS (opcode, DReg_out, Reg_BC, Reg_DE, Reg_HLXY, Reg_A, Reg_F, Reg_SP)
	BEGIN
		CASE opcode(5 downto 4) IS
			WHEN "00" => DReg_out <= Reg_BC;
			WHEN "01" => DReg_out <= Reg_DE;
			WHEN "10" => DReg_out <= Reg_HLXY;
			WHEN "11" => 
				IF opcode(7)='1' THEN
					DReg_out <= Reg_A&Reg_F;
				ELSE
					DReg_out <= Reg_SP;
				END IF;
		END CASE;	
	END PROCESS;
-----------------------------------------------------------------------------
-- ERegl_out
-----------------------------------------------------------------------------
PROCESS (prefix, last_datain, opcode, ERegl_out, Reg_BC, Reg_DE, Reg_HLXY, Reg_A)
	BEGIN
		IF prefix(3)='1' AND prefix(1 downto 0)="01" THEN	--Illegale DD/FD CB Opcodes
			ERegl_out <= last_datain(7 downto 0);
		ELSE
			CASE opcode(2 downto 0) IS
				WHEN "000" => 	ERegl_out <= Reg_BC(15 downto 8);
				WHEN "001" => 	ERegl_out <= Reg_BC(7 downto 0);
				WHEN "010" => 	ERegl_out <= Reg_DE(15 downto 8);
				WHEN "011" => 	ERegl_out <= Reg_DE(7 downto 0);
				WHEN "100" => 	ERegl_out <= Reg_HLXY(15 downto 8);
				WHEN "101" => 	ERegl_out <= Reg_HLXY(7 downto 0);
				WHEN "110" =>  	ERegl_out <= last_datain(7 downto 0); 
				WHEN "111" => 	ERegl_out <= Reg_A; 
			END CASE;
		END IF;	
	END PROCESS;
-----------------------------------------------------------------------------
-- ERegh_out
-----------------------------------------------------------------------------
PROCESS (decodeOPC, last_datain, opcode, ERegh_out, Reg_BC, Reg_DE, Reg_HLXY, Reg_A)
	BEGIN
		CASE opcode(5 downto 3) IS
			WHEN "000" => 	ERegh_out(7 downto 0) <= Reg_BC(15 downto 8);
			WHEN "001" => 	ERegh_out(7 downto 0) <= Reg_BC(7 downto 0);
			WHEN "010" => 	ERegh_out(7 downto 0) <= Reg_DE(15 downto 8);
			WHEN "011" => 	ERegh_out(7 downto 0) <= Reg_DE(7 downto 0);
			WHEN "100" => 	ERegh_out(7 downto 0) <= Reg_HLXY(15 downto 8);
			WHEN "101" => 	ERegh_out(7 downto 0) <= Reg_HLXY(7 downto 0);
			WHEN "110" =>  	IF decodeOPC='1' THEN
								ERegh_out(7 downto 0) <= X"00"; 	--ED 71
--								ERegh_out(7 downto 0) <= X"FF"; 	--ED 71 für z84c0010
							ELSE
								ERegh_out(7 downto 0) <= last_datain(7 downto 0); 
							END IF;
			WHEN "111" => 	ERegh_out(7 downto 0) <= Reg_A; 
		END CASE;	
	END PROCESS;
-----------------------------------------------------------------------------
-- registerin
-----------------------------------------------------------------------------
PROCESS (last_datain, registerin, ERegh_out, registerin_FH, ERegpresub, Reg_F, incdecOP, EReg_a,
	     registerin_FV, set_store_in_tmp, data_read, registerin_FP, datatype, DReg_out, ERegl_out)
	BEGIN
		registerin_F <= registerin(7)&'0'&registerin(5)&registerin_FH&registerin(3)&'0'&ERegpresub&Reg_F(0);	
		registerin_FV <= (NOT ERegpresub XOR ERegh_out(7)) AND (ERegh_out(7) XOR registerin(7));	--V 
		registerin_FP <= ((NOT last_datain(7) XOR last_datain(6)) XOR (last_datain(5) XOR last_datain(4))) XOR ((last_datain(3) XOR last_datain(2)) XOR (last_datain(1) XOR last_datain(0)));	--P 	
		registerin_FH <= ERegpresub XOR ERegh_out(4) XOR registerin(4) XOR ERegpresub;	--H
 		IF registerin(7 downto 0)=X"00" THEN
			registerin_F(6) <= '1';		--Z
		END IF;	
		
		EReg_a(7 downto 1) <= (OTHERS=>ERegpresub);
		EReg_a(0) <= '1'; 
		registerin(15 downto 8) <= "XXXXXXXX";
		IF incdecOP='1' THEN	
			registerin(7 downto 0) <= ERegh_out + EReg_a;
			registerin_F(2) <= registerin_FV;			--INC/DEC EReg
		ELSIF set_store_in_tmp='1' THEN
			registerin <= data_read;
			registerin_F(2) <= registerin_FP;			--IN Reg,(C)
		ELSIF datatype='1' THEN		
			registerin <= DReg_out;
		ELSE	
			registerin(7 downto 0) <= ERegl_out;
		END IF;
	END PROCESS;
-----------------------------------------------------------------------------
-- Reg_BC
-----------------------------------------------------------------------------
PROCESS (clk, BC_dec, Reg_BC)
	BEGIN
		Reg_BC_a(15 downto 1) <= (OTHERS=>BC_dec);
		Reg_BC_a(0) <= '1';
		Reg_BZ <= '0';
		Reg_BCZ <= '0';	
		IF Reg_BC(15 downto 8)=X"00" THEN
			Reg_BZ <= '1';
			IF Reg_BC(7 downto 0)=X"00" THEN
				Reg_BCZ <= '1';	
			END IF;
		END IF;
		IF rising_edge(clk) THEN
			IF clkena='1'  THEN
				IF dec_B='1' THEN
					Reg_BC(15 downto 8) <= Reg_BC(15 downto 8)-1; 
				ELSIF (BC_inc OR BC_dec)='1' THEN
					Reg_BC <= Reg_BC+Reg_BC_a;
				ELSIF execOPC='1' THEN
					IF exx='1' THEN
						Reg_BC <= RegEx_BC;
						RegEx_BC <= Reg_BC;
					END IF;
					IF regwrena='1' THEN
						IF opcode(5 downto 4)="00" AND rot_OP='0' THEN
							IF datatype='1' THEN
								Reg_BC(15 downto 8) <= registerin(15 downto 8);		--B
							ELSIF opcode(3)='0' THEN
								Reg_BC(15 downto 8) <= registerin(7 downto 0);		--B
							END IF;
							IF datatype='1' OR opcode(3)='1' THEN
								Reg_BC(7 downto 0) <= registerin(7 downto 0);		--C
							END IF;
						END IF;	
						IF opcode(2 downto 1)="00" AND rot_OP='1' THEN
							IF opcode(0)='0' THEN
								Reg_BC(15 downto 8) <= rotout;		--B
							END IF;
							IF opcode(0)='1' THEN
								Reg_BC(7 downto 0) <= rotout;		--C
							END IF;
						END IF;	
					END IF;	
				END IF;	
			END IF;	
		END IF;	
	END PROCESS;
-----------------------------------------------------------------------------
-- Reg_DE
-----------------------------------------------------------------------------
PROCESS (clk, presub)
	BEGIN
		Reg_DE_a(15 downto 1) <= (OTHERS=>presub);
		Reg_DE_a(0) <= '1';
		IF rising_edge(clk) THEN
			IF clkena='1'  THEN
				IF execOPC='1' THEN
					IF exdehl='1' THEN
						Reg_DE <= Reg_HL;
					ELSIF exx='1' THEN
						Reg_DE <= RegEx_DE;
						RegEx_DE <= Reg_DE;
					ELSIF DE_incdec='1' THEN
						Reg_DE <= Reg_DE+Reg_DE_a;
					END IF;
					IF regwrena='1' THEN
						IF opcode(5 downto 4)="01" AND rot_OP='0' THEN
							IF datatype='1' THEN
								Reg_DE(15 downto 8) <= registerin(15 downto 8);		--D
							ELSIF opcode(3)='0' THEN
								Reg_DE(15 downto 8) <= registerin(7 downto 0);		--D
							END IF;
							IF datatype='1' OR opcode(3)='1' THEN
								Reg_DE(7 downto 0) <= registerin(7 downto 0);		--E
							END IF;
						END IF;	
						IF opcode(2 downto 1)="01" AND rot_OP='1' THEN
							IF opcode(0)='0' THEN
								Reg_DE(15 downto 8) <= rotout;		--D
							END IF;
							IF opcode(0)='1' THEN
								Reg_DE(7 downto 0) <= rotout;		--E
							END IF;
						END IF;	
					END IF;	
				END IF;	
			END IF;	
		END IF;	
	END PROCESS;
-----------------------------------------------------------------------------
-- Reg_HL
-----------------------------------------------------------------------------
PROCESS (clk, presub)
	BEGIN
		Reg_HL_a(15 downto 1) <= (OTHERS=>presub);
		Reg_HL_a(0) <= '1';
		IF rising_edge(clk) THEN
			IF clkena='1'  THEN
				IF execOPC='1' THEN
					IF exdehl='1' THEN
						Reg_HL <= Reg_DE;
					ELSIF exx='1' THEN
						Reg_HL <= RegEx_HL;
						RegEx_HL <= Reg_HL;
					ELSIF HL_incdec='1' AND wrixy(1)='0' THEN
						Reg_HL <= Reg_HL+Reg_HL_a;
					ELSIF arith_HL='1' AND wrixy(1)='0' THEN
						Reg_HL <= Reg_HL_in(16 downto 1);	
					END IF;	
					IF regwrena='1' AND wrixy(1)='0' THEN
						IF opcode(5 downto 4)="10" AND rot_OP='0' THEN
							IF datatype='1' THEN
								Reg_HL(15 downto 8) <= registerin(15 downto 8);		--H
							ELSIF opcode(3)='0' THEN
								Reg_HL(15 downto 8) <= registerin(7 downto 0);		--H
							END IF;
							IF datatype='1' OR opcode(3)='1' THEN
								Reg_HL(7 downto 0) <= registerin(7 downto 0);		--L
							END IF;
						END IF;	
						IF opcode(2 downto 1)="10" AND rot_OP='1' THEN
							IF opcode(0)='0' THEN
								Reg_HL(15 downto 8) <= rotout;		--H
							END IF;
							IF opcode(0)='1' THEN
								Reg_HL(7 downto 0) <= rotout;		--L
							END IF;
						END IF;	
					END IF;	
				END IF;	
			END IF;	
		END IF;	
	END PROCESS;
-----------------------------------------------------------------------------
-- Reg_IX
-----------------------------------------------------------------------------
PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF clkena='1'  THEN
				IF execOPC='1' AND wrixy="10" THEN
					IF HL_incdec='1' THEN
						Reg_IX <= Reg_IX+Reg_HL_a;
					ELSIF arith_HL='1' THEN
						Reg_IX <= Reg_HL_in(16 downto 1);	
					END IF;	
					IF regwrena='1' THEN
						IF opcode(5 downto 4)="10" THEN
							IF datatype='1' THEN
								Reg_IX(15 downto 8) <= registerin(15 downto 8);		--IXH
							ELSIF opcode(3)='0' THEN
								Reg_IX(15 downto 8) <= registerin(7 downto 0);		--IXH
							END IF;
							IF datatype='1' OR opcode(3)='1' THEN
								Reg_IX(7 downto 0) <= registerin(7 downto 0);		--IXL
							END IF;
						END IF;	
					END IF;	
				END IF;	
			END IF;	
		END IF;	
	END PROCESS;
-----------------------------------------------------------------------------
-- Reg_IY
-----------------------------------------------------------------------------
PROCESS (clk)
	BEGIN
		IF rising_edge(clk) THEN
			IF clkena='1'  THEN
				IF execOPC='1' AND wrixy="11" THEN
					IF HL_incdec='1' THEN
						Reg_IY <= Reg_IY+Reg_HL_a;
					ELSIF arith_HL='1' THEN
						Reg_IY <= Reg_HL_in(16 downto 1);	
					END IF;	
					IF regwrena='1' THEN
						IF opcode(5 downto 4)="10" THEN
							IF datatype='1' THEN
								Reg_IY(15 downto 8) <= registerin(15 downto 8);		--IYH
							ELSIF opcode(3)='0' THEN
								Reg_IY(15 downto 8) <= registerin(7 downto 0);		--IYH
							END IF;
							IF datatype='1' OR opcode(3)='1' THEN
								Reg_IY(7 downto 0) <= registerin(7 downto 0);		--IYL
							END IF;
						END IF;	
					END IF;	
				END IF;	
			END IF;	
		END IF;	
	END PROCESS;
-----------------------------------------------------------------------------
-- Reg_AF
-----------------------------------------------------------------------------
PROCESS (clk, Reg_F, Reg_A, daa_b, last_datain, cpi_q)
	BEGIN
-----------------------	
		daa_b <= "00000000";
		IF Reg_F(4)='1' OR (Reg_A(3) AND (Reg_A(2) OR Reg_A(1)))='1' THEN
			daa_b(2 downto 1) <= "11";
		END IF;
		IF Reg_F(0)='1' OR (Reg_A(7) AND (Reg_A(6) OR Reg_A(5) OR (Reg_A(4) AND Reg_A(3) AND (Reg_A(2) OR Reg_A(1)))))='1' THEN
			daa_b(6 downto 5) <= "11";
		END IF;
		IF Reg_F(1)='1' THEN		--SUB
			daa_q <= daa_b(6)&(Reg_A - daa_b);
		ELSE						--ADD
			daa_q <= ('0'&Reg_A(7 downto 0)) + ('0'&daa_b);
		END IF;
-----------------------
		cpi_q <= Reg_A-last_datain(7 downto 0);
		cpi_hq <= (Reg_A(6 downto 0)&'0')-(last_datain(6 downto 0)&(cpi_q(4) XOR Reg_A(4) XOR last_datain(4)));
		ldi_q <= Reg_A+last_datain(7 downto 0);
		IF cpi_q=X"00" THEN
			cpi_z <= '1';
		ELSE
			cpi_z <= '0';
		END IF;	

		IF rising_edge(clk) THEN
			IF clkena='1'  THEN
				IF execOPC='1' THEN
					IF i_daa='1' THEN
						Reg_A <= (daa_q(7 downto 0));
						Reg_F(7) <= daa_q(7); 				--S
						Reg_F(5) <= daa_q(5); 				--Y
						Reg_F(4) <= daa_q(4) XOR Reg_A(4); 				--H
						Reg_F(3) <= daa_q(3); 				--X
						Reg_F(2) <= ((NOT daa_q(7) XOR daa_q(6)) XOR (daa_q(5) XOR daa_q(4))) XOR ((daa_q(3) XOR daa_q(2)) XOR (daa_q(1) XOR daa_q(0)));	--P
						Reg_F(0) <= Reg_F(0) OR daa_q(8);	--C 
						IF daa_q(7 downto 0)="00000000" THEN
							Reg_F(6) <= '1'; 				--Z=1
						ELSE
							Reg_F(6) <= '0'; 				--Z=0
						END IF;
					END IF;
--					IF arith_A='1' AND execOPC='1' AND opcode(5 downto 3)/="111" THEN
					IF arith_A='1' AND opcode(5 downto 3)/="111" THEN	--"111"=CMP
						Reg_A <= Reg_A_in(8 downto 1);
					END IF;
					IF use_A='1' THEN
						Reg_A <= last_datain(7 downto 0);	
					END IF;
					IF i_ldai='1' THEN
						Reg_A <= Reg_I;	
						IF Reg_I="00000000" THEN
							Reg_F(6) <= '1'; 				--Z=1
						ELSE
							Reg_F(6) <= '0'; 				--Z=0
						END IF;
						Reg_F(7) <= Reg_I(7); 				--S
						Reg_F(1) <= '0';					--N
						Reg_F(2) <= int_IFF(0);				--V
						Reg_F(4) <= '0';					--H
					END IF;
					IF i_ldar='1' THEN
						Reg_A <= Reg_R;	
						IF Reg_R="00000000" THEN
							Reg_F(6) <= '1'; 				--Z=1
						ELSE
							Reg_F(6) <= '0'; 				--Z=0
						END IF;
						Reg_F(7) <= Reg_R(7); 				--S
						Reg_F(1) <= '0';					--N
						Reg_F(2) <= int_IFF(0);				--V
						Reg_F(4) <= '0';					--H
					END IF;
					IF exaf='1' THEN
						Reg_A <= RegEx_A;	
						RegEx_A <= Reg_A;	
						Reg_F <= RegEx_F;	
						RegEx_F <= Reg_F;	
					END IF;
					IF rot_AOP='1' THEN
--						Reg_A <= rotout; 
						Reg_F(0) <= rotcout;
						Reg_F(1) <= '0';	--N
						Reg_F(4) <= '0';	--H
						Reg_F(5) <= rotout(5);
						Reg_F(3) <= rotout(3);
					END IF;
					IF rot_OP='1' THEN
						Reg_F <= rot_F;
					END IF;	
					IF i_in='1' THEN	
						Reg_F(7 downto 5) <= registerin_F(7 downto 5);
						Reg_F(4) <= '0';
						Reg_F(3 downto 0) <= registerin_F(3 downto 0);
					END IF;	
					IF incdecOP='1'THEN	
						Reg_F <= registerin_F;
					END IF;	
					IF arith_A='1' THEN	
						Reg_F <= arith_AF;			--Flags
					END IF;	
					IF arith_HL='1' THEN	
						Reg_F <= arith_HLF;			--Flags
					END IF;
					IF i_cpl='1' THEN
						Reg_A <= NOT Reg_A;
						Reg_F(1) <= '1';
						Reg_F(4) <= '1';
						Reg_F(5) <= NOT Reg_A(5);
						Reg_F(3) <= NOT Reg_A(3);
					END IF;
					IF i_ccf='1' THEN
						Reg_F(0) <= NOT Reg_F(0);
						Reg_F(1) <= '0';
						Reg_F(4) <= Reg_F(0);
						Reg_F(5) <= Reg_A(5);
						Reg_F(3) <= Reg_A(3);
					END IF;
					IF i_scf='1' THEN
						Reg_F(0) <= '1';
						Reg_F(1) <= '0';
						Reg_F(4) <= '0';
						Reg_F(5) <= Reg_A(5);
						Reg_F(3) <= Reg_A(3);
					END IF;
					IF block_OP='1' THEN
						Reg_F(4) <= '0';
						Reg_F(1) <= '0';
						Reg_F(2) <= NOT Reg_BCZ;
						CASE opcode(2 downto 0) IS
							WHEN "000" => 					--LD
--								IF Reg_BCZ='0' OR opcode(4)='0' THEN  
									Reg_F(5) <= ldi_q(1);
									Reg_F(3) <= ldi_q(3);
--								END IF;	
							WHEN "001" => 					--CP
								Reg_F(4) <= cpi_q(4) XOR Reg_A(4) XOR last_datain(4);	--H
								Reg_F(6) <= cpi_z; 			--Z
								Reg_F(7) <= cpi_q(7); 		--S		
								Reg_F(1) <= '1';			--N
								Reg_F(3) <= cpi_hq(4);	--X
								Reg_F(5) <= cpi_hq(2);	--Y
							WHEN "010"|"011" => 					--IN, OUT
								Reg_F(1) <= '1';			--N
								Reg_F(6) <= Reg_BZ;			--Z
							WHEN OTHERS =>
						END CASE;
					END IF;
					IF regwrena='1'  AND (opcode(5 downto 4)="11" AND rot_OP='0') THEN
						IF datatype='1' THEN
							Reg_A <= registerin(15 downto 8);		--A
						ELSIF opcode(3)='1' THEN
							Reg_A <= registerin(7 downto 0);		--A
						END IF;
						IF datatype='1' THEN
							Reg_F <= registerin(7 downto 0);		--F
						END IF;
					END IF;	
					IF rot_AOP='1' OR (regwrena='1' AND (opcode(2 downto 0)="111" AND rot_OP='1')) THEN
						Reg_A <= rotout;		--A
					END IF;	
				END IF;	
			END IF;	
		END IF;	
	END PROCESS;
-----------------------------------------------------------------------------
-- Reg_SP
-----------------------------------------------------------------------------
PROCESS (clk, reset, presub)
	BEGIN
		Reg_SP_a(15 downto 1) <= (OTHERS=>presub);
		Reg_SP_a(0) <= '1';
      	IF reset = '0' THEN
			Reg_SP <= (OTHERS=>'0');
	  	ELSIF rising_edge(clk) THEN
			IF clkena_in='1' THEN
				IF SP_incdec='1' THEN
					Reg_SP <= Reg_SP+Reg_SP_a;
				END IF;	
				IF data_read_to_SP='1' THEN
					Reg_SP <= data_read;
				END IF;	
				IF HL_to_SP='1' THEN
					Reg_SP <= Reg_HLXY;
				END IF;	
			END IF;	
		END IF;	
	END PROCESS;
	
-----------------------------------------------------------------------------
-- Reg_A_in
-----------------------------------------------------------------------------
PROCESS (opcode, Reg_A, Reg_F, Reg_A_in, ERegl_out, arith_AV, arith_AH, arith_AP, last_datain, rotout, 
	     rotcout, rot_FP, bitmask, set_store_in_tmp)
	BEGIN
--		arith_AF <= Reg_A_in(8)&"0-0-00"&Reg_A_in(9);	
--		arith_AF <= Reg_A_in(8)&'0'&Reg_F(5)&'0'&Reg_F(3)&"00"&Reg_A_in(9);	
		arith_AF <= Reg_A_in(8)&'0'&Reg_A_in(6)&'0'&Reg_A_in(4)&"00"&Reg_A_in(9);	
		arith_AP <= ((NOT Reg_A_in(8) XOR Reg_A_in(7)) XOR (Reg_A_in(6) XOR Reg_A_in(5))) XOR ((Reg_A_in(4) XOR Reg_A_in(3)) XOR (Reg_A_in(2) XOR Reg_A_in(1)));	--P 	
		arith_AV <= (Reg_A_in(9) XOR Reg_A_in(8) XOR ERegl_out(7) XOR Reg_A(7));	--V 
--		arith_AV <= (NOT arith_AF(1) XOR ERegl_out(7) XOR Reg_A(7)) AND (Reg_A(7) XOR Reg_A_in(8));	--V 
		arith_AH <= ERegl_out(4) XOR Reg_A(4) XOR Reg_A_in(5);	--H
 		IF Reg_A_in(8 downto 1)=X"00" THEN
			arith_AF(6) <= '1';		--Z
		END IF;	

		CASE opcode(7)&opcode(5 downto 3) IS
			WHEN "1000" => Reg_A_in <= ('0'&Reg_A&'0') + ('0'&ERegl_out&'0');			--ADD
				 arith_AF(2) <= arith_AV;	--V
				 arith_AF(4) <= arith_AH;	--H
			WHEN "1001" => Reg_A_in <= ('0'&Reg_A&Reg_F(0)) + ('0'&ERegl_out&Reg_F(0));	--ADC
				 arith_AF(2) <= arith_AV;	--V
				 arith_AF(4) <= arith_AH;	--H
			WHEN "1010"|"1111" => Reg_A_in <= ('0'&Reg_A&'0') - ('0'&ERegl_out&'0');		--SUB, CMP
				 arith_AF(1) <= '1';		--N
				 arith_AF(2) <= arith_AV;	--V
				 arith_AF(4) <= arith_AH;	--H
				 IF opcode(3)='1' THEN				--CMP
					arith_AF(5) <= ERegl_out(5);
					arith_AF(3) <= ERegl_out(3);
				 END IF;
			WHEN "1011" => Reg_A_in <= ('0'&Reg_A&'0') - ('0'&ERegl_out&Reg_F(0));		--SBC
				 arith_AF(1) <= '1';		--N
				 arith_AF(2) <= arith_AV;	--V
				 arith_AF(4) <= arith_AH;	--H
			WHEN "1100" => Reg_A_in <= ('0'&Reg_A&'0') AND ('0'&ERegl_out&'0');			--AND			
				 arith_AF(2) <= arith_AP;	--P
				 arith_AF(4) <= '1';	--H
			WHEN "1101" => Reg_A_in <= ('0'&Reg_A&'0') XOR ('0'&ERegl_out&'0');			--XOR			
				 arith_AF(2) <= arith_AP;	--P
			WHEN "1110" => Reg_A_in <= ('0'&Reg_A&'0') OR ('0'&ERegl_out&'0');			--OR	
				 arith_AF(2) <= arith_AP;	--P
			WHEN "0000" => Reg_A_in <= ("0000000000") - ('0'&Reg_A&'0');			--NEG
				 arith_AF(1) <= '1';		--N
--				 arith_AF(2) <= arith_AV;	--V
--				 arith_AF(4) <= arith_AH;	--H	
				 IF Reg_A=X"80" THEN
				 	arith_AF(2) <= '1';	--V
				 END IF;
				 arith_AF(4) <= Reg_A(4) XOR Reg_A_in(5);	--H	
			WHEN "0100" => Reg_A_in <= (Reg_F(0)&Reg_A(7 downto 4)&last_datain(3 downto 0)&'0');			--RRD	
				 arith_AF(2) <= arith_AP;	--P
--				 arith_AF(0) <= Reg_F(0);	--C
			WHEN "0101" => Reg_A_in <= (Reg_F(0)&Reg_A(7 downto 4)&last_datain(7 downto 4)&'0');			--RLD	
				 arith_AF(2) <= arith_AP;	--P
--				 arith_AF(0) <= Reg_F(0);	--C
			WHEN OTHERS=> Reg_A_in <="XXXXXXXXXX";	
		END CASE;
-- Rotation ---------------------------------------------------------------------------
		rotout <= "XXXXXXXX"; 
		rotcout <= 'X';
		rot_FP <= 'X';
		
		CASE opcode(7 downto 6) IS
		WHEN "00"=>
			rot_F <= rotout(7)&'0'&rotout(5)&'0'&rotout(3)&rot_FP&'0'&rotcout;			
			rot_FP <= ((NOT rotout(7) XOR rotout(6)) XOR (rotout(5) XOR rotout(4))) XOR ((rotout(3) XOR rotout(2)) XOR (rotout(1) XOR rotout(0)));	--P 	
	 		IF rotout=X"00" THEN
				rot_F(6) <= '1';		--Z
			END IF;	
			CASE opcode(5 downto 3) IS
				WHEN "000" => 	rotout <= (ERegl_out(6 downto 0)&ERegl_out(7)); --RLC
								rotcout <= ERegl_out(7);
				WHEN "001" => 	rotout <= (ERegl_out(0)&ERegl_out(7 downto 1)); --RRC
								rotcout <= ERegl_out(0);
				WHEN "010" => 	rotout <= (ERegl_out(6 downto 0)&Reg_F(0)); --RL
								rotcout <= ERegl_out(7);
				WHEN "011" => 	rotout <= (Reg_F(0)&ERegl_out(7 downto 1)); --RR
								rotcout <= ERegl_out(0);
				WHEN "100" => 	rotout <= (ERegl_out(6 downto 0)&'0'); --SLA
								rotcout <= ERegl_out(7);
				WHEN "101" => 	rotout <= (ERegl_out(7)&ERegl_out(7 downto 1)); --SRA
								rotcout <= ERegl_out(0);
				WHEN "110" => 	rotout <= (ERegl_out(6 downto 0)&'1'); 
								rotcout <= ERegl_out(7);
				WHEN "111" => 	rotout <= ('0'&ERegl_out(7 downto 1)); --SRL
								rotcout <= ERegl_out(0);
				WHEN OTHERS =>
			END CASE;
		WHEN "01"=>		--Bit
			rot_F <= (ERegl_out(7) AND bitmask(7))&'0'&'0'&'1'&'0'&"00"&Reg_F(0);
	 		IF (ERegl_out AND bitmask)=X"00" THEN
				rot_F(6) <= '1';		--Z
				rot_F(2) <= '1';		--Z
			END IF;	
			IF set_store_in_tmp='0' THEN
				rot_F(5) <= ERegl_out(5);
				rot_F(3) <= ERegl_out(3);
			END IF;	
		WHEN "10"=>		--Res
			rotout <= ERegl_out AND NOT bitmask;
			rot_F <= Reg_F;
		WHEN "11"=>		--Set
			rotout <= ERegl_out OR bitmask;
			rot_F <= Reg_F;
		END CASE;
		
		CASE opcode(5 downto 3) IS 
 		       	WHEN "000"        =>      bitmask <= "00000001";
 		       	WHEN "001"        =>      bitmask <= "00000010";
 		       	WHEN "010"        =>      bitmask <= "00000100";
 		       	WHEN "011"        =>      bitmask <= "00001000";
              	WHEN "100"        =>      bitmask <= "00010000";
              	WHEN "101"        =>      bitmask <= "00100000";
              	WHEN "110"        =>      bitmask <= "01000000";
              	WHEN "111"        =>      bitmask <= "10000000";
		END CASE;
	END PROCESS;
	
-----------------------------------------------------------------------------
-- Reg_HL_in
-----------------------------------------------------------------------------
PROCESS (opcode, arith_HLZ, arith_HLV, arith_HLF, arith_HLH, Reg_HL_in, DReg_out, Reg_HLXY, Reg_F)
	BEGIN
		--            SZY     H       XVN     C
		arith_HLF <= Reg_F(7 downto 6)&Reg_HL_in(14)&arith_HLH&Reg_HL_in(12)&Reg_F(2)&'0'&Reg_HL_in(17);	
		arith_HLV <= (NOT arith_HLF(1) XOR DReg_out(15) XOR Reg_HLXY(15)) AND (Reg_HLXY(15) XOR Reg_HL_in(16));	--V 
		arith_HLH <= DReg_out(12) XOR Reg_HLXY(12) XOR Reg_HL_in(13);	--H
 		IF Reg_HL_in(16 downto 1)=X"0000" THEN
			arith_HLZ <= '1';		--Z
		ELSE	
			arith_HLZ <= '0';		--Z
		END IF;	
		CASE (opcode(6 downto 6)&opcode(3 downto 3)) IS
			WHEN "10"=>		--SBC HL,DReg
				Reg_HL_in <= ('0'&Reg_HLXY&'0') - ('0'&DReg_out&Reg_F(0));
				arith_HLF(7) <= Reg_HL_in(16);	--S
				arith_HLF(6) <= arith_HLZ;			--Z
				arith_HLF(2) <= arith_HLV;			--V
				arith_HLF(1) <= '1';				--N
			WHEN "11"=>		--ADC HL,DReg
				Reg_HL_in <= ('0'&Reg_HLXY&Reg_F(0)) + ('0'&DReg_out&Reg_F(0));
				arith_HLF(7) <= Reg_HL_in(16);	--S
				arith_HLF(6) <= arith_HLZ;			--Z
				arith_HLF(2) <= arith_HLV;			--V
			WHEN OTHERS=>	--ADD HL,DReg
				Reg_HL_in <= ('0'&Reg_HLXY&'0') + ('0'&DReg_out&'0');
		END CASE;
	END PROCESS;
	
-----------------------------------------------------------------------------
-- handle data_write_tmp
-----------------------------------------------------------------------------
PROCESS (clk, reset)
	BEGIN
      	IF reset = '0' THEN
			set_store_in_tmp <='0';
			exec_DIRECT <= '0';
			exec_write_back <= '1';
	  	ELSIF rising_edge(clk) THEN
			IF clkena='1' THEN
				IF fetchOPC='1' THEN
					set_store_in_tmp <='0';
					exec_DIRECT <= '0';
					exec_write_back <= '0';
				ELSE	
					exec_DIRECT <= set_exec_MOVE;
				END IF;

				IF (exec_DIRECT='1' AND state="00" AND fetchOPC='0') OR state="10" THEN
					set_store_in_tmp <= '1'; 
				END IF;	
				IF state="10" AND write_back='1' THEN
					exec_write_back <= '1';
				END IF;	
				
				IF writePC_add='1' THEN
					data_write_tmp <= TG80_PC_add(7 downto 0)&TG80_PC_add(15 downto 8);
				ELSIF use_A='1' THEN
					data_write_tmp <= "XXXXXXXX"&Reg_A;	
				ELSIF set_dirio='1' THEN
					data_write_tmp <= "XXXXXXXX"&ERegh_out;	
				ELSIF rot_OP='1' THEN
					data_write_tmp <= "XXXXXXXX"&rotout;
				ELSIF execOPC='1' AND prefix(1)='1' THEN --RRD, RLD
					IF opcode(3)='1' THEN 				--RLD
						data_write_tmp <= "XXXXXXXX"&last_datain(3 downto 0)&Reg_A(3 downto 0);		
					ELSE								--RRD
						data_write_tmp <= "XXXXXXXX"&Reg_A(3 downto 0)&last_datain(7 downto 4);		
					END IF;
				ELSIF decodeOPC='1' OR execOPC='1' OR IXYe='1' THEN
					IF presub='1' OR exsp='1' THEN
						data_write_tmp <= registerin(7 downto 0)&registerin(15 downto 8);
					ELSE
						data_write_tmp <= registerin;
					END IF;
				END IF;
			END IF;	
		END IF;	
	END PROCESS;
		
------------------------------------------------------------------------------
--Condition
------------------------------------------------------------------------------		
PROCESS (opcode, Reg_F, con1)
	BEGIN
		CASE opcode(4 downto 3) IS
			WHEN B"00" => con1 <= NOT Reg_F(6);
			WHEN B"01" => con1 <= Reg_F(6);
			WHEN B"10" => con1 <= NOT Reg_F(0);
			WHEN B"11" => con1 <= Reg_F(0);
		END CASE;
		CASE opcode(5 downto 3) IS
			WHEN B"100" => con2 <= NOT Reg_F(2);
			WHEN B"101" => con2 <= Reg_F(2);
			WHEN B"110" => con2 <= NOT Reg_F(7);
			WHEN B"111" => con2 <= Reg_F(7);
			WHEN OTHERS => con2 <= con1;
		END CASE;
	END PROCESS;
	
	
-----------------------------------------------------------------------------
-- execute opcode
-----------------------------------------------------------------------------
PROCESS (clk, opcode, fetchOPC, decodeOPC, execOPC, exec_write_back, microaddr, prefix, state, con2, worddone,
	     Reg_BZ, Reg_BCZ, cpi_z, con1)
	BEGIN
		TG80_PC_br8 <= '0';	
		setstate <= "00";
		Regwrena <= '0';
		microstep <= '0';
		presub <= '0';
		ERegpresub <= '0';
		wordreaddirect <= '0';
		write_back <= '0';
		writePC_add <= '0';
		set_directPC <= '0';
		set_exec_MOVE <= '0';
		datatype <= '0';
		
		SP_incdec <= '0';
		SP_to_memaddr <= '0';
		HL_to_memaddr <= '0';
		DE_to_memaddr <= '0';
		BC_to_memaddr <= '0';
   		data_read_to_SP <= '0';
	   	HL_to_SP <= '0';
		set_write_direkt <= '0';
		arith_A <= '0';
		arith_HL <= '0';
		exdehl <= '0';
		exx <= '0';
		exaf <= '0';
		dec_B <= '0';
		HL_to_PC <= '0';
		rst <= '0';
		set_nn_to_mem <= '0';
		use_A <= '0';
		HL_incdec <= '0';
   		DE_incdec <= '0';
   		BC_inc <= '0';
   		BC_dec <= '0';
		incdecOP <= '0';
		rot_AOP <= '0';
		rot_OP <= '0';
   		i_daa <= '0';
   		i_scf <= '0';
   		i_ccf <= '0';
     	i_cpl <= '0';
	   	i_di <= '0';
  		i_ei <= '0';
		set_dirio <= '0';
		set_prefix <= "0000";
		block_loop <= '0';
		ixye <= '0';
		set_halt <= '0';
		i_ldia <= '0';
   		i_ldra <= '0';
   		i_ldai <= '0';
   		i_ldar <= '0';
		i_IM <= '0';
		i_in <= '0';
		block_OP <= '0';
		wait_three <= '0';
		wait_four <= '0';
		wait_five <= '0';
		wait_seven <= '0';
		exsp <= '0';		--schreibreihenfolge
		set_ext_mem <= '0';

------------------------------------------------------------------------------
--ALU
------------------------------------------------------------------------------		
			
------------------------------------------------------------------------------
--prepere opcode
------------------------------------------------------------------------------		
		IF execOPC='1' AND fetchOPC='0' AND exec_write_back='1' THEN
			setstate <="11";
		END IF;		
-----------------------------------------------------------------------------
-- execute microcode
-----------------------------------------------------------------------------
		CASE prefix(1 downto 0)&opcode(7 downto 6) IS
		WHEN "0000" =>
			CASE "00"&opcode(5 downto 0) IS
			
		--EX AF
			WHEN X"08" =>
				exaf <= '1';
		--DJNZ e
			WHEN X"10" =>
				IF decodeOPC='1' THEN
					microstep <='1';
					dec_B <= '1';
					wait_three <= '1';
				END IF;
				IF Reg_BZ='0' THEN
					IF microaddr(1)='1' THEN   
						setstate <= "01";
					END IF;
					IF microaddr(2)='1' THEN   
						TG80_PC_br8 <= '1';
					END IF;
				END IF;
		--JR e
			WHEN X"20"|X"28"|X"30"|X"38"|
				X"18" =>
				IF decodeOPC='1' THEN
					microstep <='1';
				END IF;
				IF opcode(5)='0' OR con1='1' THEN
					IF microaddr(1)='1' THEN   
						setstate <= "01";
					END IF;
					IF microaddr(2)='1' THEN   
						TG80_PC_br8 <= '1';
					END IF;
				END IF;
		--LD DReg,nn
			WHEN X"01"|X"11"|X"21"|X"31" =>
				datatype <= '1';
				set_exec_MOVE <= '1';
				IF opcode(5 downto 4)="11" THEN
					data_read_to_SP <= '1';
				ELSE	
--					IF execOPC='1' THEN
						regwrena <= '1';
--					END IF;
				END IF;
--				regwrena <= '1';
				IF decodeOPC='1' THEN
					microstep <='1';
					wordreaddirect <= '1';
				END IF;
		--LD (Reg),A
			WHEN X"02"|X"12" =>
				IF decodeOPC='1' THEN
					setstate <= "11";
					use_A <= '1';
				END IF;
		--LD A,(Reg)
			WHEN X"0A"|X"1A" =>
				use_A <= '1';
				IF decodeOPC='1' THEN
					setstate <= "10";
				END IF;
		--LD (nn),Reg
			WHEN X"22"|X"32" =>
				IF opcode(4)='0' THEN
					datatype <= '1';
				END IF;
				IF decodeOPC='1' THEN
					IF opcode(4)='1' THEN
						use_A <= '1';
					END IF;
					microstep <='1';
					wordreaddirect <= '1';
				END IF;
				IF microaddr(1)='1' THEN  
					set_nn_to_mem <= '1';
					setstate <= "11";
				END IF;
		--LD Reg,(nn)
			WHEN X"2A"|X"3A" =>
				IF opcode(4)='1' THEN
					use_A <= '1';
				ELSE
					datatype <= '1';
					regwrena <= '1';
				END IF;
				IF decodeOPC='1' THEN
					microstep <='1';
					wordreaddirect <= '1';
				END IF;
				IF microaddr(1)='1' THEN  
					set_nn_to_mem <= '1';
					setstate <= "10";
				END IF;
		--ADD HL,DReg
			WHEN X"09"|X"19"|X"29"|X"39" =>
--				datatype <= '1';
				arith_HL <= '1';
				IF decodeOPC='1' THEN
					setstate <="01";
				END IF;
				IF microaddr(1)='1' THEN  
					wait_seven <= '1';
				END IF;
		--INC BC
			WHEN X"03" =>
				wait_four <='1';
				IF execOPC='1' THEN
					BC_inc <='1';	
				END IF;	
		--DEC BC
			WHEN X"0B" =>
				wait_four <='1';
				presub <= '1';
				IF execOPC='1' THEN
					BC_dec <='1';	
				END IF;	
		--INC DE
			WHEN X"13" =>
				wait_four <='1';
				DE_incdec <='1';	
		--DEC DE
			WHEN X"1B" =>
				wait_four <='1';
				presub <= '1';
				DE_incdec <='1';	
		--INC HL
			WHEN X"23" =>
				wait_four <='1';
				HL_incdec <='1';	
		--DEC HL
			WHEN X"2B" =>
				wait_four <='1';
				presub <= '1';
				HL_incdec <='1';	
		--INC SP
			WHEN X"33" =>
				wait_four <='1';
				IF execOPC='1' THEN
					SP_incdec <='1';	
				END IF;	
		--DEC SP
			WHEN X"3B" =>
				presub <= '1';
				wait_four <='1';
				IF execOPC='1' THEN
					SP_incdec <='1';	
				END IF;	
		--DEC/INC Reg
			WHEN X"04"|X"0C"|X"14"|X"1C"|
			 	 X"24"|X"2C"      |X"3C"|
				 X"05"|X"0D"|X"15"|X"1D"|
			 	 X"25"|X"2D"      |X"3D" =>
				regwrena <= '1';
				incdecOP <= '1';
				IF opcode(0)='1' THEN
					ERegpresub <= '1';
				END IF;	
		--DEC/INC (HL)
			WHEN X"34"|X"35" =>
				write_back <= '1';
				incdecOP <= '1';
				IF opcode(0)='1' THEN
					ERegpresub <= '1';
				END IF;	
				IF prefix(3)='1' THEN	--IXY
					IF decodeOPC='1' THEN
						microstep <='1';
					END IF;
					IF microaddr(1)='1' THEN  
						setstate <= "01";
					END IF;
					IF microaddr(2)='1' THEN  
						setstate <= "10";
						ixye <= '1';
					END IF;
				ELSE
					IF decodeOPC='1' THEN
						setstate <="10";
					END IF;
				END IF;
				
		--LD Reg,n
			WHEN X"06"|X"0E"|X"16"|X"1E"|
			 	 X"26"|X"2E"      |X"3E"=>
				set_exec_MOVE <= '1';
				IF decodeOPC='1' THEN
					microstep <='1';
				END IF;
				regwrena <= '1';
		--LD (HL),n
			WHEN X"36"=>
				set_exec_MOVE <= '1';
				IF decodeOPC='1' THEN
					microstep <='1';
				END IF;
				IF prefix(3)='1' THEN	--IXY
					IF microaddr(1)='1' THEN  
						microstep <='1';
					END IF;
					IF microaddr(2)='1' THEN  
						setstate <= "11";
						set_write_direkt <= '1';
						ixye <= '1';
					END IF;
				ELSE
					IF microaddr(1)='1' THEN  
						setstate <= "11";
						set_write_direkt <= '1';
					END IF;
				END IF;
		--ROT OP
			WHEN X"07"|X"0F"|X"17"|X"1F"=>
				rot_AOP <= '1';
			WHEN X"27" =>	
   				i_daa <= '1';
			WHEN X"2f" =>	
		     	i_cpl <= '1';
			WHEN X"37" =>	
		   		i_scf <= '1';
			WHEN X"3f" =>	
		   		i_ccf <= '1';
			WHEN OTHERS =>
			END CASE;
			
		WHEN "0001" =>
	
		--LD Reg,Reg
				IF opcode(5 downto 0)="110110" THEN	--HALT
					set_halt <= '1';
				ELSE
					IF opcode(2 downto 0)="110" OR opcode(5 downto 3)="110" THEN
						IF prefix(3)='1' THEN	--IXY
							IF decodeOPC='1' THEN
								microstep <='1';
							END IF;
							IF microaddr(1)='1' THEN  
								setstate <= "01";
							END IF;
							IF microaddr(2)='1' THEN  
								IF opcode(2 downto 0)="110" THEN
									setstate <= "10";
								ELSE
									setstate <= "11";
								END IF;
								ixye <= '1';
							END IF;
						ELSE
							IF decodeOPC='1' THEN
								IF opcode(2 downto 0)="110" THEN
									setstate <= "10";
								ELSE
									setstate <= "11";
								END IF;
							END IF;
						END IF;
					END IF;	
					IF opcode(5 downto 3)/="110" THEN	
						regwrena <= '1';
					END IF;	
				END IF;	

		WHEN "0010" =>
				arith_A <= '1';
				IF opcode(2 downto 0)="110" THEN
					IF prefix(3)='1' THEN	--IXY
						IF decodeOPC='1' THEN
							microstep <='1';
						END IF;
						IF microaddr(1)='1' THEN  
							setstate <= "01";
						END IF;
						IF microaddr(2)='1' THEN  
							setstate <= "10";
							ixye <= '1';
						END IF;
					ELSE
						IF decodeOPC='1' THEN
							setstate <="10";
						END IF;
					END IF;
				END IF;	

		WHEN "0011" =>
		CASE "11"&opcode(5 downto 0) IS
		--Arith A,n
			WHEN X"C6"|X"CE"|X"D6"|X"DE"|X"E6"|X"EE"|X"F6"|X"FE" =>
				arith_A <= '1';
				IF decodeOPC='1' THEN
					microstep <='1';
				END IF;
			
		--POP		
			WHEN X"C1"|X"D1"|X"E1"|X"F1" =>
				datatype <= '1';
				IF decodeOPC='1' THEN
					microstep <='1';
					SP_to_memaddr <= '1';
					setstate <= "10";
				END IF;
				IF state(1)='1' THEN
					SP_incdec <= '1';
				END IF;
--				IF execOPC='1' THEN
					regwrena <= '1';
--				END IF;
		--PUSH		
			WHEN X"C5"|X"D5"|X"E5"|X"F5" =>
				datatype <= '1';
				presub <= '1';
				IF decodeOPC='1' THEN
					microstep <='1';
					SP_to_memaddr <= '1';
					setstate <= "11";
					wait_three <= '1';
				END IF;
				IF state(1)='1' THEN
					SP_incdec <= '1';
				END IF;
		--RET		
			WHEN X"C0"|X"D0"|X"E0"|X"F0"|X"C8"|X"D8"|X"E8"|X"F8"| 
				X"C9" =>
				datatype <= '1';
				IF opcode(0)='0' AND decodeOPC='1' THEN
					wait_three <= '1';
				END IF;
				IF opcode(0)='1' OR con2='1' THEN
					IF decodeOPC='1' THEN
						set_directPC <= '1';					
						microstep <='1';
						SP_to_memaddr <= '1';
						setstate <= "10";
					END IF;
				END IF;
				IF state(1)='1' THEN
					SP_incdec <= '1';
				END IF;
		--JP nn		
			WHEN X"C2"|X"D2"|X"E2"|X"F2"|X"CA"|X"DA"|X"EA"|X"FA"| 
				X"C3" =>
				datatype <= '1';
				presub <= '1';
				IF decodeOPC='1' THEN
					microstep <='1';
					wordreaddirect <= '1';
				END IF;
				IF opcode(0)='1' OR con2='1' THEN
					IF decodeOPC='1' THEN
						set_directPC <= '1';					
					END IF;
				END IF;
		--CALL nn		
			WHEN X"C4"|X"D4"|X"E4"|X"F4"|X"CC"|X"DC"|X"EC"|X"FC"| 
				X"CD" =>
				datatype <= '1';
				presub <= '1';
				IF decodeOPC='1' THEN
					microstep <='1';
					wordreaddirect <= '1';
				END IF;
				IF opcode(0)='1' OR con2='1' THEN
					IF decodeOPC='1' THEN
						set_directPC <= '1';					
					END IF;
					IF microaddr(1)='1' THEN  --CALL nn
						IF worddone='1' THEN
							wait_four <='1';
						END IF;
						setstate <= "11";
						writePC_add <= '1';
						SP_to_memaddr <= '1';
					END IF;
				END IF;
				IF state(1)='1' THEN  --CALL nn
					SP_incdec <= '1';
				END IF;
		--RST nn		
			WHEN X"C7"|X"D7"|X"E7"|X"F7"|X"CF"|X"DF"|X"EF"|X"FF" =>
				datatype <= '1';
				presub <= '1';
				IF decodeOPC='1' THEN
					setstate <= "11";
					writePC_add <= '1';
					rst <= '1';					
					SP_to_memaddr <= '1';
					wait_three <= '1';
				END IF;
				IF state(1)='1' THEN  --CALL nn
					SP_incdec <= '1';
				END IF;
		--OUT (n),A
			WHEN X"D3" =>
				IF decodeOPC='1' THEN
					IF opcode(4)='1' THEN
						use_A <= '1';
					END IF;
					microstep <='1';
				END IF;
				IF microaddr(1)='1' THEN  
					set_nn_to_mem <= '1';
					setstate <= "11";
					set_dirio <= '1';
				END IF;
		--IN A,(n)
			WHEN X"DB" =>
				use_A <= '1';
				IF decodeOPC='1' THEN
					microstep <='1';
				END IF;
				IF microaddr(1)='1' THEN  
					set_nn_to_mem <= '1';
					setstate <= "10";
					set_dirio <= '1';
				END IF;
		--EX (SP),HL		
			WHEN X"E3" =>
				datatype <= '1';
				IF decodeOPC='1' THEN
					exsp <= '1';		--schreibreihenfolge
					microstep <='1';
					SP_to_memaddr <= '1';
					setstate <= "10";
				END IF;
				IF microaddr(1)='1' THEN  
					setstate <= "11";
--					SP_to_memaddr <= '1';
					IF worddone='1' THEN
						wait_four <='1';
					END IF;
				END IF;
				IF microaddr(2)='1' THEN
				 	IF worddone='1' THEN
						wait_five <='1';
					ELSE	
						presub <= '1';
					END IF;
				END IF;
--				IF execOPC='1' THEN
					regwrena <= '1';
--				END IF;
		--EX DE,HL
			WHEN X"EB" =>
				exdehl <= '1';
		--JP (HL)
			WHEN X"E9" =>
				IF decodeOPC='1' THEN
					HL_to_PC <= '1';
				END IF;
		--LD SP,HL
			WHEN X"F9" =>
				wait_four <='1';
				HL_to_SP <= '1';
		--DI
			WHEN X"F3" =>
			   	i_di <= '1';
		--EI	
			WHEN X"FB" =>
		  		i_ei <= '1';
		--EXX
			WHEN X"D9" =>
				exx <= '1';
		--CB-Tab
			WHEN X"CB" =>
				set_prefix <= prefix(3 downto 2)&"01";
				IF prefix(3)='1' AND  decodeOPC='1' THEN	--DD/FD CB
					microstep <='1';	--e
				END IF;
		--ED-Tab
			WHEN X"ED" =>
				set_prefix <= "0010";
		--DD/FD-Tab
			WHEN X"DD"|X"FD" =>
				set_prefix <= '1'&opcode(5)&"00";
		
			WHEN OTHERS =>	
			END CASE;	
--CB-------------------------------------------------------------
		WHEN "0100"|"0101"|"0110"|"0111" =>		--Rotation
			rot_OP <= '1';
			IF opcode(7 downto 6)/="01" THEN
				regwrena <= '1';
				write_back <= '1';
			END IF;	
			IF prefix(3)='1' THEN	--IXY
				IF microaddr(1)='1' THEN  
					microstep <='1';
				END IF;
				IF microaddr(2)='1' THEN  
					ixye <= '1';
					setstate <= "10";
				END IF;
				IF microaddr(3)='1' AND opcode(7 downto 6)="01" THEN	-- für Timing bei Bit
--					setstate <= "01";
					wait_four <= '1';
				END IF;	
			ELSE
				IF decodeOPC='1' AND opcode(2 downto 0)="110" THEN
					setstate <="10";
				END IF;
			END IF;
			
--ED-------------------------------------------------------------			
		WHEN "1000" =>
			CASE "00"&opcode(5 downto 0) IS
				WHEN OTHERS =>	
			END CASE;
		WHEN "1001" =>
			CASE "01"&opcode(5 downto 0) IS
			--IN EReg,(BC)
				WHEN X"40"|X"50"|X"60"|X"70"|
				     X"48"|X"58"|X"68"|X"78" =>
					BC_to_memaddr <= '1';
					i_in <= '1';
					IF decodeOPC='1' THEN
						setstate <= "10";
						set_dirio <= '1';
					END IF;
					IF execOPC='1' THEN
						regwrena <='1';	
					END IF;
			--OUT (BC),EReg
				WHEN X"41"|X"51"|X"61"|X"71"|
				     X"49"|X"59"|X"69"|X"79" =>
					BC_to_memaddr <= '1';
					IF decodeOPC='1' THEN
						setstate <= "11";
						set_dirio <= '1';
					END IF;
			--ADC/SBC HL,DReg
				WHEN X"42"|X"52"|X"62"|X"72"|
				     X"4A"|X"5A"|X"6A"|X"7A" =>
					arith_HL <= '1';
					IF decodeOPC='1' THEN
						setstate <="01";
					END IF;
					IF microaddr(1)='1' THEN  
						wait_seven <= '1';
					END IF;
			--LD (nn),DReg
				WHEN X"43"|X"53"|X"63"|X"73" =>
					datatype <= '1';
					IF decodeOPC='1' THEN
						microstep <='1';
						wordreaddirect <= '1';
					END IF;
					IF microaddr(1)='1' THEN  
						set_nn_to_mem <= '1';
						setstate <= "11";
					END IF;
			--LD Reg,(nn)
				WHEN X"4B"|X"5B"|X"6B"|X"7B" =>
					datatype <= '1';
					IF opcode(5 downto 4)="11" THEN
						data_read_to_SP <= '1';
					ELSE	
						regwrena <= '1';
					END IF;
					IF decodeOPC='1' THEN
						microstep <='1';
						wordreaddirect <= '1';
					END IF;
					IF microaddr(1)='1' THEN  
						set_nn_to_mem <= '1';
						setstate <= "10";
					END IF;
		--RETN, RETI		
			WHEN X"45"|X"4D"|X"55"|X"5D"|X"65"|X"6D"|X"75"|X"7D" =>
				datatype <= '1';
				IF decodeOPC='1' THEN
					set_directPC <= '1';
					microstep <='1';
					SP_to_memaddr <= '1';
					setstate <= "10";
				END IF;
				IF state(1)='1' THEN
					SP_incdec <= '1';
				END IF;
			--NEG
				WHEN X"44"|X"4C"|X"54"|X"5C"|X"64"|X"6c"|X"74"|X"7C" =>	
					Arith_A <= '1';				
			--LD I,A
				WHEN X"47" =>					
					i_ldia <= '1';
					IF decodeOPC='1' THEN
						wait_three <= '1';
					END IF;
			--LD R,A
				WHEN X"4F" =>					
					i_ldra <= '1';
					IF decodeOPC='1' THEN
						wait_three <= '1';
					END IF;
			--LD A,I
				WHEN X"57" =>					
					i_ldai <= '1';
					IF decodeOPC='1' THEN
						wait_three <= '1';
					END IF;
			--LD A,R
				WHEN X"5F" =>					
					i_ldar <= '1';
					IF decodeOPC='1' THEN
						wait_three <= '1';
					END IF;
			--IM 0,1,2
				WHEN X"46"|X"4E"|X"56"|X"5E"|X"66"|X"6E"|X"76"|X"7E" =>					
					i_IM <= '1';
			--RRD, RLD
				WHEN X"67"|X"6F" =>	
					Arith_A <= '1';				
					write_back <= '1';
					IF decodeOPC='1' THEN
						setstate <="10";
					END IF;
					IF execOPC='1' THEN
						wait_four <= '1';
					END IF;
			

				WHEN OTHERS =>	
			END CASE;
		WHEN "1010" =>
			CASE ("10"&opcode(5 downto 0)) IS
			--LDI, LDD, LDIR, LDDR
				WHEN X"A0"|X"A8"|X"B0"|X"B8" =>
					block_OP <= '1';
					IF (execOPC AND opcode(3))='1' THEN
						presub <= '1';
					END IF;
					DE_incdec <='1';	
					HL_incdec <='1';	
					IF decodeOPC='1' THEN
						setstate <= "10";
					END IF;
					IF microaddr(1)='1' THEN  
						setstate <= "11";
						set_write_direkt <= '1';
						DE_to_memaddr <= '1';
						BC_dec <='1';	
					END IF;
					IF microaddr(2)='1' THEN 
						wait_five <= '1';
						IF Reg_BCZ='0' AND opcode(4)='1' THEN  
							setstate <= "01";
							block_loop <= '1';
						END IF;
					END IF;
			--CPI, CPD, CPIR, CPDR
				WHEN X"A1"|X"A9"|X"B1"|X"B9" =>
					block_OP <= '1';
					IF (execOPC AND opcode(3))='1' THEN
						presub <= '1';
					END IF;
					HL_incdec <='1';	
					IF decodeOPC='1' THEN
						setstate <= "10";
						BC_dec <='1';	
					END IF;
					IF microaddr(1)='1' AND opcode(4)='1' THEN  
						setstate <= "01";
					END IF;
--					IF microaddr(2)='1' AND Reg_BCZ='0' AND Reg_F(6)='0' AND opcode(4)='1' THEN  
					IF microaddr(2)='1' THEN
						wait_five <= '1';
						IF Reg_BCZ='0' AND cpi_z='0' AND opcode(4)='1' THEN  
							setstate <= "01";
							block_loop <= '1';
						END IF;
					END IF;
			--INI, IND, INIR, INDR
				WHEN X"A2"|X"AA"|X"B2"|X"BA" =>
					block_OP <= '1';
					IF (execOPC AND opcode(3))='1' THEN
						presub <= '1';
					END IF;
					HL_incdec <='1';	
					IF decodeOPC='1' THEN
						set_dirio <= '1';
						setstate <= "10";
						BC_to_memaddr <= '1';
						dec_B <='1';	
						wait_three <= '1';
					END IF;
					IF microaddr(1)='1' THEN  
						setstate <= "11";
						set_write_direkt <= '1';
						HL_to_memaddr <= '1';
					END IF;
					IF microaddr(2)='1' THEN 
--						wait_five <= '1';
						IF Reg_BZ='0' AND opcode(4)='1' THEN  
							setstate <= "01";
							block_loop <= '1';
						END IF;
					END IF;
			--OUTI, OUTD, OTIR, OTDR
				WHEN X"A3"|X"AB"|X"B3"|X"BB" =>
					block_OP <= '1';
					IF (execOPC AND opcode(3))='1' THEN
						presub <= '1';
					END IF;
					HL_incdec <='1';	
					IF decodeOPC='1' THEN
						setstate <= "10";
						dec_B <='1';	
						wait_three <= '1';
					END IF;
					IF microaddr(1)='1' THEN  
						set_dirio <= '1';
						setstate <= "11";
						set_write_direkt <= '1';
						BC_to_memaddr <= '1';
					END IF;
					IF microaddr(2)='1' THEN 
--						wait_five <= '1';
						IF Reg_BZ='0' AND opcode(4)='1' THEN  
							setstate <= "01";
							block_loop <= '1';
						END IF;
					END IF;
--new ED A5  LDA ;LD A,(CHL)
				WHEN X"A5" =>
					use_A <= '1';
					IF decodeOPC='1' THEN
						set_ext_mem <= '1';		--c=>Addr(23..16)
--						HL_to_memaddr <= '1';
						setstate <= "10";
					END IF;
--new ED B5  STA ;LD (CHL),A
				WHEN X"B5" =>
					IF decodeOPC='1' THEN
						set_ext_mem <= '1';		--c=>Addr(23..16)
--						HL_to_memaddr <= '1';
						setstate <= "11";
						use_A <= '1';
					END IF;
					
				WHEN OTHERS =>	
			END CASE;
		WHEN "1011" =>
			CASE "11"&opcode(5 downto 0) IS
				WHEN OTHERS =>	
			END CASE;
-----------------------------------------------------------------------------
		WHEN OTHERS =>	
		END CASE;
--	END IF;	
	END PROCESS;
	
-----------------------------------------------------------------------------
-- execute microcode
-----------------------------------------------------------------------------
PROCESS (clk, reset, microaddr)
	BEGIN
		decodeOPC <= microaddr(0);
		IF reset='0' THEN
			nn_to_mem <= '0';
			An_to_mem <= '0';
			prefix <= "0000";
			wrixy <= "00";
			wait_jr <= '0';
		ELSIF rising_edge(clk) THEN
	        IF clkena_in='1' THEN
				nn_to_mem <= '0';
				An_to_mem <= '0';
				IF wordread='0' AND set_nn_to_mem='1' THEN
					IF set_dirio='1' THEN
						An_to_mem <= '1';
					ELSE
						nn_to_mem <= '1';
					END IF;	
				END IF;	
			END IF;	
	        IF clkena='1' THEN
				wait_jr <= '0';
				IF (execOPC='1' OR prefix(3)='1') AND set_prefix/="0000" THEN
					prefix <= set_prefix;
					wrixy <= set_prefix(3 downto 2);
				ELSE
					IF fetchOPC='1' THEN
						prefix <= "0000";
					END IF;	
					IF fetchOPC='1' OR ixye='1' THEN
						wrixy <= "00";
					END IF;	
				END IF;	
				IF fetchOPC='1' THEN
					microaddr <= "00000001";
				ELSE
					microaddr <= microaddr(6 downto 0)&'0';
					IF block_loop='1' THEN
						wait_jr <= '1';
					END IF;	
				END IF;	
			END IF;
		END IF;
	END PROCESS;
END; 