# CPS2
## NOTES
There has been only a little bit of testing of mad in mame and on real hardware.

Hardware thats be used for testing so far:

1944 (suicided)<br>
xmcotaa (encrypted)

#### Makefiles
Makefile.generic will make a generic version that should mostly work on suicided
boards.  The font maybe screwy. Note this make file will also compile encrypted
and suicided versions of mad rom but they are the same.

Other Makefile.* files are for specific romsets and will build to both a
encrypted and suicided version of the mad rom for that romset.  These versions
should have better font/palette setup then the generic one.

The suicide.key (phoenix.key) is included, other key files can be found in mame
and should be placed in the keys/ directory.

### MAD eeproms
27c4096 goes into rom slot 03 on B board
