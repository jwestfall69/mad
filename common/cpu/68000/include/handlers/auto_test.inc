	rsreset
s_at_function_ptr	rs.l 1
s_at_name_ptr		rs.l 1
s_at_struct_size	rs.b 0

	macro AUTO_TEST_ENTRY
		dc.l	\1, \2
	endm

	macro AUTO_TEST_LIST_END
		dc.l	$0, $0
	endm
