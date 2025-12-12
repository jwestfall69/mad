CURSOR_CHAR		equ '*'
CURSOR_CLEAR_CHAR	equ ' '

SOUND_NUM_SUCCESS	equ $13
SOUND_NUM_BIT_ZERO	equ $25		; low pitch sound
SOUND_NUM_BIT_ONE	equ $24		; high pitch sound

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
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM + $4
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM + $6
	endm

; sprite debug setup
	macro RS_SD_SETUP
		; highlight for mw
		move.w	#$f00, TILE_PALETTE + PALETTE_SIZE + $2
		move.w	#$f00, TILE_PALETTE + PALETTE_SIZE + $4
		move.w	#$f00, TILE_PALETTE + PALETTE_SIZE + $6

		; init data
		move.l	#$ff2c81d7, r_mw_buffer
		move.l	#$ff08340c, r_mw_buffer + 4
	endm

; sprite viewer
RS_SV_SPRITE_NUM	equ $340c
RS_SV_SPRITE_NUM_MASK	equ $3fff
RS_SV_SPRITE_POS_X	equ $130
RS_SV_SPRITE_POS_Y	equ $1a0
	macro RS_SV_PALETTE_DATA
		dc.w	$0aaa, $7fff, $0fcc, $3a56, $7602, $0221, $4f00, $0a00
		dc.w	$4600, $0300, $1a02, $305f, $002a, $000a, $7fff, $0000
	endm

; tile viewer
RS_TV_TILE_OFFSET_MASK	equ $7ff
	macro RS_TV_PALETTE_DATA
		dc.w	$0000, $7fff, $0ddd, $7aaa, $8fff, $0002, $cf60, $0180
		dc.w	$6f70, $6f90, $00b3, $2073, $000f, $000c, $0008, $4005
	endm
