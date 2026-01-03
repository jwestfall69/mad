	include "cpu/68000/include/common.inc"

	global scroll2_tile_viewer

	section code

scroll2_tile_viewer:
		; align to our grid
	ifd _SCREEN_TATE_
		move.w	#$ffb8, REGA_SCROLL2_X
		move.w	#$0, REGA_SCROLL2_Y
	else
		move.w	#$ffc0, REGA_SCROLL2_X
		move.w	#$18, REGA_SCROLL2_Y
	endif

		lea	SCROLL2_PALETTE + (PALETTE_SIZE * TVC_PALETTE_NUM), a0
		bsr	tvc_init

		moveq	#0, d0
		move.w	#RS_TV_TILE_OFFSET_MASK, d1
		lea	scroll2_seek_xy_cb, a0
		lea	tvc_draw_tile_cb, a1
		bsr	tile16_viewer_handler
		rts


; in cases where we need to goto x, y location at runtime
; params:
;  d0 = x
;  d1 = y
scroll2_seek_xy_cb:
		and.l	#$ff, d0
		and.l	#$ff, d1

	ifd _SCREEN_TATE_
		lea	SCROLL2_RAM + $5c4, a6
		lsl.l	#1, d0
		lsl.l	#5, d1
		adda.l	d0, a6
		suba.l	d1, a6
	else
		SEEK_XY	0, 0
		lsl.l	#5, d0
		lsl.l	#1, d1
		adda.l	d0, a6
		adda.l	d1, a6
		sub.l	#$8000, a6
	endif
		rts
