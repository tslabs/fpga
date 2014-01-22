
		org $8000

		; conf start
		ld bc, $F0AF
		ld a, 3
		out (c), a
		ld b,0
		djnz $
		ld bc, $F0AF
		ld a, 2
		out (c), a

		ld a, 8
l1:
		push af
		ld bc, $13AF
		out (c), a

		ld hl, $C000
		ld bc, $EFAF
cf1:
		ld a, (hl)
		out (c), a
		inc l
		jp nz, cf1
		inc h
		jr nz, cf1

		pop af
		inc a
		cp 8+5
		jr c, l1

		jr $

		output "tsxb.bin"
