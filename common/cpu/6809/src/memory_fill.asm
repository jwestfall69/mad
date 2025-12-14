	include "cpu/6309/include/common.inc"

	global memory_fill_dsub
	global memory_fill_word_dsub

	section code

; params:
;  a = byte to fill with
;  x = start address
;  y = size
memory_fill_dsub:
		WATCHDOG
		sta	,x+
		leay	-1, y
		bne	memory_fill_dsub
		DSUB_RETURN

; params:
;  d = byte to fill with
;  x = start address
;  y = size (number of words)
memory_fill_word_dsub:
		WATCHDOG
		std	,x++
		leay	-1, y
		bne	memory_fill_word_dsub
		DSUB_RETURN
