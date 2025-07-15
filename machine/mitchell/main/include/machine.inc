	include "global/include/oki/msm6295.inc"
	include "romset.inc"

ROM_START			equ $0
ROM_SIZE			equ $8000

TILE_ATTR_RAM			equ $c800
TILE_ATTR_RAM_SIZE		equ $800
TILE_ATTR_RAM_ADDRESS_LINES	equ 11

SPRITE_RAM			equ $d000
SPRITE_RAM_SIZE			equ $1000
SPRITE_RAM_ADDRESS_LINES	equ 12
; tiles and sprite share the same palettes
; so just making sprites use number 3
SPRITE_PALETTE_NUM		equ 3
SPRITE_PALETTE			equ PALETTE_RAM + (SPRITE_PALETTE_NUM * PALETTE_SIZE)

PALETTE_RAM			equ $c000
PALETTE_RAM_SIZE		equ $800
PALETTE_RAM_ADDRESS_LINES	equ 11
PALETTE_SIZE			equ $20

; sprite/tile ram are the same address space
; and have to be bank switched to switch
; between them
TILE_RAM			equ $d000
TILE_RAM_SIZE			equ $1000
TILE_RAM_ADDRESS_LINES		equ 12
TILE_PALETTE			equ PALETTE_RAM

WORK_RAM_CHIP			equ $e000
WORK_RAM_CHIP_SIZE		equ $2000
WORK_RAM_CHIP_ADDRESS_LINES	equ 13

WORK_RAM			equ WORK_RAM_CHIP
WORK_RAM_SIZE			equ WORK_RAM_CHIP_SIZE

IO_INPUT_P1			equ $01
IO_INPUT_P2			equ $02
IO_INPUT_SYS1			equ $00
IO_INPUT_SYS2			equ $05
SYS2_VBLANK			equ $01
SYS2_PALETTE_WRITE_READY	equ $08

IO_CONTROL			equ $00
CTRL_PALETTE_BANK0		equ $00
CTRL_PALETTE_BANK1		equ $20
CTRL_PALETTE_WRITE_REQUEST	equ $08
CTRL_ENABLE_TILE_ROMS		equ $40
CTRL_ENABLE_SPRITE_ROMS		equ $80

IO_ROM_BANK			equ $02

IO_SPRITE_COPY_REQUEST		equ $06

IO_VIDEO_BANK			equ $07
VIDEO_BANK_TILE			equ $0
VIDEO_BANK_SPRITE		equ $1

IO_YM2413_DATA			equ $03
IO_YM2413_ADDRESS		equ $04
IO_MSM6295			equ $05

	macro WATCHDOG
	endm

	; we are only allowed to use a/de registers
	macro SOUND_PLAY
		or	MSM6295_PHRASE_SEL
		out	(IO_MSM6295), a
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		nop
		ld	a, MSM6295_CHANNEL4 << 4
		out	(IO_MSM6295), a
	endm

	macro SOUND_STOP
		ld	a, MSM6295_CHANNEL4 << 3
		out	(IO_MSM6295), a
	endm
