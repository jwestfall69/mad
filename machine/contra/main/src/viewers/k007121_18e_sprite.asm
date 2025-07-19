	include "cpu/6309/include/common.inc"
	include "cpu/6x09/include/handlers/values_edit.inc"

	global k007121_18e_sprite_viewer
	global k007121_18e_sprite_viewer_palette_setup

	section code

k007121_18e_sprite_viewer:
		jsr	k007121_18e_sprite_viewer_palette_setup

		ldy	#d_screen_xys_list
		jsr	print_xy_string_list

		ldd	#$2068
		std	r_sprite_num

		ldd	#$50
		std	r_sprite_pos_x

		lda	#$70
		sta	r_sprite_pos_y

		lda	#$4
		sta	r_sprite_size

		clra
		sta	r_sprite_flip_x
		sta	r_sprite_flip_y

		lda	#$b6
		sta	REG_K007121_18E_C3

		ldx	#d_ve_settings
		ldy	#d_ve_list

		jsr	values_edit_handler
		rts

; Per MAME (k007121)
; * Sprite Format
; * ------------------
; *
; * There are 0x40 sprites, each one using 5 bytes. However the number of
; * sprites can be increased to 0x80 with a control register (Combat School
; * sets it on and off during the game).
; *
; * Byte | Bit(s)   | Use
; * -----+-76543210-+----------------
; *   0  | xxxxxxxx | sprite code
; *   1  | xxxx---- | color
; *   1  | ----xx-- | sprite code low 2 bits for 16x8/8x8 sprites
; *   1  | ------xx | sprite code bank bits 1/0
; *   2  | xxxxxxxx | y position
; *   3  | xxxxxxxx | x position (low 8 bits)
; *   4  | xx------ | sprite code bank bits 3/2
; *   4  | --x----- | flip y
; *   4  | ---x---- | flip x
; *   4  | ----xxx- | sprite size 000=16x16 001=16x8 010=8x16 011=8x8 100=32x32
; *   4  | -------x | x position (high bit)
value_changed_cb:
		ldd	r_sprite_num
		stb	K007121_18E_SPRITE

		tfr	a, b
		andb	#$f
		stb	K007121_18E_SPRITE + 1

		anda	#$f0
		asla
		asla

		ldb	r_sprite_flip_y
		beq	.skip_sprite_flip_y
		ora	#$20
	.skip_sprite_flip_y:

		ldb	r_sprite_flip_x
		beq	.skip_sprite_flip_x
		ora	#$10
	.skip_sprite_flip_x:

		ldb	r_sprite_size
		aslb
		stb	r_scratch
		ora	r_scratch
		ora	r_sprite_pos_x
		sta	K007121_18E_SPRITE + 4

		lda	r_sprite_pos_x + 1
		sta	K007121_18E_SPRITE + 3
		lda	r_sprite_pos_y
		sta	K007121_18E_SPRITE + 2
		rts

loop_input_cb:
		rts

; Palette Layout
;  xBBB BBGG GGGR RRRR
k007121_18e_sprite_viewer_palette_setup:
		ldx	#d_palette_data
		ldy	#K007121_18E_SPRITE_PALETTE
		ldb	#PALETTE_SIZE

	.loop_next_color:
		lda	,x+
		sta	,y+
		decb
		bne	.loop_next_color
		rts


	section data

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, $3fff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_size, $7
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $1ff
	VE_ENTRY VE_TYPE_BYTE, VE_INPUT_RAW, r_sprite_pos_y, $ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_x, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_y, $1
	VE_LIST_END

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "SIZE"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "FLIP X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 7), "FLIP Y"
	XY_STRING_LIST_END

d_palette_data:
	dc.w	$0000, $c05d, $ae01, $712d, $b435, $1742, $584e, $4b01
	dc.w	$ae31, $5246, $b556, $1900, $1902, $be3a, $9c73, $0004

	section bss

r_sprite_num:		dcb.w 1
r_sprite_size:		dcb.b 1
r_sprite_pos_x:		dcb.w 1
r_sprite_pos_y:		dcb.b 1
r_sprite_flip_x:	dcb.b 1
r_sprite_flip_y:	dcb.b 1
