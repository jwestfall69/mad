CURSOR_CHAR			equ '*'
CURSOR_CLEAR_CHAR		equ ' '

; disables beep codes since we don't know
; what sounds to play on a random suicided
; game
SOUND_NUM_BIT_ZERO		equ $ff00
SOUND_NUM_BIT_ONE		equ $ff00
SOUND_NUM_SUCCESS		equ $ff00

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
		; bogus, we just need something thats 6 bytes
		; so error_address will work correctly
		cmpi.l	#$7b5d94f1, d6
	endm


; screen init
	macro RS_SI_PALETTE_SETUP
		; we don't know what color indexes make up the font
		; so we just doing most of them to hopefully get readable
		; text
		lea	SCROLL1_PALETTE + $2, a0
		moveq	#$6, d0

	.loop_next_palette_address:
		move.w	#PALETTE_TEXT_COLOR, ($10,a0)
		move.w	#PALETTE_TEXT_COLOR, (a0)+
		dbra	d0, .loop_next_palette_address

		move.w	#PALETTE_BACKGROUND_COLOR, PALETTE_RAM + $13fe
	endm

; tile viewer
RS_TV_TILE_OFFSET_MASK	equ $ffff
	macro RS_TV_PALETTE_DATA
		dc.w	$fa00, $ff00, $ff67, $ffab, $f028, $f35c, $f57d, $f79e
		dc.w	$f9bf, $f333, $f455, $f688, $f8a8, $fbce, $feff, $ffff
	endm

; sprite debug setup
	macro RS_SD_SETUP
		; highlight for mw
		lea	SCROLL1_PALETTE + PALETTE_SIZE + $2, a0
		moveq	#$6, d0

	.loop_next_palette_address:
		move.w	#$ff00, ($10, a0)
		move.w	#$ff00, (a0)+
		dbra	d0, .loop_next_palette_address
		move.w	#$ff00, SCROLL1_PALETTE + PALETTE_SIZE + $1c

		; init data
		move.l	#$40f00030, r_mw_buffer
		move.l	#$00011200, r_mw_buffer + 4
	endm

; sprite viewer
RS_SV_SPRITE_NUM	equ $1
RS_SV_SPRITE_NUM_MASK	equ $ffff	; ??
RS_SV_SPRITE_POS_X	equ $f0
RS_SV_SPRITE_POS_Y	equ $30
RS_SV_SPRITE_SIZE_X	equ $2
RS_SV_SPRITE_SIZE_Y	equ $1
	macro RS_SV_PALETTE_DATA
		dc.w	$f015, $f048, $f08f, $f851, $fc83, $fec5, $f001, $f223
		dc.w	$f445, $f667, $f778, $f99a, $fbbc, $fdde, $ffff, $f555
	endm
