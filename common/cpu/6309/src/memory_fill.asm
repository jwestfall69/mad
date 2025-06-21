	include "cpu/6309/include/dsub.inc"

	include "machine.inc"

	global memory_fill_dsub
	global memory_fill_word_dsub

	section code

; params:
;  a = byte to fill with
;  w = size
;  x = start address
memory_fill_dsub:
		WATCHDOG
		sta	,x+
		decw
		bne	memory_fill_dsub
		DSUB_RETURN

; params:
;  d = byte to fill with
;  w = size
;  x = start address
memory_fill_word_dsub:
		WATCHDOG
		std	,x++
		decw
		bne	memory_fill_word_dsub
		DSUB_RETURN
