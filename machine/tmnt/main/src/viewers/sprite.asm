	include "cpu/68000/include/common.inc"
	include "global/include/sprite/konami/k051960.inc"

	global sprite_viewer
	global sprite_viewer_palette_setup

	section code

SPRITE_NUM_MASK		equ $1fff

sprite_viewer:
		jsr	sprite_viewer_palette_setup

		; init struct
		lea	r_sprite_struct, a0
		move.w	#$600, s_se_num(a0)
		move.b	#$3, s_se_size(a0)
		clr.b	s_se_zoom_x(a0)
		clr.b	s_se_zoom_y(a0)
		move.w	#$110, s_se_pos_x(a0)
		move.w	#$b0, s_se_pos_y(a0)

		move.w	#SPRITE_NUM_MASK, d0
		lea	draw_sprite_cb, a1
		jsr	sprite_k051960_viewer_handler
		rts

; Per MAME
; * Sprite Format
; * ------------------
; *
; * Byte | Bit(s)   | Use
; * -----+-76543210-+----------------
; *   0  | x------- | active (show this sprite)
; *   0  | -xxxxxxx | priority order
; *   1  | xxx----- | sprite size (see below)
; *   1  | ---xxxxx | sprite code (high 5 bits)
; *   2  | xxxxxxxx | sprite code (low 8 bits)
; *   3  | xxxxxxxx | "color", but depends on external connections (see below)
; *   4  | xxxxxx-- | zoom y (0 = normal, >0 = shrink)
; *   4  | ------x- | flip y
; *   4  | -------x | y position (high bit)
; *   5  | xxxxxxxx | y position (low 8 bits)
; *   6  | xxxxxx-- | zoom x (0 = normal, >0 = shrink)
; *   6  | ------x- | flip x
; *   6  | -------x | x position (high bit)
; *   7  | xxxxxxxx | x position (low 8 bits)
; *
; * Example of "color" field for Punk Shot:
; *   3  | x------- | shadow
; *   3  | -xx----- | priority
; *   3  | ---x---- | use second gfx ROM bank
; *   3  | ----xxxx | color code
; *
; * shadow enables transparent shadows. Note that it applies to pen 0x0f ONLY.
; * The rest of the sprite remains normal.
; * Note that Aliens also uses the shadow bit to select the second sprite bank.
draw_sprite_cb:
		lea	r_sprite_struct, a0

		move.b	#$ff, SPRITE_RAM

		moveq	#$0, d0
		move.b	s_se_size(a0), d0
		lsl.w	#$5, d0
		or.b	s_se_num(a0), d0
		move.b	d0, SPRITE_RAM + 1

		move.w	s_se_num(a0), d0
		move.b	d0, SPRITE_RAM + 2

		clr.b	SPRITE_RAM + 3

		move.b	s_se_zoom_y(a0), d0
		lsl.b	#$2, d0
		or.b	s_se_pos_y(a0), d0
		move.b	d0, SPRITE_RAM + 4

		move.w	s_se_pos_y(a0), d0
		move.b	d0, SPRITE_RAM + 5

		move.b	s_se_zoom_x(a0), d0
		lsl.b	#$2, d0
		or.b	s_se_pos_x(a0), d0
		move.b	d0, SPRITE_RAM + 6

		move.w	s_se_pos_x(a0), d0
		move.b	d0, SPRITE_RAM + 7
		rts

sprite_viewer_palette_setup:
		lea	d_palette_data, a0
		lea	SPRITE_PALETTE, a1
		moveq	#PALETTE_SIZE / 2, d0

	.loop_next_byte:
		addq.l	#$1, a1
		move.b	(a0)+, (a1)+
		dbra	d0, .loop_next_byte
		rts

	section data
	align 1

d_palette_data:
	dc.w	$0000, $0000, $01a0, $028d, $0374, $018e, $01f2, $0276
	dc.w	$029b, $6a55, $6611, $7ee0, $35ad, $5294, $6b5a, $2d6b

	section bss
	align 1

r_sprite_struct:	dc.b s_se_struct_size
