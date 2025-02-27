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
	; section at $6000 of the rom.  Below will fill $6000 to to $6ff0

	; timesold requires special error address code because of it's watchdog.
	; Luckily there isn't a conflict between the watchdog address and the
	; address range of error addresses:
	;   watchdog address: $0e8000 = 0000 1110 1000 0000 0001 0110
	;   error address:    $006000 = 0000 0000 011x xxxx xxx0 0000
	; x = error code.

	section error_addresses

	rept $ff0 / 4
	inline
	.loop:
		tst.b	(a1)		; 0x4a11
		bra	.loop		; 0x60fc
	einline
	endr
