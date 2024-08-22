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

	; wwfwfest requires special error address code because of it's watchdog.
	; Luckily there isn't a conflict between the watchdog address and the
	; address range of error addresses:
	;   watchdog address: 0x140016 = 0001 0010 0000 0000 0001 0110
	;   error address:    0x006000 = 0000 0000 011x xxxx xxx0 0000
	; x = error code.

	; This is not yet tested from the point of the watchdog, as my board seems
	; to have a non-functional watchdog.  Its possible the watchdog is getting
	; pinged to fast, which may cause the watchdog to not register the pings.
	section error_addresses

	rept $7f8
	inline
	.loop:
		clr.w	(a1)		; 0x4251
		bra	.loop		; 0x60fc
	einline
	endr
