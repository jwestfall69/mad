CURSOR_CHAR			equ '*'
CURSOR_CLEAR_CHAR		equ ' '

SOUND_NUM_BIT_ZERO		equ $f4
SOUND_NUM_BIT_ONE		equ $ef
SOUND_NUM_SUCCESS		equ $25

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
		cmpi.w	#$1019, $4000
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
		dc.w	$ff70, $ff60, $ff50, $ff40, $fe30, $fd20, $fc20, $feef
		dc.w	$fccd, $fbbc, $f99a, $f778, $f445, $f11f, $f111, $f966
		dc.w	$f974, $f863, $f752, $f642, $f532, $f580, $f460, $f340
		dc.w	$f653, $f8b8, $f8a7, $f896, $f886, $f775, $f764, $ff98
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
		move.l	#$00014100, r_mw_buffer + 4
	endm

; sprite viewer
RS_SV_SPRITE_NUM	equ $1
RS_SV_SPRITE_NUM_MASK	equ $ffff	; ??
RS_SV_SPRITE_POS_X	equ $f0
RS_SV_SPRITE_POS_Y	equ $30
RS_SV_SPRITE_SIZE_X	equ $1
RS_SV_SPRITE_SIZE_Y	equ $4
	macro RS_SV_PALETTE_DATA
		dc.w	$f111, $ffd9, $fea6, $fc62, $f950, $f530, $fabc, $f788
		dc.w	$f566, $f443, $feff, $f670, $f550, $f530, $ff56, $f0bb
	endm
