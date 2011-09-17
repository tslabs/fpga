/*
Copyright 2005, 2006, 2007 Dennis van Weeren

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

Hardware control routines

27-11-2005		-started coding
29-01-2006		-done a lot of work
31-01-2006		-added key repeat
06-02-2006		-took out all button handling stuff

24-10-2007      -many changes for DE1 Port / TobiFlex
*/

#include "hardware.h"

/*variables*/
unsigned short systimer;	/*system timer*/
unsigned char spipass;

//unsigned char SSPBUF;	
/*initialize hardware*/
/*{_asm
_endasm;
}*/
void HardwareInit(void)
{	
//_asm
//			xor		a
//			ld		(_spipass),a
//	_endasm;
//	_asm
//		ld	bc,#0xfc08
//		ld	a,#0xF7
//		out	(c),a
//	_endasm;

	/*disable analog inputs*/
//	ADCON1=0b00000110;
	
	/*initalize output register*/
//	PORTA=0b00100011;
//	PORTB=0b01100000;
//	PORTC=0b00010001;	

	/*enable PORTB weak pullup*/
//	RBPU=0;
			
	/*initialize SPI*/
//	SSPSTAT=0x00;
//	SSPCON1=0x31;
	
	/*initialize input/ouput configuration*/
//	TRISA=0b11001100;
//	TRISB=0b00001011;
//	TRISC=0b10010000;
	
	/*initialize serial port*/
	/*SPBRG=129;*/	/*9600 BAUD @ 20MHz*/
//	SPBRG=10;	/*115200 BAUD @ 20MHz*/
//	TXSTA=0x24;
//	RCSTA=0x90;
	
	/*init timer0, internal clk, prescaler 1:256*/
//	T0CON=0xc7;
	
	/*enable interrupt for timer 0*/
//	TMR0IE=1;
//	GIE=1;
}

/*interrupt service routine*/
//void interrupt intservice(void)
//{
	/*clear timer 0 interrupt flag*/
//	TMR0IF=0;
	
	/*set timer to timeout every 10ms
	@20Mhz --> instruction=200ns
	200ns * 256 * 195 = 10ms*/
//	TMR0-=195;	

	/*increment system timer*/
//	systimer++;	
//}
/*get system timer + offset (handy for lots of things)*/
unsigned short GetTimer(unsigned short offset)
{
	unsigned short r;
	
	/*get system time SAFELY*/
//	GIE=0;
	r=systimer;
//	GIE=1;
	
	/*add offset*/
	r+=offset;

	return(r);
}

/*check if timer is past given time in <t>
t may be maximum 30000 ticks in the future*/
unsigned char CheckTimer(unsigned short t)
{
	/*calculate difference*/
//	GIE=0;
	t-=systimer;
//	GIE=1;
	
	/*check if <t> has passed*/
	if(t>30000)
		return(1);
	else
		return(0);
}

/*put out a chacter to the serial port*/
void putch(unsigned char ch) 
{
//	while(TRMT==0);
//	TXREG=ch;  	
char	e;
	e=ch;
	_asm
			ld	l,4(ix)
			push	bc
.tc1:		ld	bc,#0xfc08
			in	b,(c)
			bit	7,b
			jr	nz,.tc1
			ld	bc,#0xfc07
			out	(c),l
			pop	bc
	_endasm;
}

void showLedr(unsigned short ch) 
{
short	e;
	e=ch;
	_asm
			push	bc
			ld		a,4(ix)
			ld		bc,#0xfc2c
			out		(c),a
			inc		c
			ld		a,5(ix)
			out		(c),a
			pop	bc
	_endasm;
}


