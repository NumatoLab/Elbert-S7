/*
 * main.c
 *
 *  Created on: 30-oct-2024
 *      Author: Numato_PC
 */

#include <stdio.h>
#include "xparameters.h"
#include "xil_types.h"
#include "xstatus.h"
#include "xil_testmem.h"



#include "xil_io.h"

#include "platform.h"
// #include "memory_config.h"
#include "xil_printf.h"

/* SD Card defines */
#define Card_Not_Found            0x04
#define Card_Version_x1           0x01
#define Card_Version_x2           0x02
/* SD Card */


void delay(uint32_t);
void putnum(unsigned int num);



int test_sdcard() {
    print("\r\n\r\n\e[1;33mMicroSD Card Test\e[0m\r\n");
    print("\e[1;33m*****************\e[0m\r\n\r\n");

    unsigned int i = 0xffffff;
    while (i--) {
    }

    u32 baseaddr;
    u32 DataRead;

    baseaddr = XPAR_SDCARD_0_BASEADDR;

    Xil_Out32((baseaddr) + (0x00) + (0x00), (u32)0x00);

    DataRead = 0;
    DataRead = Xil_In32((baseaddr) + (0x04) + (0x00));

    if (DataRead == Card_Not_Found) {
        print("\e[1;31mERROR:\e[0m Card Found! Error occurred \r\n\r\n");
        return -1;
    } else if (DataRead == Card_Version_x1) {
        print("\e[1;32mPASSED:\e[0m Card Found! Card inserted is of version \e[1;32mx1\e[0m\r\n");
    } else if (DataRead == Card_Version_x2) {
        print("\e[1;32mPASSED:\e[0m Card Found! Card inserted is of version \e[1;32mx2\e[0m\r\n");
    } else if (DataRead == 0x00) {
        print("\e[1;31mERROR:\e[0m SD Card not inserted!!\r\n");
        return -2;
    }

    print("SD Card Test Finished.\r\n");
    Xil_Out32((baseaddr) + (0x00000004) + (0x00), (u32)(0x01));

    print("\n\r");
    return 0;
}

int main() {
    init_platform();
   
    

    print("\r\n\r\n\e[1;36mELBERT S7 SD Card Test Suite\e[0m\r\n");
    print("\e[1;36m_____________________\e[0m\r\n\r\n");

    

    printf("Welcome to ELBERT S7 SD Card Test Suite\r\n\n");

    // Run SD Card test
    test_sdcard();

    print("\r\n\r\nELBERT S7 SD Card Test Finished. Thank You.\r\n\n");
    cleanup_platform();
    return 0;
}
