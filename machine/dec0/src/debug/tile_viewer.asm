	include "cpu/68000/include/dsub.inc"
	include "cpu/68000/include/macros.inc"

	include "mad_rom.inc"
	include "machine.inc"

	global tile_viewer

	section code

tile_viewer:
		bsr	tile_viewer_handler
		rts
