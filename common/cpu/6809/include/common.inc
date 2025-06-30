	include "global/include/macros.inc"

	include "cpu/6x09/include/macros.inc"

	include "cpu/6809/include/error_codes.inc"
	include "cpu/6809/include/psub.inc"

	include "error_codes.inc"
	include "machine.inc"
	include "mad.inc"

	ifnd _HEADLESS_
		include "global/include/screen.inc"
		include "cpu/6x09/include/xy_string.inc"
		include "input.inc"
	endif
