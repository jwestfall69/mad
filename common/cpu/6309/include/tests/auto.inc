	rsreset
s_ae_function_ptr	rs.w 1
s_ae_name_ptr		rs.w 1
s_ae_struct_size	rs.b 0

	macro AUTO_ENTRY
		dc.w	\1, \2
	endm

	macro AUTO_LIST_END
		dc.w	$0, $0
	endm
