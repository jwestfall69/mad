MAD_ROM_SIZE		equ $4000

PALETTE_TEXT_COLOR	equ $0fff

; There aren't enough registers to save the number of passes
; work ram tests have run and we can't store it in work ram.
; Instead we need to store it in some other location..
R_WORK_RAM_PASSES	equ TILE_RAM