void showTrack(unsigned char ch) 
{
char	e;
	e=ch;
	_asm
			jr		.st0
			
.st2:		rrca
			rrca
			rrca
			rrca
.st3:		and		#0xf
			push	hl
			ld		hl,#.st4
			add		a,l
			ld		l,a
			adc		a,h
			sub		l
			ld		a,(hl)
			pop		hl
			ret
.st4:		.db 0x40	;0
			.db 0x79	;1
			.db 0x24	;2
			.db 0x30	;3
			.db 0x19	;4
			.db 0x12	;5
			.db 0x02	;6
			.db 0x78	;7
			.db 0x00	;8
			.db 0x10	;9
//		4'h0: oSEG = 7'b1000000;
//		4'h1: oSEG = 7'b1111001;	// ---t----
//		4'h2: oSEG = 7'b0100100; 	// |	  |
//		4'h3: oSEG = 7'b0110000; 	// lt	 rt
//		4'h4: oSEG = 7'b0011001; 	// |	  |
//		4'h5: oSEG = 7'b0010010; 	// ---m----
//		4'h6: oSEG = 7'b0000010; 	// |	  |
//		4'h7: oSEG = 7'b1111000; 	// lb	 rb
//		4'h8: oSEG = 7'b0000000; 	// |	  |
//		4'h9: oSEG = 7'b0011000; 	// ---b----
//		4'ha: oSEG = 7'b0001000;
//		4'hb: oSEG = 7'b0000011;
//		4'hc: oSEG = 7'b1000110;
//		4'hd: oSEG = 7'b0100001;
//		4'he: oSEG = 7'b0000110;
//		4'hf: oSEG = 7'b0001110;
			
			
.st0:		push	bc
			ld		hl,#0
			ld		c,4(ix)
			ld		b,#8
.st1:		rl		c
			ld		a,l
			adc		a,a
			daa
			ld		l,a
			ld		a,h
			adc		#0
			daa
			ld		h,a
			djnz	.st1
			ld		bc,#0xfc28
			ld		a,l
			call	.st3
			out		(c),a
			inc		c
			ld		a,l
			call	.st2
			out		(c),a
			inc		c
			ld		a,h
			call	.st3
			out		(c),a
			inc		c
			ld		a,#0xff
			out		(c),a
			pop	bc
	_endasm;
}


/*SPI-bus*/
unsigned char SPI(unsigned char d)		
{
	char e;
	e=d;
//	out(0xFC09,d);
//	return(in(0xFC09)); 
//	SSPBUF = d;
//	while (!BF);			/*Wait untill controller is ready*/
//	return(SSPBUF);			/*Return with received value*/
	_asm
			push	bc
			ld		a,(_spipass)
			xor		a,#0xff
			ld		(_spipass),a
			jr		z,.spi1
			ld		bc,#0xfc21
			out		(c),l
			in		l,(c)
			jr		.spi2
			
.spi1:		ld		bc,#0xfc08
			ld		a,#0x40
			out		(c),a
			ld		bc,#0xfc20
			out		(c),l
			in		l,(c)
			ld		bc,#0xfc08
			ld		a,#0x41
			out		(c),a
.spi2:		pop		bc
	_endasm;
	return(e);
}

/*SPI-bus*/
unsigned char SPIOSD(unsigned char d)	//USER	
{
	char e;
	e=d;
//	out(0xFC09,d);
//	return(in(0xFC09)); 
//	SSPBUF = d;
//	while (!BF);			/*Wait untill controller is ready*/
//	return(SSPBUF);			/*Return with received value*/
	_asm
		push	bc
		ld		bc,#0xfc08
		ld		a,#0x80
		out		(c),a
		ld		bc,#0xfc0c
		out		(c),l
		in		l,(c)
		ld		bc,#0xfc08
		ld		a,#0x81
		out		(c),a
		pop		bc
	_endasm;
	return(e);
}

void EnableOsd(void)
{
	_asm
		push	bc
		ld		bc,#0xFC08
		ld		a,#0x20
		out		(c),a
		pop		bc
	_endasm;
}
	
void DisableOsd(void)
{
	_asm
		push	bc
		ld		bc,#0xFC08
		ld		a,#0x21
		out		(c),a
		pop		bc
	_endasm;
}

void EnableFpga(void)
{
	_asm
		push	bc
		ld		bc,#0xFC08
		ld		a,#0x10
		out		(c),a
		xor		a
		ld		(_spipass),a
		pop		bc
	_endasm;
}
	
void DisableFpga(void)
{
	_asm
		push	bc
		ld		bc,#0xFC08
		ld		a,#0x11
		out		(c),a
		pop		bc
	_endasm;
}


void EnableCard(void)
{
	_asm
		push	bc
		ld		bc,#0xFC08
		ld		a,#0x02
		out		(c),a
		pop		bc
	_endasm;
}
	
void DisableCard(void)
{
	_asm
		push	bc
		ld		bc,#0xFC08
		ld		a,#0x03
		out		(c),a
;		inc		c
;		out		(c),a
		pop		bc
	_endasm;
}

void ResetLow(void)
{
	_asm
		push 	bc
		ld		bc,#0xFC08
		ld		a,#0x08
		out		(c),a
		pop		bc
	_endasm;
}

void ResetHigh(void)
{
	_asm
		push 	bc
		ld		bc,#0xFC08
		ld		a,#0x09
		out		(c),a
		pop		bc
	_endasm;
}

unsigned char CheckButton(void)
{
	_asm
		push 	bc
		ld		bc,#0xFC08
		in		a,(c)
		rrca
		sbc		a,a
		ld		l,a
		pop		bc
	_endasm;
}

unsigned char OsdGetKey(void)
{
	_asm
		push 	bc
		ld		bc,#0xFC08
		in		a,(c)
		and		#0x0f
		xor		#0x0f
		ld		l,a
		pop		bc
	_endasm;
}

unsigned char AtaReadSector(unsigned long lba, unsigned char *ReadData)
{	lba;
	*ReadData;
	_asm
			push	bc
			push	de
.isp19:		ld		l,4(ix)
			ld		h,5(ix)
			ld		a,6(ix)
			call	cmd_read_direct
			jr		z,.isp10			;Timeout
			ld		l,8(ix)
			ld		h,9(ix)
;rd_sector:
			ld		e,#0
			ld		d,#0
;			ld		bc,#0xfc09
.isp12:		dec		d
			call	z,.isp24
			jr		z,.isp10			;Timeout
			ld		a,#0xff
			out		(c),a		;8 Takte fürs Lesen
			in		a,(c)
			cp		#0xfe
			jr		nz,.isp12			;auf Start warten
.isp13:		ld		a,#0xff
			out		(c),a		;8 Takte fürs Lesen
			in		a,(c)
			ld		(hl),a
			inc		hl
			ld		a,#0xff
			out		(c),a		;8 Takte fürs Lesen
			in		a,(c)
			ld		(hl),a
			inc		hl
			dec		e
			jr		nz,.isp13
			ld		a,#0xff
			out		(c),a		;8 Takte fürs Lesen CRC
			out		(c),a		;8 Takte fürs Lesen CRC
			dec		c
			ld		a,#3
			out		(c),a		;sd_cs high
			
			ld		l,#0xff		;TRUE
			jr		.isp11		; alles OK

.isp10:		
			ld		l,#0		;FALSE
.isp11:		pop		de
			pop		bc
	_endasm;
	return;
}

