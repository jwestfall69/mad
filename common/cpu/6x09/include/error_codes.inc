	ifd _CPU_6809_
		include "cpu/6809/include/error_codes.inc"
	endif

	ifd _CPU_6309_
		include "cpu/6309/include/error_codes.inc"
	endif

	ifd _CPU_KONAMI2_
		include "cpu/konami2/include/error_codes.inc"
	endif
