	include "cpu/68000/include/common.inc"
	include "cpu/68000/include/handlers/values_edit.inc"

	global sprite_viewer
	global sprite_viewer_palette_setup

	section code

sprite_viewer:
		jsr	sprite_viewer_palette_setup

		lea	d_screen_xys_list, a0
		RSUB	print_xy_string_list
		jsr	print_b2_return_to_menu

		move.w	#RS_SV_SPRITE_NUM, r_sprite_num
		move.w	#RS_SV_SPRITE_POS_X, r_sprite_pos_x
		move.w	#RS_SV_SPRITE_POS_Y, r_sprite_pos_y

		clr.b	r_sprite_flip_x
		clr.b	r_sprite_flip_y

		lea	d_ve_settings, a0
		lea	d_ve_list, a1
		jsr	values_edit_handler
		rts

; Per MAME (shared/snk68_spr.cpp)
; * Sprite Format
; * ------------------
; * 1st chunk
; *
; * Byte |  Bit(s)  | Use
; * -----+-76543210-+----------------
; *   0  | xxxxxxxx | 0xff
; *   1  | xxxxxxxx | x position (low 8 bits)
; *   2  | x------- | x position (high bit)
; *   2  | -------x | y position (high bit)
; *   3  | xxxxxxxx | y position (low 8 bits)
; *
; * 2nd chunk
; *
; * Byte |  Bit(s)  | Use
; * -----+-76543210-+----------------
; *   0  | xxxxxxxx | 0xff
; *   1  | xxxxxxxx | palette
; *   2  | x------- | flip y
; *   2  | -x------ | flip x
; *   2  | --x----- | bank? or maybe just another sprite num bit?
; *   2  | ---xxxxx | sprite number (high bits)
; *   3  | xxxxxxxx | sprite number (low bits)
;
; Re-wording how mame has this stated so I better understand it.  It seems
; like these sprites are more like tiles.. There are 3 layers that mame refers
; to as groups 1, 2, 3.  Where display priority is 1 > 3 > 2.  Aside from the
; foreground text the entire game is made of up these sprites.  So for example
; group 2 might just be the ground sprites, group 3 could be the player/enemy
; and group 1 could be bullets
;
; Sprites are broken up into 2 chunks, the first is just the x/y positions,
; these start at address $200004
; $200004 = group 1 sprite chain 1 x/y
; $200008 = group 2 sprite chain 1 x/y
; $20000c = group 3 sprite chain 1 x/y
; skip $70
; $200084 = group 1 sprite chain 2 x/y
; $200088 = group 2 sprite chain 2 x/y
; $20008c = group 3 sprite chain 2 x/y
; skip $70
; $200104 - group 1 sprite chain 3 x/y
; ...
;
; The 2nd chunk is a chained list of 32 32x32 sprites that have the x/y for
; their group + sprite chain applied to them.  This chained list will result
; in either a row (tate screen) or column (normal) of sprites.  Individual
; sprites within the chain can by empty by setting the sprite data to 0x000000.
; So if you just wanted to draw a bullet you could set one of the sprites in
; the chain to be the bullet and then set the remaining sprites in the chain
; to 0x000000.
;
; locations of the chains:
; $201000 = start of group 1 sprite chain 1
; $201080 = start of group 1 sprite chain 2
; $201100 = start of group 1 sprite chain 3
; ...
; $202000 = start of group 2 sprite chain 1
; $202080 = start of group 2 sprite chain 2
; $202100 = start of group 2 sprite chain 3
; ...
; $203000 = start of group 3 sprite chain 1
; $203080 = start of group 3 sprite chain 2
; $203100 = start of group 3 sprite chain 3
; ...
value_changed_cb:
		moveq	#$0, d1
		move.w	r_sprite_pos_x, d0
		btst	#$8, d0
		beq	.skip_sprite_pos_x_high_bit
		move.w	#$8000, d1

	.skip_sprite_pos_x_high_bit:
		and.w	#$ff, d0
		move.w	d0, SPRITE_RAM + 4

		or.w	r_sprite_pos_y, d1
		move.w	d1, SPRITE_RAM + 6

		; 2nd half
		moveq	#$8, d0		; palette num
		move.w	d0, SPRITE_RAM + $1004

		moveq	#$0, d0
		tst.b	r_sprite_flip_x
		beq	.skip_sprite_flip_x
		or.w	#$8000, d0

	.skip_sprite_flip_x:
		tst.b	r_sprite_flip_y
		beq	.skip_sprite_flip_y
		or.w	#$4000, d0

	.skip_sprite_flip_y:
		or.w	r_sprite_num, d0
		move.w	d0, SPRITE_RAM + $1006
		rts

loop_input_cb:
		rts

sprite_viewer_palette_setup:
		lea	d_palette_data, a0
		lea	SPRITE_PALETTE, a1
		moveq	#(PALETTE_SIZE / 2) - 1, d0

	.loop_next_byte:
		move.w	(a0)+, (a1)+
		dbra	d0, .loop_next_byte
		rts

	section data
	align 1

d_ve_settings:
	VE_SETTINGS value_changed_cb, loop_input_cb

d_ve_list:
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_EDGE, r_sprite_num, RS_SV_SPRITE_NUM_MASK
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_x, $1ff
	VE_ENTRY VE_TYPE_WORD, VE_INPUT_RAW, r_sprite_pos_y, $1ff
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_x, $1
	VE_ENTRY VE_TYPE_NIBBLE, VE_INPUT_EDGE, r_sprite_flip_y, $1
	VE_LIST_END

d_palette_data:
	RS_SV_PALETTE_DATA

d_screen_xys_list:
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 2), "SPRITE NUM"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 3), "POS X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 4), "POS Y"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 5), "FLIP X"
	XY_STRING SCREEN_START_X, (SCREEN_START_Y + 6), "FLIP Y"
	XY_STRING_LIST_END

	section bss
	align 1

r_sprite_num:		dcb.w 1
r_sprite_pos_x:		dcb.w 1
r_sprite_pos_y:		dcb.w 1
r_sprite_flip_x:	dcb.b 1
r_sprite_flip_y:	dcb.b 1
