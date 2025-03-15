# mitchell
## NOTES
To use this machine/diag you need to switch the CPU to a z80 instead of
the kabuki.

There is something fishy around IO_INPUT_SYS2 "vblank" bit.  It will only 
trigger a few times before it will stop doing it.  Writing $8 to ($00) io
port seems to temp wake it up, this write also seems to cause a full 
clear/redraw of the screen?

pkladies and block block don't have a normal button/joystick setup so
they don't work for now.

### Palette RAM
* Not readable by the cpu
* Only writable during vblank
