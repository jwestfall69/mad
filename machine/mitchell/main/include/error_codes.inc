; last updated by gen-error-codes on 2025-07-13 @ 20:17 UTC
SPRITE_RAM_BASE_EC             equ $01
EC_SPRITE_RAM_ADDRESS          equ $01 ; 000001
EC_SPRITE_RAM_DATA             equ $02 ; 000010
EC_SPRITE_RAM_MARCH            equ $03 ; 000011
EC_SPRITE_RAM_OUTPUT           equ $04 ; 000100
EC_SPRITE_RAM_WRITE            equ $05 ; 000101

TILE_RAM_BASE_EC               equ $06
EC_TILE_RAM_ADDRESS            equ $06 ; 000110
EC_TILE_RAM_DATA               equ $07 ; 000111
EC_TILE_RAM_MARCH              equ $08 ; 001000
EC_TILE_RAM_OUTPUT             equ $09 ; 001001
EC_TILE_RAM_WRITE              equ $0a ; 001010

TILE_ATTR_RAM_BASE_EC          equ $0b
EC_TILE_ATTR_RAM_ADDRESS       equ $0b ; 001011
EC_TILE_ATTR_RAM_DATA          equ $0c ; 001100
EC_TILE_ATTR_RAM_MARCH         equ $0d ; 001101
EC_TILE_ATTR_RAM_OUTPUT        equ $0e ; 001110
EC_TILE_ATTR_RAM_WRITE         equ $0f ; 001111

WORK_RAM_BASE_EC               equ $10
EC_WORK_RAM_ADDRESS            equ $10 ; 010000
EC_WORK_RAM_DATA               equ $11 ; 010001
EC_WORK_RAM_MARCH              equ $12 ; 010010
EC_WORK_RAM_OUTPUT             equ $13 ; 010011
EC_WORK_RAM_WRITE              equ $14 ; 010100
