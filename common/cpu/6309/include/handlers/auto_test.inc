	rsreset
s_at_function_ptr	rs.w 1
s_at_name_ptr		rs.w 1
s_at_struct_size	rs.b 0

	macro AUTO_TEST_ENTRY
		dc.w	\1, \2
	endm

	macro AUTO_TEST_LIST_END
		dc.w	$0, $0
	endm
