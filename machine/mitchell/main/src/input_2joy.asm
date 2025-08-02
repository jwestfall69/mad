	include "cpu/z80/include/common.inc"

	global	get_input

	section code

; This is for games that have a mahjong edge connector
; but aren't using the normal mahjong interface on it.
; We have to resort having to use both joysticking inputs
; for navigation via an adapter

; My majong to jamma adapter is providing these
; on IO_INPUT_P1 and IO_INPUT_P2
;  bit 7 = not connected
;  bit 6 = up
;  bit 5 = down
;  bit 4 = left
;  bit 3 = right
;  bit 2 = not connected
;  bit 1 = not connected
;  bit 0 = not connected
; MAME is doing
;  bit 7 = button 1 (P1 = CTRL,  P2 = A)
;  bit 6 = button 2 (P1 = ALT,   P2 = S)
;  bit 5 = button 3 (P1 = SPACE, P2 = Q)
;  bit 4 = button 4 (P1 = SHIFT, P2 = W)
;  bit 3 = not connected
;  bit 2 = start    (P1 = 1  ,   P2 = 2)
;  bit 1 = not connected
;  bit 0 = not connected
;
; This is why there are tweaks between MAME
; and hardware below.
; returns
;  a = input data
get_input:
		push	bc
		in	a, (IO_INPUT_P2)
		srl	a
		srl	a
		srl	a

	ifd _MAME_BUILD_
		srl	a
	endif
		and	$f
		ld	b, a

		in	a, (IO_INPUT_P1)

	ifnd _MAME_BUILD_
		sla	a
	endif
		and	$f0
		or	b
		pop	bc
		ret
