	include "cpu/6309/include/psub.inc"

	include "machine.inc"

	global memory_fill_psub
	global memory_fill_word_psub

	section code

; params:
;  a = byte to fill with
;  w = size
;  x = start address
memory_fill_psub:
		WATCHDOG
		sta	,x+
		decw
		bne	memory_fill_psub
		PSUB_RETURN

; params:
;  d = byte to fill with
;  w = size
;  x = start address
memory_fill_word_psub:
		WATCHDOG
		std	,x++
		decw
		bne	memory_fill_word_psub
		PSUB_RETURN
