; last updated by gen-error-codes on 2026-05-25 @ 02:34 UTC
BG_TILE_RAM_BASE_EC            equ $01
EC_BG_TILE_RAM_ADDRESS         equ $01 ; 000001
EC_BG_TILE_RAM_DATA            equ $02 ; 000010
EC_BG_TILE_RAM_MARCH           equ $03 ; 000011
EC_BG_TILE_RAM_OUTPUT          equ $04 ; 000100
EC_BG_TILE_RAM_WRITE           equ $05 ; 000101

FG_TILE_RAM_BASE_EC            equ $06
EC_FG_TILE_RAM_ADDRESS         equ $06 ; 000110
EC_FG_TILE_RAM_DATA            equ $07 ; 000111
EC_FG_TILE_RAM_MARCH           equ $08 ; 001000
EC_FG_TILE_RAM_OUTPUT          equ $09 ; 001001
EC_FG_TILE_RAM_WRITE           equ $0a ; 001010

FIX_TILE_RAM_BASE_EC           equ $0b
EC_FIX_TILE_RAM_ADDRESS        equ $0b ; 001011
EC_FIX_TILE_RAM_DATA           equ $0c ; 001100
EC_FIX_TILE_RAM_MARCH          equ $0d ; 001101
EC_FIX_TILE_RAM_OUTPUT         equ $0e ; 001110
EC_FIX_TILE_RAM_WRITE          equ $0f ; 001111

PALETTE_RAM_BASE_EC            equ $10
EC_PALETTE_RAM_ADDRESS         equ $10 ; 010000
EC_PALETTE_RAM_DATA            equ $11 ; 010001
EC_PALETTE_RAM_MARCH           equ $12 ; 010010
EC_PALETTE_RAM_OUTPUT          equ $13 ; 010011
EC_PALETTE_RAM_WRITE           equ $14 ; 010100

SPRITE_RAM_BASE_EC             equ $15
EC_SPRITE_RAM_ADDRESS          equ $15 ; 010101
EC_SPRITE_RAM_DATA             equ $16 ; 010110
EC_SPRITE_RAM_MARCH            equ $17 ; 010111
EC_SPRITE_RAM_OUTPUT           equ $18 ; 011000
EC_SPRITE_RAM_WRITE            equ $19 ; 011001

WORK_RAM_BASE_EC               equ $1a
EC_WORK_RAM_ADDRESS            equ $1a ; 011010
EC_WORK_RAM_DATA               equ $1b ; 011011
EC_WORK_RAM_MARCH              equ $1c ; 011100
EC_WORK_RAM_OUTPUT             equ $1d ; 011101
EC_WORK_RAM_WRITE              equ $1e ; 011110
