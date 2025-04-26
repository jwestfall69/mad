ROMSET_LAYER_CTRL		equ $12e2
ROMSET_VIDEO_CTRL		equ $003e
ROMSET_PALETTE_CTRL		equ $003e

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

	macro ROMSET_INIT
		move.w	#$0, $8040a0
		move.w	#$7000, $fffff0
		move.w	#$807d, $fffff2
		move.w	#$0, $fffff4
		move.w	#$0, $fffff6
		move.w	#$0, $fffff8
		move.w	#$0, $fffffa
	endm

	macro ROMSET_PALLETE_SETUP
		lea	PALETTE_RAM_START + $2, a0
		moveq	#$6, d0

	.loop_next_palette_address:
		move.w	#PALETTE_TEXT_COLOR, ($10,a0)
		move.w	#PALETTE_TEXT_COLOR, (a0)+
		dbra	d0, .loop_next_palette_address

		move.w	#PALETTE_BACKGROUND_COLOR, PALETTE_RAM_START + $13fe
	endm

	macro WATCHDOG
		; bogus, we just need something thats 6 bytes
		; so error_address will work correctly
		cmpi.l	#$7b5d94f1, d6
	endm

