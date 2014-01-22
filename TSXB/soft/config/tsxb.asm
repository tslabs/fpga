
FP_CTRL	equ $F8AF		; bit0: nCONFIG, bit1: MSEL0, bits6,7: window selection
FP_STAT	equ $F8AF		; bit0: nSTATUS, bit7: CONF_DONE

		org $8000
		
		; initiate config
		ld bc, FP_CTRL
		ld a, $C3		; nCONFIG = 0, PS MODE, window at C000
		out (c), a
		ld b,0
		djnz $
		ld bc, FP_CTRL
		ld a, $C2		; nCONFIG = 1, PS MODE, window at C000
		out (c), a

		; transfer bitstream
		ld d, 8
l1:		ld bc, $13AF
		out (c), d
		
		push de
		ld hl, $C000
		ld de, $C000
		ld bc, $4000
		ldir
		pop de
		inc d
		
		ld bc, FP_STAT
		in a, (c)
		rla
		jr nc, l1

		jr $

		output "tsxb.bin"
