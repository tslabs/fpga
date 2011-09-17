#ifndef HARDWARE_H_INCLUDED
#define HARDWARE_H_INCLUDED




/*functions and macro's*/
void HardwareInit(void);
void EnableCard(void);
void DisableCard(void);
void EnableFpga(void);
void DisableFpga(void);
void EnableOsd(void);
void DisableOsd(void);
void ResetLow(void);
void ResetHigh(void);
void cmd_read_block0(void);
void cmd_read_block1(void);
unsigned char OsdGetKey(void);
unsigned char CheckButton(void);
unsigned char SPI(unsigned char data);
unsigned char SPIOSD(unsigned char data);
unsigned short GetTimer(unsigned short offset);
unsigned char CheckTimer(unsigned short t);

unsigned char SDCARD_Init(void);
unsigned char AtaReadSector(unsigned long lba, unsigned char *ReadData);

void SetFstate(unsigned char data);
unsigned char GetFtrack(void);
unsigned char GetFstate(void);

/*unsigned char AtaWriteSector(unsigned long lba, unsigned char *WriteData);*/

#endif
