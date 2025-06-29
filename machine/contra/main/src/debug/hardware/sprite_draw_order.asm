	include "global/include/macros.inc"
	include "global/include/screen.inc"

	include "cpu/6x09/include/macros.inc"

	include "cpu/6309/include/dsub.inc"

	include "input.inc"
	include "machine.inc"
	include "mad.inc"
	include "smc.inc"

	global sprite_draw_order

	section code

; This fills the 264 available 8x8 sprite blocks with
; 132 8x16 sprites.  Then 1 sprite of each size is
; written after that in the sprite list.  Each time
; you press button 1 it will convert one of the 8x16
; sprites into 8x8.  This frees up an 8x8 sprite block
; that goes towards the one of the 5 extra sprites.
; This allow seeing for example how a 32x32 sprite is
; drawn when there is only a single 8x8 sprite block
; available for it.
sprite_draw_order:
		SEEK_XY	SCREEN_START_X, (SCREEN_B1_Y + 8)
		ldy	#d_str_b1_convert
		RSUB	print_string

		jsr	smc_palette_setup

		; fill the screen with 8x16
		ldx	#d_smc_settings
		jsr	smc_draw_sprites

		; copy over our 5 sprite sized sprites
		; to the location right after the last
		; drawn sprite
		ldy	#K007121_18E_SPRITE
		leay	5 * 132, y
		ldx	#d_draw_sprites
		lda	#5 * 5
	.loop_next_byte:
		ldb	, x+
		stb	, y+
		deca
		bne	.loop_next_byte

		ldy	#K007121_18E_SPRITE
	.loop_input:
		WATCHDOG
		jsr	input_update

		lda	r_input_edge
		bita	#INPUT_B1
		beq	.b1_not_pressed

		ldb	#$6
		stb	4, y
		leay	5, y
		bra	.loop_input

	.b1_not_pressed:
		bita	#INPUT_B2
		beq	.loop_input
		rts

	section data

d_str_b1_convert:	STRING "B1 - CONVERT 8X16 TO 8X8"

d_smc_settings:		SMC_SETTINGS $79, $04, $12, $a, $8, $11

d_draw_sprites:
	dc.b	$79, $00, $c0, $b0, $08	; 32x32
	dc.b	$79, $00, $a0, $b0, $00 ; 16x16
	dc.b	$79, $00, $80, $b0, $04 ; 8x16
	dc.b	$79, $00, $68, $b0, $02 ; 16x8
	dc.b	$79, $00, $50, $b0, $06 ; 8x8
