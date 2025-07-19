	include "cpu/6309/include/common.inc"
	include "cpu/6x09/include/handlers/values_edit.inc"

	global sprite_viewer
	global sprite_viewer_palette_setup

	section code

sprite_viewer:
		jsr	sprite_viewer_palette_setup

		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		ldd	#$b4
		std	r_sprite_num

		ldd	#$60
		std	r_sprite_pos_x

		lda	#$90
		sta	r_sprite_pos_y

		lda	#$4
		sta	r_sprite_size

		ldd	#$80
		std	r_sprite_zoom

		clra
		sta	r_sprite_flip_x
		sta	r_sprite_flip_y

		ldx	#d_ve_settings
		ldy	#d_ve_list

		jsr	values_edit_handler
		rts

; Per MAME (k007420)
; * Sprite Format
; * ------------------
; *
; * Byte | Bit(s)   | Use
; * -----+-76543210-+----------------
; *   0  | xxxxxxxx | y position
; *   1  | xxxxxxxx | sprite number (low 8 bits)
; *   2  | xxxxxxxx | depends on external conections. Usually banking
; *   3  | xxxxxxxx | x position (low 8 bits)
; *   4  | x------- | x position (high bit)
; *   4  | -xxx---- | sprite size 000=16x16 001=8x16 010=16x8 011=8x8 100=32x32
; *   4  | ----x--- | flip y
; *   4  | -----x-- | flip x
; *   4  | ------xx | zoom (bits 8 & 9)
; *   5  | xxxxxxxx | zoom (low 8 bits)  0x080 = normal, < 0x80 enlarge, > 0x80 reduce
; *   6  | xxxxxxxx | unused
; *   7  | xxxxxxxx | unused
value_changed_cb:
		lda	r_sprite_pos_y
		sta	SPRITE_RAM

		; sprite num is limited to $1ff. Lower byte goes to
		; sprite ram.  Bit 8 picks bank 0/1 via bit 7 of
		; REG_CONTROL
		ldd	r_sprite_num
		stb	SPRITE_RAM + 1

		asra
		rora
		sta	REG_CONTROL

		ldd	r_sprite_pos_x
		stb	SPRITE_RAM + 3

		cmpa	#$0
		beq	.skip_sprite_num_high_bit
		lda	#$80

	.skip_sprite_num_high_bit:
		ldb	r_sprite_size
		aslb
		aslb
		aslb
		aslb
		stb	r_scratch
		ora	r_scratch
		ldb	r_sprite_flip_y
		beq	.skip_sprite_flip_y
		ora	#$08
	.skip_sprite_flip_y:

		ldb	r_sprite_flip_x
		beq	.skip_sprite_flip_x
		ora	#$04
	.skip_sprite_flip_x:

		; top 2 bits of zoom
		ora	r_sprite_zoom
		sta	SPRITE_RAM + 4
		lda	r_sprite_zoom + 1
		sta	SPRITE_RAM + 5
		rts

loop_input_cb:
		rts

sprite_viewer_palette_setup:
		ldx	#d_palette_data
		ldy	#SPRITE_PALETTE
		ldb	#PALETTE_SIZE

	.loop_next_byte:
		lda	,x+
		sta	,y+
		decb
		bne	.loop_next_byte
		rts

	section data

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, $1ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_size, $7
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_zoom, $3ff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $1ff
	VE_ENTRY VE_TYPE_BYTE, VE_INPUT_RAW, r_sprite_pos_y, $ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_x, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_y, $1
	VE_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "SIZE"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "ZOOM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "FLIP X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 8), "FLIP Y"
	XY_STRING_LIST_END

d_palette_data:
	dc.w	$0000, $0400, $429c, $31f9, $00f0, $4621, $001f, $77bd
	dc.w	$03ff, $3800, $7500, $6810, $0340, $01e0, $001f, $0010

	section bss

r_sprite_num:		dcb.w 1
r_sprite_size:		dcb.b 1
r_sprite_zoom:		dcb.w 1
r_sprite_pos_x:		dcb.w 1
r_sprite_pos_y:		dcb.b 1
r_sprite_flip_x:	dcb.b 1
r_sprite_flip_y:	dcb.b 1
