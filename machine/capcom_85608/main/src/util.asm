	include "cpu/z80/include/common.inc"

	global wait_nmi_copy

	section code


wait_nmi_copy:
		ld	a, CTRL_RS_BASE|CTRL_NMI_ENABLE|CTRL_SND_RESET_OFF
		ld	(REG_CONTROL), a

	.loop_wait_nmi_copy:
		ld	a, (r_nmi_copy_size)
		cp	$0
		jr	nz, .loop_wait_nmi_copy

		ld	a, CTRL_RS_BASE|CTRL_NMI_DISABLE|CTRL_SND_RESET_OFF
		ld	(REG_CONTROL), a
		ret
