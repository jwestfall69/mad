	include "cpu/68000/include/error_codes.inc"
	include "machine.inc"

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
		moveq	#0, d0
		move.l	#REG_WATCHDOG, a1
		jmp	(a0)

	section error_addresses
	; The mad_<machine>.ld file is setup to put the error_addresses section
	; starting at $6000 of the rom.  Below will fill $6000 to $7000.

	; tmnt watchdog address vs error address
	;   watchdog address: $0a0011 = 0000 1010 0000 0000 0001 0001
	;   error address:    $006000 = 0000 0000 0110 EEEE EEE0 0000
	;     E = error code

	; The watchdog address is in conflict with the error address.
	; However the loop below will mean we are in the error address
	; range 99.9+% of the time.  This is enough for the error addresses
	; to still be viable to use with a logic probe.

	; error address jump points are every 32 bytes, so we need to make
	; sure the below code block is a power of 2 that is <= 32 bytes.  In
	; this case its 16 bytes.
	rept $1000 / 16
	inline
	.loop:
		move.b	d0, (a1)	; $1280 (watchdog)
		move.w	#$1fff, d0	; $303c 1fff
	.delay:
		nop			; $4e71
		nop			; $4e71
		subq.l	#1, d0		; $5380
		bne	.delay		; $66fa
		bra	.loop		; $60f0
	einline
	endr
