; last updated by gen-error-codes on 2025-03-21 @ 21:12 UTC
EC_BANK_SWITCH                 equ $01 ; 000001

EC_MCPU_LATCH1_OUTPUT          equ $02 ; 000010
EC_MCPU_LATCH2_OUTPUT          equ $03 ; 000011

EC_MSM6295_ALREADY_PLAYING     equ $04 ; 000100
EC_MSM6295_OUTPUT              equ $05 ; 000101
EC_MSM6295_PLAY                equ $06 ; 000110

EC_YM2151_BUSY_BIT             equ $07 ; 000111
EC_YM2151_BUSY_TIMEOUT         equ $08 ; 001000
EC_YM2151_OUTPUT               equ $09 ; 001001
EC_YM2151_TIMERA_IRQ           equ $0a ; 001010
EC_YM2151_TIMERB_IRQ           equ $0b ; 001011
EC_YM2151_UNEXPECTED_IRQ       equ $0c ; 001100

WORK_RAM_BASE_EC               equ $0d
EC_WORK_RAM_ADDRESS            equ $0d ; 001101
EC_WORK_RAM_DATA               equ $0e ; 001110
EC_WORK_RAM_MARCH              equ $0f ; 001111
EC_WORK_RAM_OUTPUT             equ $10 ; 010000
EC_WORK_RAM_WRITE              equ $11 ; 010001
