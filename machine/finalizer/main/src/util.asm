	include "cpu/6809/include/common.inc"

	global m58715_init_dsub

	section code

m58715_init_dsub:
		ldy	#d_m58715_init

	.loop_next_byte:
		lda	,y+
		sta	REG_M58715
		sta	REG_M58715_IRQ_TRIGGER

		DELAY	#$7ff

		cmpy	#d_m58715_init_end
		bne	.loop_next_byte
		DSUB_RETURN

	section data

d_m58715_init:
	dc.b	$8f, $40, $20, $10, $00, $01, $00, $00, $1e, $18, $14, $10
d_m58715_init_end:
