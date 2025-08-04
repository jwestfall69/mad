	include "cpu/6309/include/common.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	global k051960_zoom_debug

	section code

k051960_zoom_debug:
		; highlight color
		ldd	#$001f
		std	FIX_TILE_PALETTE + PALETTE_SIZE + $2

		; sprite palette
		ldx	#d_palette_data
		ldy	#SPRITE_PALETTE + (7 * PALETTE_SIZE)
		ldd	#$20
		jsr	memory_copy

		ldx	#d_sprite_data
		ldy	#r_mw_buffer
		ldd	#$10
		jsr	memory_copy

		; force a write of the buffer
		jsr	write_memory_cb

		; grid color
		ldx	#FIX_TILE_PALETTE + (2 * PALETTE_SIZE) + $2
		ldd	#$1f
		ldw	#$f
		RSUB	memory_fill_word
		clrd
		std	FIX_TILE_PALETTE + (2 * PALETTE_SIZE) + $18

		; fix layer a so it aligns with fix layer
		lda	#$6
		sta	REG_LAYER_A_SCROLL_Y

		ldd	#$ad4f
		lde	#SCREEN_START_Y + 3
		jsr	draw_grid

		ldd	#$8d62
		lde	#SCREEN_START_Y + 12
		jsr	draw_grid

		ldd	#FIX_TILE
		std	r_old_highlight

		ldx	#d_mw_settings
		jsr	memory_write_handler
		rts

; params:
;  x = fix ram location to set highlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:

		ldy	r_old_highlight
		clr	-$2000, y

		lda	#$40
		sta	-$2000, x
		stx	r_old_highlight
		rts


write_memory_cb:
		ldx	#SPRITE_RAM
		ldy	#r_mw_buffer
		ldb	#$10
	.loop_next_sprite_address:
		lda	, y+
		sta	, x+
		decb
		bne	.loop_next_sprite_address
		rts

loop_cb:
		rts

; d = tile
; e = start y offset
draw_grid:
		ste	r_y_offset
		std	r_scratch

		lde	#$9
	.loop_next_row:
		lda	#SCREEN_START_X + 12
		ldb	r_y_offset
		RSUB	screen_seek_xy
		leax	$800, x		; jump from fix to layer a

		ldf	#$d
		ldd	r_scratch
	.loop_next_column:
		sta	-$2000, x
		stb	, x
		leax	-$40, x
		decf
		bne	.loop_next_column

		inc	r_y_offset
		dece
		bne	.loop_next_row
		rts

	section data

d_mw_settings:		MW_SETTINGS 16, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb

d_sprite_data:
	dc.b	$ca, $c8, $80, $07, $aa, $ba, $cc, $b8
	dc.b	$cb, $c8, $80, $07, $a8, $e0, $cc, $b8

d_palette_data:
	dc.b	$00, $00, $00, $00, $31, $08, $39, $4a, $45, $ad, $5a, $52, $73, $18, $77, $bd
	dc.b	$67, $39, $4e, $73, $35, $ad, $25, $29, $00, $1c, $ff, $ff, $66, $b5, $3d, $ef
;	dc.b	$67, $39, $4e, $73, $35, $ad, $25, $29, $00, $1c, $00, $0f, $66, $b5, $3d, $ef

	section bss

r_mw_buffer:		dcb.b 16
r_old_highlight:	dcb.w 1
r_y_offset:		dcb.b 1
