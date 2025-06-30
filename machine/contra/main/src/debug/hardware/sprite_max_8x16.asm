	include "cpu/6309/include/common.inc"
	include "smc.inc"

	global sprite_max_8x16

	section code

sprite_max_8x16:
		jsr	smc_palette_setup

		ldx	#d_smc_settings
		jsr	smc_draw_sprites

		lda	#INPUT_B2
		jsr	wait_button_press

		rts

	section data

d_smc_settings:		SMC_SETTINGS $79, $04, $12, $a, $8, $18
