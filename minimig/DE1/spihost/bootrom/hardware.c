#include "hardware.h"


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
