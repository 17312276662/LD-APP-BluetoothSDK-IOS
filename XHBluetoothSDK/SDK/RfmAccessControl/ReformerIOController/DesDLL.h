#ifndef __DESDLL_H__
#define __DESDLL_H__

#include <stdint.h>
#include <stdbool.h>

extern void DES(uint8_t *key,uint8_t *data_in,uint8_t *data_out,int16_t mode);
extern void DES3(uint8_t *key,uint8_t *data_in,uint8_t *data_out,int16_t mode);
extern void Key_encrypt(uint8_t *data_in,uint8_t *data_out,int16_t type);
extern void Produce_key(uint8_t *data_in,uint8_t *data_out);
extern void Restore_key(uint8_t *data_in,uint8_t *data_out);
extern int16_t ComputerCardMac(uint8_t *data_in,uint8_t *mac);
extern int16_t ComputerSectorKey(uint8_t *data_in,uint8_t *sector_flag,uint8_t *data_out,int16_t type);

#endif //__DESDLL_H__
