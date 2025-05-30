; last updated by gen-error-codes on 2025-03-21 @ 21:11 UTC
PALETTE_RAM_BASE_EC            equ $01
EC_PALETTE_RAM_ADDRESS         equ $01 ; 0000001
EC_PALETTE_RAM_DATA_LOWER      equ $02 ; 0000010
EC_PALETTE_RAM_DATA_UPPER      equ $03 ; 0000011
EC_PALETTE_RAM_DATA_BOTH       equ $04 ; 0000100
EC_PALETTE_RAM_MARCH_LOWER     equ $05 ; 0000101
EC_PALETTE_RAM_MARCH_UPPER     equ $06 ; 0000110
EC_PALETTE_RAM_MARCH_BOTH      equ $07 ; 0000111
EC_PALETTE_RAM_OUTPUT_LOWER    equ $08 ; 0001000
EC_PALETTE_RAM_OUTPUT_UPPER    equ $09 ; 0001001
EC_PALETTE_RAM_OUTPUT_BOTH     equ $0a ; 0001010
EC_PALETTE_RAM_WRITE_LOWER     equ $0b ; 0001011
EC_PALETTE_RAM_WRITE_UPPER     equ $0c ; 0001100
EC_PALETTE_RAM_WRITE_BOTH      equ $0d ; 0001101

PALETTE_EXT_RAM_BASE_EC        equ $0e
EC_PALETTE_EXT_RAM_ADDRESS     equ $0e ; 0001110
EC_PALETTE_EXT_RAM_DATA_LOWER  equ $0f ; 0001111
EC_PALETTE_EXT_RAM_DATA_UPPER  equ $10 ; 0010000
EC_PALETTE_EXT_RAM_DATA_BOTH   equ $11 ; 0010001
EC_PALETTE_EXT_RAM_MARCH_LOWER equ $12 ; 0010010
EC_PALETTE_EXT_RAM_MARCH_UPPER equ $13 ; 0010011
EC_PALETTE_EXT_RAM_MARCH_BOTH  equ $14 ; 0010100
EC_PALETTE_EXT_RAM_OUTPUT_LOWER equ $15 ; 0010101
EC_PALETTE_EXT_RAM_OUTPUT_UPPER equ $16 ; 0010110
EC_PALETTE_EXT_RAM_OUTPUT_BOTH equ $17 ; 0010111
EC_PALETTE_EXT_RAM_WRITE_LOWER equ $18 ; 0011000
EC_PALETTE_EXT_RAM_WRITE_UPPER equ $19 ; 0011001
EC_PALETTE_EXT_RAM_WRITE_BOTH  equ $1a ; 0011010

SPRITE_RAM_BASE_EC             equ $1b
EC_SPRITE_RAM_ADDRESS          equ $1b ; 0011011
EC_SPRITE_RAM_DATA_LOWER       equ $1c ; 0011100
EC_SPRITE_RAM_DATA_UPPER       equ $1d ; 0011101
EC_SPRITE_RAM_DATA_BOTH        equ $1e ; 0011110
EC_SPRITE_RAM_MARCH_LOWER      equ $1f ; 0011111
EC_SPRITE_RAM_MARCH_UPPER      equ $20 ; 0100000
EC_SPRITE_RAM_MARCH_BOTH       equ $21 ; 0100001
EC_SPRITE_RAM_OUTPUT_LOWER     equ $22 ; 0100010
EC_SPRITE_RAM_OUTPUT_UPPER     equ $23 ; 0100011
EC_SPRITE_RAM_OUTPUT_BOTH      equ $24 ; 0100100
EC_SPRITE_RAM_WRITE_LOWER      equ $25 ; 0100101
EC_SPRITE_RAM_WRITE_UPPER      equ $26 ; 0100110
EC_SPRITE_RAM_WRITE_BOTH       equ $27 ; 0100111

