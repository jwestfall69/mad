	include "cpu/6309/include/error_codes.inc"
	include "machine.inc"

	global error_address

	section code

; params:
;  a = error code
error_address:
		; jump address is $f000 | (error_code << 4)
		anda	#EC_MASK
		clrb
		rord
		rord
		rord
		rord
		ldx	#$f000
		jmp	d, x

	section error_addresses
	; The mad_<machine>.ld file is setup to put the error_addresses section
	; starting at $f000 of the rom.  Below will fill $f000 to $f400.

	; mainevt watchdog address vs error address
	;   watchdog address: $1f8c = 0001 1111 1000 1100
	;   error address:    $f000 = 1111 00EE EEEE 0000
	;     E = error code

	; The watchdog address is in conflict with the error address.
	; However the loop below will mean we are in the error address
	; range 99.9+% of the time.  This is enough for the error addresses
	; to still be viable to use with a logic probe.

	; error address jump points are every 16 bytes, so we need to make
	; sure the below code block is a power of 2 that is <= 16 bytes.  In
	; this case its 16 bytes.
	rept $400 / 16
	inline
	.loop:
		sta	REG_WATCHDOG	; $b71f 8c
		ldw	#$1ff		; $1086 01ff
	.delay:
		nop			; $12
		nop			; $12
		nop			; $12
		decw			; $105a
		bne	.delay		; $26f8
		bra	.loop		; $20f0
 	einline
	endr

