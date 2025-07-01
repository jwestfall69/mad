	include "cpu/68000/include/common.inc"

	global error_address

	section code

; params:
;  d0 = error code
error_address:
		; jump address is $6000 | (d0 << 5)
		and.l	#EC_MASK, d0
		lsl.l	#5, d0
		or.l	#$6000, d0
		move.l	d0, a0
		jmp	(a0)

	section error_addresses
	; The mad_<machine>.ld file is setup to put the error_addresses section
	; starting at $6000 of the rom.  Below will fill $6000 to $7000.

	; error address jump points are every 32 bytes, so we need to make
	; sure the below code block is a power of 2 that is <= 32 bytes.  In
	; this case its 2 bytes.
	rept $1000 / 2
	inline
	.loop:
		bra	.loop	; $60fe
	einline
	endr
