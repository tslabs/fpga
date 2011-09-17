/*
Copyright 2007 Tobias Gubener

This file is part of Minimig

Minimig is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

Minimig is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

*/
				
#include <stdio.h>
#include "hardware.h"
#include "fat16z80.h" 

/*internal global variables*/
//static unsigned long fatstart;					/*start LBA of first FAT table*/
//static unsigned long datastart;       			/*start LBA of data field*/
//static unsigned long dirstart;   				/*start LBA of directory table*/
//static unsigned char fatno; 					/*number of FAT tables*/
//static unsigned char clustersize;     			/*size of a cluster in blocks*/
//static unsigned short direntrys;     			/*number of entry's in directory table*/
unsigned char secbuf[512];						/*sector buffer*/

unsigned short file_chain;	
unsigned short chain_page;	
unsigned long sector;			
unsigned long data_start;		
unsigned long root;		
unsigned long fat_table;			
unsigned long file_size;		
unsigned char clust_psector;	
//unsigned char filebuf[512];						/*file buffer*/


/*FindDrive checks if a card is present. if a card is present it will check for
a valid FAT16 primary partition*/
unsigned char FindDrive(void)
{
	_asm

			xor		a
			ld		h,a
			ld		l,a
			ld		(_sector),hl
			ld		(_sector+2),a			;sector 0
			call	_cmd_read_block0			;partitiontable	
			ld		l,#0
			jp		z,.fat3					;time_err
			
//	if(secbuf[450]!=0x04 && secbuf[450]!=0x06 && secbuf[450]!=0x0e)
//		return(0);
//	                  					/*check signature*/		
			ld		hl,#_secbuf
			ld		de,#450
			add		hl,de
			ld		a,(hl)
			ex		de,hl
			ld		l,#0
			cp		#0x04
			jr		z,.fat4
			cp		#0x06
			jr		z,.fat4
			cp		#0x0e
			jr		nz,.fat3					;FAT_err
			
//	if(secbuf[510]!=0x55 || secbuf[511]!=0xaa)
//		return(0);

.fat4:		ld		hl,#060
			add		hl,de
			ex		de,hl
			ld		l,#0
			ld		a,(de)
			cp		#0x55
			jr		nz,.fat3					;FAT_err
			inc		de
			ld		a,(de)
			cp		#0xaa
			jr		nz,.fat3					;FAT_err
			
.fat5:		ld		hl,(_secbuf+0x1c6)		;1. Partition
			ld		a,(_secbuf+0x1c8)
			ld		(_sector),hl
			ld		(_sector+2),a			;sector Boot Record


			call	_cmd_read_block0			;get Boot Record	
			ld		l,#0
			jr		z,.fat3					;time_err
			
//	/*check for near-jump or short-jump opcode*/
//	if(secbuf[0]!=0xe9 && secbuf[0]!=0xeb)
//		return(0);
//	
//	/*check if blocksize is really 512 bytes*/
//	if(secbuf[11]!=0x00 || secbuf[12]!=0x02)
//		return(0);
//	
//	/*check medium descriptorbyte, must be 0xf8 for hard drive*/
//	if(secbuf[21]!=0xf8)
//		return(0);

			ld		de,(_secbuf+0xE)		;reserved sectors
			ld		hl,(_sector)
			ld		a,(_sector+2)

			add		hl,de
			adc		a,#0
			ld		(_fat_table),hl
			ld		(_fat_table+2),a

			ex		de,hl
			ld		c,a
			ld		hl,(_secbuf+0x16)		;Sectors per Fat
			ld		a,(_secbuf+0x10)			;number of FAT Copies
			cp		#02
			ld		a,#0
			jr		nz,.fat1
			add		hl,hl				;Fat * 2
			adc		a,a
.fat1:		add		hl,de
			adc		a,c
			ld		(_root),hl			;Root sector
			ld		(_root+2),a

			ex		de,hl
			ld		c,a
			ld		hl,(_secbuf+0x11)		;max root Entries*32/512
			ld		b,#4
.fat2:		srl		h
			rr		l
			djnz	.fat2
			xor		a
			add		hl,de
			adc		a,c
			ld		(_data_start),hl		;data area
			ld		(_data_start+2),a

			ld		a,(_secbuf+0x0d)		;Sectors per Cluster
			dec		a
			ld		(_clust_psector),a

			ld		hl,#0xFFFF
			ld		(_file_chain),hl
			ld		(_chain_page),hl
.fat3:			
	_endasm;
}

