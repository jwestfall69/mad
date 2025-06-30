	include "cpu/6309/include/common.inc"
	include "smc.inc"

	global sprite_max_16x8

	section code

sprite_max_16x8:
		jsr	smc_palette_setup

		ldx	#d_smc_settings
		jsr	smc_draw_sprites

		lda	#INPUT_B2
		jsr	wait_button_press

		rts

	section data

d_smc_settings:		SMC_SETTINGS $79, $02, $a, $12, $10, $18
