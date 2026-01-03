CURSOR_CHAR			equ '*'
CURSOR_CLEAR_CHAR		equ ' '

SOUND_NUM_BIT_ZERO		equ $44
SOUND_NUM_BIT_ONE		equ $4a
SOUND_NUM_SUCCESS		equ $1e

; video dac
VD_TILE_B0_NUM			equ $11
VD_TILE_B0_PAL_OFFSET		equ $0
VD_TILE_B1_NUM			equ $12
VD_TILE_B1_PAL_OFFSET		equ $2
VD_TILE_B2_NUM			equ $13
VD_TILE_B2_PAL_OFFSET		equ $4
VD_TILE_B3_NUM			equ $14
VD_TILE_B3_PAL_OFFSET		equ $6
VD_TILE_BA_NUM			equ $15
VD_TILE_BA_PAL_OFFSET		equ $8

	macro WATCHDOG
		cmpi.l	#$951101, d1
	endm

; screen init
	macro RS_SI_PALETTE_SETUP
		move.w	#PALETTE_TEXT_COLOR, SCROLL1_PALETTE + $4
		move.w	#PALETTE_TEXT_COLOR, SCROLL1_PALETTE + $6
		move.w	#PALETTE_TEXT_COLOR, SCROLL1_PALETTE + $8
		move.w	#PALETTE_TEXT_COLOR, SCROLL1_PALETTE + $a
		move.w	#PALETTE_TEXT_SHADOW_COLOR, SCROLL1_PALETTE + $e
		move.w	#PALETTE_BACKGROUND_COLOR, PALETTE_RAM + $13fe
	endm

; tile viewer
RS_TV_TILE_OFFSET_MASK	equ $ffff
	macro RS_TV_PALETTE_DATA
		dc.w	$ffff, $feeb, $fdd7, $fdd3, $fbb3, $f991, $f881, $f761
		dc.w	$f741, $ffab, $fc89, $fa67, $f846, $f423, $f000, $f000
	endm

; sprite debug setup
	macro RS_SD_SETUP
		; highlight for mw
		move.w	#$ff00, SCROLL1_PALETTE + PALETTE_SIZE + $4
		move.w	#$ff00, SCROLL1_PALETTE + PALETTE_SIZE + $6
		move.w	#$ff00, SCROLL1_PALETTE + PALETTE_SIZE + $8
		move.w	#$ff00, SCROLL1_PALETTE + PALETTE_SIZE + $a

		; init data
		move.l	#$40802060, r_mw_buffer
		move.l	#$62d81100, r_mw_buffer + 4
	endm

; sprite viewer
RS_SV_SPRITE_NUM	equ $162d8
RS_SV_SPRITE_POS_X	equ $e0
RS_SV_SPRITE_POS_Y	equ $60
RS_SV_SPRITE_SIZE_X	equ $1
RS_SV_SPRITE_SIZE_Y	equ $1
	macro RS_SV_PALETTE_DATA
		dc.w	$fcfa, $f9d6, $f693, $f060, $ffff, $f99d, $f66b, $f007
		dc.w	$feff, $fbdd, $f8aa, $f577, $f8df, $f6af, $f47d, $f531
	endm
