CURSOR_CHAR			equ '*'
CURSOR_CLEAR_CHAR		equ ' '

SOUND_NUM_BIT_ZERO		equ $103
SOUND_NUM_BIT_ONE		equ $102
SOUND_NUM_SUCCESS		equ $05

; video dac
VD_TILE_B0_NUM			equ $10
VD_TILE_B0_PAL_OFFSET		equ $0
VD_TILE_B1_NUM			equ $11
VD_TILE_B1_PAL_OFFSET		equ $2
VD_TILE_B2_NUM			equ $12
VD_TILE_B2_PAL_OFFSET		equ $4
VD_TILE_B3_NUM			equ $13
VD_TILE_B3_PAL_OFFSET		equ $6
VD_TILE_BA_NUM			equ $14
VD_TILE_BA_PAL_OFFSET		equ $8


	macro WATCHDOG
		cmpi.l	#$726a4baf, d0
	endm

; screen init
	macro RS_SI_PALETTE_SETUP
		move.w	#PALETTE_TEXT_COLOR, SCROLL1_PALETTE
		move.w	#PALETTE_TEXT_COLOR, SCROLL1_PALETTE + $2
		move.w	#PALETTE_TEXT_COLOR, SCROLL1_PALETTE + $4
		move.w	#PALETTE_TEXT_COLOR, SCROLL1_PALETTE + $6
		move.w	#PALETTE_TEXT_COLOR, SCROLL1_PALETTE + $8
		move.w	#PALETTE_BACKGROUND_COLOR, PALETTE_RAM + $13fe
	endm

; tile viewer
RS_TV_TILE_OFFSET_MASK	equ $ffff
	macro RS_TV_PALETTE_DATA
		dc.w	$f00c, $f779, $f994, $fcc2, $fff0, $f00a, $f008, $f006
		dc.w	$f005, $f004, $f002, $f111, $f0f6, $f0f6, $f0f6, $f000
	endm

; sprite debug setup
	macro RS_SD_SETUP
		; highlight for mw
		move.w	#$ff00, SCROLL1_PALETTE + PALETTE_SIZE
		move.w	#$ff00, SCROLL1_PALETTE + PALETTE_SIZE + $2
		move.w	#$ff00, SCROLL1_PALETTE + PALETTE_SIZE + $4
		move.w	#$ff00, SCROLL1_PALETTE + PALETTE_SIZE + $6
		move.w	#$ff00, SCROLL1_PALETTE + PALETTE_SIZE + $8

		; init data
		move.l	#$40f00030, r_mw_buffer
		move.l	#$02153500, r_mw_buffer + 4
	endm

; sprite viewer
RS_SV_SPRITE_NUM	equ $215
RS_SV_SPRITE_NUM_MASK	equ $ffff	; ??
RS_SV_SPRITE_POS_X	equ $f0
RS_SV_SPRITE_POS_Y	equ $30
RS_SV_SPRITE_SIZE_X	equ $5
RS_SV_SPRITE_SIZE_Y	equ $3
	macro RS_SV_PALETTE_DATA
		dc.w	$f111, $f435, $f557, $f579, $f78b, $f9ac, $fdce, $ffef
		dc.w	$f83d, $f639, $f227, $f960, $fea0, $fff8, $ff99, $f000
	endm
