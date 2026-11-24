CURSOR_CHAR		equ $6e
CURSOR_CLEAR_CHAR	equ ' '

SOUND_NUM_SUCCESS	equ $5a
SOUND_NUM_BIT_ZERO	equ $bf
SOUND_NUM_BIT_ONE	equ $c4

; screen init
	macro RS_SI_PALETTE_SETUP
		move.w	#PALETTE_TEXT_COLOR, TILE_PALETTE_BASE + $6 ; needed for dash in header
		move.w	#PALETTE_TEXT_COLOR, TILE_PALETTE_BASE + $c
	endm

; sprite debug setup
	macro RS_SD_SETUP
		; highlight for mw
		move.w	#$f00, TILE_PALETTE_BASE + PALETTE_ENTRY_SIZE + $c

		; init data
		move.l	#$ff0a09b0, r_mw_buffer
		move.l	#$ff0801f3, r_mw_buffer + 4
	endm

; sprite viewer
RS_SV_SPRITE_NUM	equ $1f3
RS_SV_SPRITE_NUM_MASK	equ $3fff
RS_SV_SPRITE_POS_X	equ $70
RS_SV_SPRITE_POS_Y	equ $190
	macro RS_SV_PALETTE_DATA
		dc.w	$0000, $4c96, $5a63, $2732, $4400, $0000, $00b0, $6510
		dc.w	$2430, $2841, $2060, $0040, $7444, $0888, $7bbb, $0b00
	endm

; tile viewer
RS_TV_TILE_OFFSET_MASK	equ $7ff
	macro RS_TV_PALETTE_DATA
		dc.w	$0000, $0876, $5864, $3743, $4500, $0000, $7fff, $4540
		dc.w	$0555, $7fff, $7fff, $0e00, $7444, $7333, $0800, $0600
	endm
