	macro STRING
		dc.b \1, $0
		align 2
	endm


	macro MEMORY_FILL_ITEM
		dc.l \1		; start address
		dc.w \2, \3	; size, value
	endm

	macro MEMORY_FILL_ITEM_NULL
		dc.l $0
	endm

	macro STALL
.\@
		bra	.\@
	endm