unsigned char SDCARD_Init(void)
{	
//	char 	e;
//	e=0;
	_asm
		jp	.isp0	

msg_put:	push	af
.tc4:		ld		a,(hl)
			inc		hl
			or		a
			jr		z,.tc3
			call	txt_char
			jr		.tc4
.tc3:		ld		a,#0xd
			call	txt_char
			ld		a,#0xa
			call	txt_char
			pop		af
			ret
		


txt_areg:	push	af
			rrca
			rrca
			rrca
			rrca
			call	nibble
			pop		af
nibble:		and		#0x0F
			cp		#0x0A
			jr		c,nb2
			add		a,#7
nb2:		add		a,#0x30	;"0"			
txt_char:	push	bc
.tc2:		ld		bc,#0xfc08
			in		b,(c)
			bit		7,b
			jr		nz,.tc2
			ld		bc,#0xfc07
			out		(c),a
			pop		bc
			ret
	_endasm;
}	
void cmd_read_block0(void)
{
	_asm
	
;_cmd_read_block0:
//			ld		hl,(_sector)
//			ld		a,(_sector+2)
//			call	txt_areg
//			ld		a,h
//			call	txt_areg
//			ld		a,l
//			call	txt_areg
//			ld		a,#0xd
//			call	txt_char
//			ld		a,#0xa
//			call	txt_char

			call	cmd_read
			ret		z			;Error
			exx
			ld		hl,#_secbuf
			ld		bc,#0x40		;standardbank
			exx
			jr		.read1
	_endasm;
}	
void cmd_read_block1(void)
{
	_asm
			
;_cmd_read_block1:
	; vor Einsprung CHL setzen
//			ld		a,#0x20
//			call	txt_char
//			ld		hl,(_sector)
//			ld		a,(_sector+2)
//			call	txt_areg
//			ld		a,h
//			call	txt_areg
//			ld		a,l
//			call	txt_areg
//			ld		a,#0xd
//			call	txt_char
//			ld		a,#0xa
//			call	txt_char
	
			call	cmd_read
			ret		z			;Timeout
.read1:
			ld		e,#0
			ld		d,#0
			out		(c),h		;8 Takte fürs Lesen
.read2:		dec		d
			call	z,.isp24
			ret		z			;Timeout
			in		a,(c)
			out		(c),h		;8 Takte fürs Lesen
			cp		#0xfe
			jr		nz,.read2			;auf Start warten
			
.read3:		in		a,(c)
			out		(c),h		;8 Takte fürs Lesen
			exx
;			call    test
	; ED B5  STA ;LD (CHL),A
			.db		0xED
			.db		0xB5
			inc		l
			jr		nz,.read4
			inc		h
			jr		nz,.read4
			inc		c
.read4:		exx		
			in		a,(c)
			out		(c),h		;8 Takte fürs Lesen
			exx
;			call    test
	; ED B5  STA ;LD (CHL),A
			.db		0xED
			.db		0xB5
			inc		l
			jr		nz,.read5
			inc		h
			jr		nz,.read5
			inc		c
.read5:		exx		
			dec		e
			jr		nz,.read3
			
			or		a,h	;#0xff		;NZ
;			out		(c),a		;8 Takte fürs Lesen CRC
			out		(c),a		;8 Takte fürs Lesen CRC
			dec		c
			ld		a,#3
			out		(c),a		;sd_cs high
			ret		; NZ=alles OK

test:		inc		b
			dec		b
			ret		z
			ld		d,a
			.db		0xED
			.db		0xA5
			cp		d
			ret		z
			call	txt_areg
			ld		a,#"-"
			call	txt_char
			ld		a,d
			call	txt_areg
			ld		a,#" "
			call	txt_char
			ld		a,d
			ret
		
cmd_reset:	push	de
			ld		de,#0x4095
			xor		a
			ld		h,a
			ld		l,a
			jr		.cmd_wr

cmd_init:	push	de
			ld		de,#0x41ff
			xor		a
			ld		h,a
			ld		l,a
			jr		.cmd_wr

cmd_read:	ld		hl,(_sector)
			ld		a,(_sector+2)
cmd_read_direct:
			push	de
			ld		de,#0x51FF		;read	return(0);
			
.cmd_wr:	push	de
			ld		de,#0xFF02
			ld		bc,#0xfc09
			out		(c),d		;8x clock
			dec		c			;ld	bc,0fc08h
			out		(c),e		;sd_cs low
			inc		c			;ld	bc,0fc09h
			out		(c),d		;8x clock
			pop		de
			add		hl,hl
			adc		a
;			jr		c,cmd_overflow	
			out		(c),d		;cmd
			out		(c),a		;31..24
			out		(c),h		;23..16
			out		(c),l		;15..8
			xor		a
			out		(c),a		;7..0
			out		(c),e		;crc
			pop		de

			;wait for answer
			dec		a			;ld	a,0ffh
			ld		l,a
			ld		h,a			;ld	h,0ffh
			
	    ;  Timeout
.isp6:		dec		l
			jr		z,.isp23
;			ret		z	;ERROR
			out		(c),h		;8 Takte fürs Lesen
			in		a,(c)
			cp		h
			jr		z,.isp6
;			ret
			
			cp		#0x2
			ret		c			;NZ
			push	af
			bit		7,a
			ld		hl,#msg_time
			jr		nz,.isp22
			bit		5,a
			ld		hl,#msg_address
			jr		nz,.isp22
			bit		6,a
			ld		hl,#msg_para
			jr		nz,.isp22
			bit		3,a
			ld		hl,#msg_crc
			jr		nz,.isp22
			bit		2,a
			ld		hl,#msg_illegal
			jr		nz,.isp22
			ld		hl,#msg_any
.isp22:		call	msg_put
			pop		af
			ret

.isp23:		push	hl
			push	af
			ld		hl,#msg_cmdtime
			call	msg_put
			pop		af
			pop		hl
			ret
			
.isp24:		push	hl
			push	af
			ld		hl,#msg_readtime
			call	msg_put
			pop		af
			pop		hl
			ret
			
msg_time:		.ascii	"Timeout error"
				.db 0x00
msg_address:	.ascii	"Address error"
				.db 0x00
msg_crc:		.ascii	"crc error"
				.db 0x00
msg_illegal:	.ascii	"illegal error"
				.db 0x00
msg_para:		.ascii	"parameter error"
				.db 0x00
msg_any:		.ascii	"any error"
				.db 0x00
msg_cmdtime:	.ascii	"Command Time"
				.db 0x00
msg_readtime:	.ascii	"Read Time"
				.db 0x00
			


.isp0::
			push	bc
			push	de
			
		ld	bc,#0xfc0a
		ld	a,#03;x3f		;speed = low
		out	(c),a
		
			ld	 	a,#0x03
			ld		bc,#0xfc08
			out		(c),a			;sd_cs high
;.isp1:		djnz	.isp1			;wait
			ld	 	d,#0xff


			ld		bc,#0xfc09	
			ld		e,#0xff			;>64 Takte
.isp2:		out		(c),d
			dec		e
			jr		nz,.isp2

			ld		e,#0x10
.isp3:		ld		l,#01			;reset timeout_error
			dec		e
			jr		z,.isp5
			call	cmd_reset
			cp		#01				;Idle state?
			jr		nz,.isp3
			dec		c				;ld		bc,#0xfc08
			ld		l,#3
			out		(c),l			;sd_cs high
			cp		#01				;Idle state?
			jr		nz,.isp3

			ld		e,#0x80				;min #0x20
.isp4:		ld		b,#0x40
			xor		a
.isp7:		inc		a
			jr		nz,.isp7
			djnz	.isp7			;wait

			ld		l,#2			;init timeout_error
			dec		e
			jr		z,.isp5
			call	cmd_init
			dec		c				;ld		bc,#0xfc08
			ld		l,#3
			out		(c),l			;sd_cs high
			or		a
			jr		nz,.isp4
			ld		l,a				;Init done
.isp5:			
		ld	bc,#0xfc0a
		ld	a,#0x01
		out	(c),a
		
		pop		de
			pop		bc
	_endasm;
	return;
}
/*unsigned char AtaWriteSector(unsigned long lba, unsigned char *WriteData)
{
	return(0);
}*/