TILE1_RAM_BASE_EC              equ $28
EC_TILE1_RAM_ADDRESS           equ $28 ; 0101000
EC_TILE1_RAM_DATA_LOWER        equ $29 ; 0101001
EC_TILE1_RAM_DATA_UPPER        equ $2a ; 0101010
EC_TILE1_RAM_DATA_BOTH         equ $2b ; 0101011
EC_TILE1_RAM_MARCH_LOWER       equ $2c ; 0101100
EC_TILE1_RAM_MARCH_UPPER       equ $2d ; 0101101
EC_TILE1_RAM_MARCH_BOTH        equ $2e ; 0101110
EC_TILE1_RAM_OUTPUT_LOWER      equ $2f ; 0101111
EC_TILE1_RAM_OUTPUT_UPPER      equ $30 ; 0110000
EC_TILE1_RAM_OUTPUT_BOTH       equ $31 ; 0110001
EC_TILE1_RAM_WRITE_LOWER       equ $32 ; 0110010
EC_TILE1_RAM_WRITE_UPPER       equ $33 ; 0110011
EC_TILE1_RAM_WRITE_BOTH        equ $34 ; 0110100

TILE2_RAM_BASE_EC              equ $35
EC_TILE2_RAM_ADDRESS           equ $35 ; 0110101
EC_TILE2_RAM_DATA_LOWER        equ $36 ; 0110110
EC_TILE2_RAM_DATA_UPPER        equ $37 ; 0110111
EC_TILE2_RAM_DATA_BOTH         equ $38 ; 0111000
EC_TILE2_RAM_MARCH_LOWER       equ $39 ; 0111001
EC_TILE2_RAM_MARCH_UPPER       equ $3a ; 0111010
EC_TILE2_RAM_MARCH_BOTH        equ $3b ; 0111011
EC_TILE2_RAM_OUTPUT_LOWER      equ $3c ; 0111100
EC_TILE2_RAM_OUTPUT_UPPER      equ $3d ; 0111101
EC_TILE2_RAM_OUTPUT_BOTH       equ $3e ; 0111110
EC_TILE2_RAM_WRITE_LOWER       equ $3f ; 0111111
EC_TILE2_RAM_WRITE_UPPER       equ $40 ; 1000000
EC_TILE2_RAM_WRITE_BOTH        equ $41 ; 1000001

TILE3_RAM_BASE_EC              equ $42
EC_TILE3_RAM_ADDRESS           equ $42 ; 1000010
EC_TILE3_RAM_DATA_LOWER        equ $43 ; 1000011
EC_TILE3_RAM_DATA_UPPER        equ $44 ; 1000100
EC_TILE3_RAM_DATA_BOTH         equ $45 ; 1000101
EC_TILE3_RAM_MARCH_LOWER       equ $46 ; 1000110
EC_TILE3_RAM_MARCH_UPPER       equ $47 ; 1000111
EC_TILE3_RAM_MARCH_BOTH        equ $48 ; 1001000
EC_TILE3_RAM_OUTPUT_LOWER      equ $49 ; 1001001
EC_TILE3_RAM_OUTPUT_UPPER      equ $4a ; 1001010
EC_TILE3_RAM_OUTPUT_BOTH       equ $4b ; 1001011
EC_TILE3_RAM_WRITE_LOWER       equ $4c ; 1001100
EC_TILE3_RAM_WRITE_UPPER       equ $4d ; 1001101
EC_TILE3_RAM_WRITE_BOTH        equ $4e ; 1001110

WORK_RAM_BASE_EC               equ $4f
EC_WORK_RAM_ADDRESS            equ $4f ; 1001111
EC_WORK_RAM_DATA_LOWER         equ $50 ; 1010000
EC_WORK_RAM_DATA_UPPER         equ $51 ; 1010001
EC_WORK_RAM_DATA_BOTH          equ $52 ; 1010010
EC_WORK_RAM_MARCH_LOWER        equ $53 ; 1010011
EC_WORK_RAM_MARCH_UPPER        equ $54 ; 1010100
EC_WORK_RAM_MARCH_BOTH         equ $55 ; 1010101
EC_WORK_RAM_OUTPUT_LOWER       equ $56 ; 1010110
EC_WORK_RAM_OUTPUT_UPPER       equ $57 ; 1010111
EC_WORK_RAM_OUTPUT_BOTH        equ $58 ; 1011000
EC_WORK_RAM_WRITE_LOWER        equ $59 ; 1011001
EC_WORK_RAM_WRITE_UPPER        equ $5a ; 1011010
EC_WORK_RAM_WRITE_BOTH         equ $5b ; 1011011
