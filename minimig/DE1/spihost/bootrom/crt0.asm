	;; Generic crt0.s for a Z80
        .module crt0
       	.globl	_main

	.area	_HEADER (ABS)
	;; Reset vector
	.org 	0
	jp	init

	.org	0x08
	jr	txd_char
	.org	0x10
	reti
	.org	0x18
	reti
	.org	0x20
	reti
	.org	0x28
	reti
	.org	0x30
	reti
	.org	0x38
	reti
txd_char:		cp	#1
			ret	nz
			push	bc
tc1:			ld	bc,#0xfc08
			in	b,(c)
			bit	7,b
			jr	nz,tc1
			ld	bc,#0xfc07
			out	(c),l
			pop	bc
			ret
;;	.org	0x100
init:
	;; Stack at the top of memory.
	ld	sp,#0xfffe

        ;; Initialise global variables
;;    call    gsinit
	call	_main
	jp	_exit

	;; Ordering of segments for the linker.
	.area	_HOME
	.area	_CODE
        .area   _GSINIT
        .area   _GSFINAL

	.area	_DATA
        .area   _BSS
        .area   _HEAP

        .area   _CODE
__clock::
	ld	a,#2
        rst     0x08
	ret

_exit::
	;; Exit - special code to the emulator
	ld	a,#0
        rst     0x08
1$:
	halt
	jr	1$

        .area   _GSINIT
gsinit::

        .area   _GSFINAL
        ret
