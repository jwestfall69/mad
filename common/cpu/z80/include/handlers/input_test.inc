	macro INPUT_TEST_ENTRY
		dc.w \1
	endm

	macro INPUT_TEST_LIST_END
		; using $ffff here instead of $0 like other machines
		; to avoid a conflict with machines using io $00
		dc.w $ffff
	endm
