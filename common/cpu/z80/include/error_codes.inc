; global error codes
; There are only 6 bits available for error addresses
; this puts a limit on error codes from 0 to 63
EC_ALL_TESTS_PASSED		equ $0
EC_MAD_ROM_CRC32		equ $3f
EC_MAD_ROM_ADDRESS		equ $3e
