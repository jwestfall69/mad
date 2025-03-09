
	macro DSUB_MODE_PSUB
		moveq	#$10, d7
	endm

	macro DSUB_MODE_RSUB
		moveq	#$1c, d7
		move.l	$0, sp	; re-init sp
	endm

	macro DSUB_RETURN
		bra dsub_return
	endm

	macro DSUB
		lea (\1_dsub), a2
		lea (.\@), a3
		bra dsub_enter
.\@:
	endm

	macro PSUB
		lea (\1_dsub), a2
		lea (.\@), a3
		bra dsub_enter
.\@:
	endm

	macro RSUB
		subq.w #4, d7
		bsr \1_dsub
	endm
