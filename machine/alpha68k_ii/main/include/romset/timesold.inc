CURSOR_CHAR		equ '*'
CURSOR_CLEAR_CHAR	equ ' '

SOUND_NUM_SUCCESS	equ $1f
SOUND_NUM_BIT_ZERO	equ $44		; low pitch sound
SOUND_NUM_BIT_ONE	equ $5a		; high pitch sound

; video dac
VD_TILE_B0_NUM		equ $11
VD_TILE_B0_PAL_OFFSET	equ $2
VD_TILE_B1_NUM		equ $12
VD_TILE_B1_PAL_OFFSET	equ $4
VD_TILE_B2_NUM		equ $13
VD_TILE_B2_PAL_OFFSET	equ $6
VD_TILE_B3_NUM		equ $14
VD_TILE_B3_PAL_OFFSET	equ $8
VD_TILE_BA_NUM		equ $15		; all bits enabled
VD_TILE_BA_PAL_OFFSET	equ $a

; screen init
	macro RS_SI_PALETTE_SETUP
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM + $2
		move.w	#PALETTE_TEXT_SHADOW_COLOR, PALETTE_RAM + $a
	endm

; sprite debug setup
	macro RS_SD_SETUP
		; highlight for mw
		move.w	#$f00, TILE_PALETTE + PALETTE_SIZE + $2

		; init data
		move.l	#$ff2c81d7, r_mw_buffer
		move.l	#$ff080e9e, r_mw_buffer + 4
	endm

; sprite viewer
RS_SV_SPRITE_NUM	equ $e9e
RS_SV_SPRITE_NUM_MASK	equ $1fff
RS_SV_SPRITE_POS_X	equ $130
RS_SV_SPRITE_POS_Y	equ $1a0
	macro RS_SV_PALETTE_DATA
		dc.w	$0666, $3fc6, $5a73, $0511, $0311, $0eec, $1aa8, $1664
		dc.w	$6fd0, $1d92, $2952, $121d, $1107, $0fff, $6332, $0000
	endm

; tile viewer
RS_TV_TILE_OFFSET_MASK	equ $7fff
	macro RS_TV_PALETTE_DATA
		dc.w	$0000, $7fff, $0999, $0777, $0555, $0444, $479F, $0ff0
		dc.w	$27ed, $050a, $0d00, $7f8d, $5f27, $4f03, $0002, $0000
	endm
