	include "machine.inc"

	global error_address_dsub

	section code
; params
;  d0 = error code
error_address_dsub:

		; convert the error code into a error_address
		; then jump to it.  jump address is $6000 | (d0 << 5)
		and.l	#$ff, d0
		lsl.l	#5, d0
		or.l	#$6000, d0
		move.l	d0, a0
		moveq	#0, d0
		jmp	(a0)



	; The  mad_<machine>.ld file should be setup to put the error_addresses
	; section at $6000 of the rom.  Below will fill $6000 to a little
	; before $8000.
	section error_addresses

	; error addresses are every 32 bytes, so we need to the repeated
	; code block to align with that.  The below block is 16 bytes
	; making it align.  Additionally doing the WATCHDOG instruction
	; to fast will not ping the watchdog, so the delay was added.
	rept $1ff0 / 16
	inline
	.loop:
		WATCHDOG		; should be 6 bytes
		move.w	#$1fff, d0	; 0x303c 1fff
	.delay:
		subq.l	#1, d0		; 0x5380
		bne	.delay		; 0x66fc
		bra	.loop		; 0x60f0
	einline
	endr
