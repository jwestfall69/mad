; sprite max common

	rsreset

s_smc_sprite_num	rs.b 1
s_smc_sprite_size	rs.b 1
s_smc_x_dec		rs.b 1
s_smc_y_inc		rs.b 1
s_smc_num_columns	rs.b 1
s_smc_num_rows		rs.b 1
s_smc_struct_size	rs.b 0

	; struct smc_settings {
	;   byte sprite_num;
	;   byte sprite_size;
	;   byte x_dec;
	;   byte y_inc;
	;   byte num_columns;
	;   byte num_rows
	; }
	macro SMC_SETTINGS
		dc.b \1, \2, \3, \4, \5, \6
	endm
