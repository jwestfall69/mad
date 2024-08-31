REGB_BASE	equ $800140

	ifd _CPS_B_01_
		include "cps_b/cps_b_01.inc"
	endif

	ifd _CPS_B_11_
		include "cps_b/cps_b_11.inc"
	endif

	ifd _CPS_B_15_
		include "cps_b/cps_b_15.inc"
	endif

	ifd _CPS_B_21_BT1_
		include "cps_b/cps_b_21_bt1.inc"
	endif

	ifd _CPS_B_21_BT3_
		include "cps_b/cps_b_21_bt3.inc"
	endif
