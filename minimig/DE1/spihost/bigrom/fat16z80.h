#ifndef _FAT16Z80_H_INCLUDED
#define _FAT16Z80_H_INCLUDED

/*functions*/
unsigned char FindDrive(void);
unsigned char Search(unsigned char *name);
unsigned char Load(unsigned long addr);

#endif
