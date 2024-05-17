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
		jmp	(a0)



	; The diag rom's .ld file should be setup to put the error_addresses
	; section at $6000 of the rom.  Below will fill $6000 to a little
	; before $8000 with opcode $60fe (bra self)
	section error_addresses
		blk.w ($1fe2 / 2), $60fe
