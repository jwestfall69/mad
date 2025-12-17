# Notes

## 6x09 Tree
The 6x09 tree is for common code between 6809, 6309 and konami2 CPUs.  In general
this will just be code that runs on a 6809, with the exception that `tfr/exg`
instructions that use the `d` or `dp` registers should **not** be used.  These are
broken/weird on the konami2 CPU.