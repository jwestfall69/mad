	include "cpu/6809/include/common.inc"
	include "cpu/6x09/include/handlers/memory_write.inc"

	global sprite_debug

	section code

sprite_debug:
		jsr	sprite_viewer_palette_setup

		; setup highlight color on 2nd fg palette
		CPU_INTS_ENABLE

		ldd	#d_palette_data
		std	r_vblank_copy_src
		ldd	#FG_TILE_PALETTE + FG_TILE_PALETTE_SIZE
		std	r_vblank_copy_dst
		ldd	#FG_TILE_PALETTE_SIZE
		std	r_vblank_copy_size

		jsr	wait_vblank_copy

		CPU_INTS_DISABLE

		ldd	#FG_TILE_RAM
		std	r_old_highlight

		; setup initial values
		ldd	#$0801
		std	r_mw_buffer
		ldd	#$c060
		std	r_mw_buffer + 2

		ldx	#d_mw_settings
		jsr	memory_write_handler

		ldd	#$0
		std	SPRITE_RAM
		std	SPRITE_RAM + 2
		rts

; params:
;  x = fix ram location to set highlight
; we are also on the hook for clearing out the
; previous highlight
highlight_cb:
		ldy	r_old_highlight
		lda	#$0
		sta	,y

		lda	#$4
		sta	,x
		stx	r_old_highlight
		rts

write_memory_cb:
		ldx	#SPRITE_RAM
		jsr	memory_write_generic_write
loop_cb:
		rts

	section data

d_mw_settings:		MW_SETTINGS 4, r_mw_buffer, highlight_cb, write_memory_cb, loop_cb
d_palette_data:
	dc.w		$0000, $0000, $f000, $0000

	section bss

r_mw_buffer:		dcb.b 4
r_old_highlight:	dcb.w 1
