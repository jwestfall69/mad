# WWF Superstars
## NOTES

### BG RAM (gfx board)
* 1x TMM2018AP-35 (2K x 8bit)
* IC24
* Address space only has the lower 8 bits wired to the ram (upper is floating?)

### FG RAM (cpu board)
* 1x MB8416A-15L-SK (2K x 8bit)
* IC22
* Address space only has the lower 8 bits wired to the ram (upper is floating?)

### palette RAM (cpu board)
* 2x Sony CXK5814P-35L (2K x 8bit each)
* IC19 and IC20 (its likely that IC19 is lower and IC20 is upper)
* Address lines A9 and A10 are tied to ground
  * Making the addressable size be 1K instead of the 4K raw size
* The high nibble in the upper byte is not wired to the CPU so it will have random bits set
