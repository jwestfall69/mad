; last updated by gen-error-codes on 2025-04-16 @ 01:52 UTC
PALETTE_RAM_BASE_EC            equ $01
EC_PALETTE_RAM_ADDRESS         equ $01 ; 000001
EC_PALETTE_RAM_DATA            equ $02 ; 000010
EC_PALETTE_RAM_MARCH           equ $03 ; 000011
EC_PALETTE_RAM_OUTPUT          equ $04 ; 000100
EC_PALETTE_RAM_WRITE           equ $05 ; 000101

SPRITE_RAM_BASE_EC             equ $06
EC_SPRITE_RAM_ADDRESS          equ $06 ; 000110
EC_SPRITE_RAM_DATA             equ $07 ; 000111
EC_SPRITE_RAM_MARCH            equ $08 ; 001000
EC_SPRITE_RAM_OUTPUT           equ $09 ; 001001
EC_SPRITE_RAM_WRITE            equ $0a ; 001010

TILE1_RAM_BASE_EC              equ $0b
EC_TILE1_RAM_ADDRESS           equ $0b ; 001011
EC_TILE1_RAM_DATA              equ $0c ; 001100
EC_TILE1_RAM_MARCH             equ $0d ; 001101
EC_TILE1_RAM_OUTPUT            equ $0e ; 001110
EC_TILE1_RAM_WRITE             equ $0f ; 001111

TILE2_RAM_BASE_EC              equ $10
EC_TILE2_RAM_ADDRESS           equ $10 ; 010000
EC_TILE2_RAM_DATA              equ $11 ; 010001
EC_TILE2_RAM_MARCH             equ $12 ; 010010
EC_TILE2_RAM_OUTPUT            equ $13 ; 010011
EC_TILE2_RAM_WRITE             equ $14 ; 010100

WORK_RAM_BASE_EC               equ $15
EC_WORK_RAM_ADDRESS            equ $15 ; 010101
EC_WORK_RAM_DATA               equ $16 ; 010110
EC_WORK_RAM_MARCH              equ $17 ; 010111
EC_WORK_RAM_OUTPUT             equ $18 ; 011000
EC_WORK_RAM_WRITE              equ $19 ; 011001
