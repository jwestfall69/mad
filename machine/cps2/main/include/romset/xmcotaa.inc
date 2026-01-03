CURSOR_CHAR			equ '*'
CURSOR_CLEAR_CHAR		equ ' '

SOUND_NUM_BIT_ZERO		equ $101
SOUND_NUM_BIT_ONE		equ $111
SOUND_NUM_SUCCESS		equ $04

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
		cmpi.l	#$19720301, d0
	endm

; screen init
	macro RS_SI_PALETTE_SETUP
		move.w	#PALETTE_TEXT_COLOR, SCROLL1_PALETTE
		move.w	#PALETTE_TEXT_COLOR, SCROLL1_PALETTE + $2
		move.w	#PALETTE_TEXT_COLOR, SCROLL1_PALETTE + $4
		move.w	#PALETTE_TEXT_COLOR, SCROLL1_PALETTE + $6
		move.w	#PALETTE_TEXT_COLOR, SCROLL1_PALETTE + $8
		move.w	#PALETTE_TEXT_COLOR, SCROLL1_PALETTE + $a
		move.w	#PALETTE_TEXT_COLOR, SCROLL1_PALETTE + $c
		move.w	#PALETTE_TEXT_SHADOW_COLOR, SCROLL1_PALETTE + $10
		move.w	#PALETTE_BACKGROUND_COLOR, PALETTE_RAM + $13fe
	endm

; tile viewer
RS_TV_TILE_OFFSET_MASK	equ $ffff
	macro RS_TV_PALETTE_DATA
		dc.w	$ff70, $ff94, $ffc5, $fff3, $fce7, $f7c9, $f4ab, $f35e
		dc.w	$f31b, $f53b, $f75c, $f98d, $fbad, $fdce, $ffff, $fbdf
	endm

; sprite debug setup
	macro RS_SD_SETUP
		; highlight for mw
		move.w	#$ff00, SCROLL1_PALETTE + PALETTE_SIZE
		move.w	#$ff00, SCROLL1_PALETTE + PALETTE_SIZE + $2
		move.w	#$ff00, SCROLL1_PALETTE + PALETTE_SIZE + $4
		move.w	#$ff00, SCROLL1_PALETTE + PALETTE_SIZE + $6
		move.w	#$ff00, SCROLL1_PALETTE + PALETTE_SIZE + $8
		move.w	#$ff00, SCROLL1_PALETTE + PALETTE_SIZE + $a
		move.w	#$ff00, SCROLL1_PALETTE + PALETTE_SIZE + $c

		; init data
		move.l	#$40f00030, r_mw_buffer
		move.l	#$0b554200, r_mw_buffer + 4
	endm

; sprite viewer
RS_SV_SPRITE_NUM	equ $b55
RS_SV_SPRITE_NUM_MASK	equ $ffff	; ??
RS_SV_SPRITE_POS_X	equ $f0
RS_SV_SPRITE_POS_Y	equ $30
RS_SV_SPRITE_SIZE_X	equ $2
RS_SV_SPRITE_SIZE_Y	equ $4
	macro RS_SV_PALETTE_DATA
		dc.w	$f06f, $f00e, $f00b, $f007, $f004, $ffe0, $ffc0, $fd90
		dc.w	$fa60, $f840, $fec9, $fca7, $fa85, $ff00, $f000, $f399
	endm