unsigned char Search(unsigned char *name)
{
	unsigned char e;
	e=*name;
	_asm
	
	
			ld		hl,(_root)				;Root sector
			ld		a,(_root+2)
			ld		(_sector),hl
			ld		(_sector+2),a			;File sector
.search1:	call	_cmd_read_block0			;get Root Directory Entry	
			ld		a,#0
			jp		z,.search9
			ld		hl,#_secbuf
			ld		c,#0x10					;16 Einträge
.search2:	ld		a,(hl)
			or		a
			jr		z,.search9
			cp		#0x2e
			jr		z,.search5
			cp		#0xe5
			jr		z,.search5
			
;-------------------------------------------
;test_name	
			push	hl
			ex		de,hl
			ld		l,4(ix)
			ld		h,5(ix)
			ld		b,#0xb
.tname1:	ld		a,(de)
			cp		#"a"
			jr		c,.tname2
			cp		#"z"+1
			jr		nc,.tname2
			sub		a,#" "
.tname2:	cp		(hl)
			jr		nz,.tname3
			inc		de
			inc		hl
			djnz 	.tname1
			ex		de,hl
			ld		a,(hl)		;dateiattribute
			pop		hl
			and		#0x1A
			jr		nz,.search5
			push	hl
			ld		de,#0x1a
			add		hl,de		;1. Cluster
			ld		e,(hl)
			inc		hl
			ld		d,(hl)
			inc		hl
			ld		(_file_chain),de
			ld		e,(hl)
			inc		hl
			ld		d,(hl)
			inc		hl
			ld		(_file_size),de
			ld		e,(hl)
			inc		hl
			ld		d,(hl)
			inc		hl
			ld		(_file_size+2),de
			ld		a,#0xFF		;File found
			pop		hl
			jr		.search9
.tname3:
			pop	hl
.search5:	ld		a,l
			add		a,#0x20
			ld		l,a
			adc		h
			sub		l
			ld		h,a
			dec		c
			jr		nz,.search2

			ld		hl,#_sector
			inc		(hl)
			jr		nz,.search1
			inc		hl
			inc		(hl)
			jr		nz,.search1
			inc		hl
			inc		(hl)
			jr		.search1

.search9:	ld		l,a
	_endasm;
	return(e);
}

unsigned char Load(unsigned long addr)
{
	unsigned char e;
	e=(unsigned char)addr;
	_asm
			exx
			ld		l,4(ix)
			ld		h,5(ix)
			ld		c,6(ix)
			ld		b,#0xFF
			exx

.load1:		ld		hl,(_file_chain)		;Cluster
			ld		a,h
			and		l
			inc		a
			jp		z,.load98
			
		; calc cluster to sector
			dec		hl
			dec		hl
			ld		a,(_clust_psector)
			ld		b,a
			xor		a
.load2:		srl		b
			jr		nc,.load3
			add		hl,hl
			adc		a
			jr		.load2
.load3:		ex		de,hl
			ld		c,a
			ld		hl,(_data_start)
			ld		a,(_data_start+2)

			add		hl,de
			adc		a,c
			ld		(_sector),hl
			ld		(_sector+2),a			;File sector

.load4:		call	_cmd_read_block1
			jp		z,.load97
			ld		hl,(_file_size)
			ld		de,(_file_size+2)
			ld		a,d
			or		e
			jr		nz,.load5
			ld		a,h
			cp		#02
			jr		c,.load98

.load5:		ld		bc,#0x200
			sbc		hl,bc
			jr		nc,.load6
			dec		de
			ld		(_file_size+2),de
.load6:		ld		(_file_size),hl


			ld		hl,#_sector
			inc		(hl)
			ld		b,(hl)
			jr		nz,.load7
			inc		hl
			inc		(hl)
			jr		nz,.load7
			inc		hl
			inc		(hl)
.load7:
			ld		a,(_clust_psector)
			and		b
			jr		nz,.load4
			
			call	next_cluster
			jr		z,.load97	;timeout
			jr		c,.load1
			jr		.load98
			
next_cluster:
			ld		hl,(_chain_page)
			sub		a
			ld		(_chain_page),a
			ld		a,(_file_chain+1)		;Cluster
			cp		h
			ld		(_chain_page+1),a
			jr		nz,.cluster2
			inc		l
			jr		nz,.cluster3

.cluster2:	ld		e,a
			ld		d,#0
			ld		hl,(_fat_table)
			ld		a,(_fat_table+2)
			add		hl,de
			adc		a,#0
			ld		(_sector),hl
			ld		(_sector+2),a			;sector 0

			exx
			push	hl
			push	bc
			exx
			call	_cmd_read_block0		;fat table
			exx
			pop		bc
			pop		hl
			exx
			ret		z
			
.cluster3:	ld		a,(_file_chain)			;Cluster
			ld		l,a
			ld		h,#0
			add		hl,hl
			ex		de,hl
			ld		hl,#_secbuf
			add		hl,de
			ld		a,(hl)
			inc		hl
			ld		h,(hl)
			ld		l,a
			ld		(_file_chain),hl

			and		h
			sub		#0xff
			ret  	nz			;NC end of chain 
			dec		a
			ret
			
.load97:	ld		l,#0x00
			jr		.load99
.load98:	ld		l,#0xff
.load99:	
	_endasm;
	return(e);
}

