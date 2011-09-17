echo please remove or rename the standard "crt0.o" from the "SDCC\lib\Z80" -Folder!!!

sdcc -c -mz80 fat16z80.c
sdcc -c -mz80 hardware.c
as-z80 -o crt0.o crt0.asm
sdcc -mz80 -L--no-std-crt0 crt0.rel main.c fat16z80.rel hardware.rel 

packihx main.ihx >DE1_bootrom.hex
