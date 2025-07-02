; When creating a screen for tests/menu's etc, these
; are the smallest x, y values we should use when
; printing something to the screen.
SCREEN_START_X		equ $3
SCREEN_START_Y		equ $3

SCREEN_PASSES_VALUE_X	equ SCREEN_START_X + 10
SCREEN_PASSES_Y		equ SCREEN_START_Y + 6

; These are the Y offsets for the 'B1 - PAUSE' and
; 'B2 - RETURN TO MENU' type strings
SCREEN_B1_Y		equ SCREEN_NUM_ROWS - 3
SCREEN_B2_Y		equ SCREEN_NUM_ROWS - 2
