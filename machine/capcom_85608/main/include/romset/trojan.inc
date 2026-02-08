CURSOR_CHAR		equ $22 ; ->

CHAR_DASH		equ $ba ; =

SOUND_NUM_SUCCESS	equ $ff ; disabled for now
SOUND_NUM_BIT_ZERO	equ $06
SOUND_NUM_BIT_ONE	equ $03

	ifd _MAME_BUILD_
CTRL_RS_BASE		equ CTRL_SCREEN_FLIP
	else
CTRL_RS_BASE		equ $0
	endif

; bg image viewer
	macro RS_BG_IV_PALETTE_DATA
		dc.b	$00, $66, $55, $44, $33, $00, $44, $00
		dc.b	$00, $00, $00, $00, $03, $02, $22, $33
	endm

	macro RS_BG_IV_PALETTE_EXT_DATA
		dc.b	$00, $50, $40, $30, $20, $00, $40, $00
		dc.b	$00, $00, $00, $00, $40, $30, $10, $30
	endm

; bg tile viewer
	macro RS_BG_TV_PALETTE_DATA
		dc.b	$00, $54, $64, $85, $a6, $45, $76, $54
		dc.b	$65, $43, $88, $77, $66, $55, $44, $11
	endm
	macro RS_BG_TV_PALETTE_EXT_DATA
		dc.b	$00, $00, $00, $00, $00, $50, $40, $30
		dc.b	$40, $20, $80, $70, $60, $50, $40, $10
	endm

; fix tile viewer
	macro RS_FIX_TV_PALETTE_DATA
		dc.b	$06, $0a, $04, $00
	endm
	macro RS_FIX_TV_PALETTE_EXT_DATA
		dc.b	$50, $70, $50, $00
	endm

; sprite viewer
RS_SV_SPRITE_NUM	equ $86
RS_SV_SPRITE_POS_X	equ $60
RS_SV_SPRITE_POS_Y	equ $70
	macro RS_SV_PALETTE_DATA
		dc.b	$df, $20, $ec, $c9, $74, $a7, $86, $04
		dc.b	$06, $07, $a0, $04, $0a, $08, $0a, $00
	endm
	macro RS_SV_PALETTE_EXT_DATA
		dc.b	$f0, $00, $a0, $70, $40, $50, $40, $70
		dc.b	$60, $a0, $00, $40, $c0, $80, $a0, $00
	endm

; sprite debug setup
	macro	RS_SD_SETUP
		; setup initial values
		ld	ix, r_mw_buffer
		ld	(ix + 0), $86
		ld	(ix + 1), $0
		ld	(ix + 2), $70
		ld	(ix + 3), $60
	endm
