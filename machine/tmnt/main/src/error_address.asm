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
		move.l	#REG_WATCHDOG, a1
		jmp	(a0)


	; The  mad_<machine>.ld file should be setup to put the error_addresses
	; section at $6000 of the rom.  Below will fill $6000 to a little
	; before $8000.

	; tmnt requires special error address code because of it's watchdog.
	; Luckily there isn't a conflict between the watchdog address and the
	; address range of error addresses:
	;   watchdog address: 0x0a0011 = 0000 1010 0000 0000 0001 0001
	;   error address:    0x006000 = 0000 0000 011x xxxx xxx0 0000
	; x = error code.
	; Additionally pinging the watchdog to fast will cause it to not
	; register so we have a delay in our loop.

	section error_addresses

	; error addresses are every 32 bytes, so we need to the repeated
	; code block to align with that.  The nop instruction pads the code
	; block so the total size is 16 bytes.
	rept $1ff
	inline
	.loop:
		move.b	d0, (a1)	; 0x1280
		move.l	#$1fff, d0	; 0x203c 0000 1fff
	.delay:
		nop			; 0x4e71
		subq.l	#1, d0		; 0x5380
		bne	.delay		; 0x66fa
		bra	.loop		; 0x60f0
	einline
	endr
