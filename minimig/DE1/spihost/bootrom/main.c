
#include "hardware.h"
#include <stdio.h>
#include <string.h>
#include "fat16z80.h"


void main(void)
{
	ResetLow();
	/*intialize mmc card*/
	if(SDCARD_Init()==0)
	{	puts("SPI card found!\r");
		if(FindDrive())
		{	
			puts("FAT16 found!\r");
			if(Search("SPIHOST ROM"))
			{	
				puts("Loading SPIHOST...\r");
				Load(0x400000);
				puts("Start SpiHost\r");
				_asm
					ld	hl,#0xe000
					ld	(hl),#0xc7					;rst 00
					jp	0xe000					;starte SPIHOST.ROM
				_endasm;
			}
			else
			{
				puts("SPIHOST.ROM not found\r");
			}
		}
		else
		{
			puts("FAT16 error\r");
		}
	}
	else
	{	
		puts("Timeout error\r");
	}
	
}
