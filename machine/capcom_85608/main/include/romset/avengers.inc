CURSOR_CHAR		equ $27 ; *

CHAR_DASH		equ $2d

SOUND_NUM_SUCCESS	equ $0a
SOUND_NUM_BIT_ZERO	equ $07
SOUND_NUM_BIT_ONE	equ $08

	ifd _MAME_BUILD_
CTRL_RS_BASE		equ $0
	else
CTRL_RS_BASE		equ CTRL_SCREEN_FLIP
	endif

; bg image viewer
	macro RS_BG_IV_PALETTE_DATA
		dc.b	$00, $43, $64, $86, $b8, $db, $ed, $55
		dc.b	$77, $99, $dd, $ed, $ba, $87, $65, $33
	endm

	macro RS_BG_IV_PALETTE_EXT_DATA
		dc.b	$00, $00, $00, $40, $60, $80, $a0, $50
		dc.b	$70, $90, $d0, $90, $70, $50, $40, $30
	endm

; bg tile viewer
	macro RS_BG_TV_PALETTE_DATA
		dc.b	$00, $42, $63, $85, $a7, $c8, $ea, $e7
		dc.b	$95, $74, $53, $31, $13, $24, $46, $57
	endm
	macro RS_BG_TV_PALETTE_EXT_DATA
		dc.b	$00, $20, $30, $50, $70, $b0, $d0, $a0
		dc.b	$20, $20, $00, $00, $20, $30, $50, $60
	endm

; fix tile viewer
	macro RS_FIX_TV_PALETTE_DATA
		dc.b	$06, $0a, $04, $00
	endm
	macro RS_FIX_TV_PALETTE_EXT_DATA
		dc.b	$50, $70, $50, $00
	endm

; sprite viewer
RS_SV_SPRITE_NUM	equ $412
RS_SV_SPRITE_POS_X	equ $80
RS_SV_SPRITE_POS_Y	equ $70
	macro RS_SV_PALETTE_DATA
		dc.b	$15, $32, $fe, $eb, $98, $c4, $83, $a4
		dc.b	$62, $dd, $0c, $09, $07, $38, $26, $00
	endm
	macro RS_SV_PALETTE_EXT_DATA
		dc.b	$90, $20, $a0, $80, $70, $40, $30, $60
		dc.b	$20, $d0, $90, $60, $50, $f0, $d0, $00
	endm

; sprite debug setup
	macro RS_SD_SETUP
		; setup initial values
		ld	ix, r_mw_buffer
		ld	(ix + 0), $12
		ld	(ix + 1), $80
		ld	(ix + 2), $70
		ld	(ix + 3), $90
	endm
