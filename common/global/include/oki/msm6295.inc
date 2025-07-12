; Information about the start/stop addresses of sound
; samples are stored in array of data at the start of
; the ADPCM rom space.  The array consists up to 128 of
; the following struct;
; struct phrase {
;   uint8_t start_addr[3];
;   uint8_t end_addr[3];
;   uint8_t pad[2]; // 0 filled
; }
; The msm6295 doesn't allow the use of phrase 0, so
; this allows for 127 different adpcm sounds.
;
; When wanting to play a sound you need to send 2 bytes
; to the msm6295 register address.
;  byte 1 = MSM6295_PHRASE_SEL_BIT | phrase #
;  delay
;  byte 2 = channel bit << 4 | volume reduction value
;
MSM6295_PHRASE_SEL	equ $80
MSM6295_CHANNEL1	equ $1
MSM6295_CHANNEL2	equ $2
MSM6295_CHANNEL3	equ $4
MSM6295_CHANNEL4	equ $8
