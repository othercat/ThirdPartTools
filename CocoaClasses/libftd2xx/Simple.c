/*
	Simple example to open a maximum of 4 devices - write some data then read it back.
	Shows one method of using list devices also.
	Assumes the devices have a loopback connector on them and they also have a serial number

	To build use the following gcc statement 
	(assuming you have the d2xx library in the /usr/local/lib directory).
	gcc -o simple main.c -L. -lftd2xx -Wl,-rpath /usr/local/lib
    Modified by Li Richard on 12-6-03.
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>
#include "ftd2xx.h"

#define BUF_SIZE 16

#define MAX_DEVICES		5
void quit_simple();
int simple_2xx(void);
int simple_readdevice(int devNum,FT_DEVICE_LIST_INFO_NODE *deviceInfo);

// Globals
FT_HANDLE	ftHandle_simple[MAX_DEVICES];
char * 	pcBufRead_simple = NULL;


void quit_simple()
{  
	int i;

	for(i = 0; i < MAX_DEVICES; i++) {
		if(ftHandle_simple[i] != NULL) {
			FT_Close(ftHandle_simple[i]);
			ftHandle_simple[i] = NULL;
			printf("Closed device\n");
		}
	}

	if(pcBufRead_simple)
		free(pcBufRead_simple);

	exit(1);
}

int simple_readdevice(int devNum,FT_DEVICE_LIST_INFO_NODE *deviceInfo)
{
        char * 	pcBufLD[MAX_DEVICES + 1];
        char 	cBufLD[MAX_DEVICES][64];
        FT_STATUS	ftStatus;
        int	i;
        
        for(i = 0; i < MAX_DEVICES; i++) {
            pcBufLD[i] = cBufLD[i];
            ftHandle_simple[i] = NULL;
        }
        pcBufLD[MAX_DEVICES] = NULL;
        
        FT_DEVICE_LIST_INFO_NODE *devInfo; 
        DWORD numDevs;
        
        // create the device information list 
        ftStatus = FT_CreateDeviceInfoList(&numDevs);
        if (ftStatus == FT_OK) { 
            printf("Number of devices is %d\n",numDevs);
        }
        if (numDevs > 0) { 
            // allocate storage for list based on numDevs 
            devInfo = (FT_DEVICE_LIST_INFO_NODE*)malloc(sizeof(FT_DEVICE_LIST_INFO_NODE)*numDevs); 
            // get the device information list 
            ftStatus = FT_GetDeviceInfoList(devInfo,&numDevs); 
            if (ftStatus == FT_OK) {
                for (int i = 0; i < numDevs; i++) { 
                    printf("Dev %d:\n",i);
                    printf(" Flags=0x%lx\n",devInfo[i].Flags); 
                    printf(" Type=0x%lx\n",devInfo[i].Type); 
                    printf(" ID=0x%lx\n",devInfo[i].ID); 
                    printf(" LocId=0x%x\n",devInfo[i].LocId); 
                    printf(" SerialNumber=%s\n",devInfo[i].SerialNumber); 
                    printf(" Description=%s\n",devInfo[i].Description); 
                    printf(" ftHandle=0x%x\n",(int)devInfo[i].ftHandle);
                }
                
                deviceInfo->Flags = devInfo[devNum].Flags; 
                deviceInfo->Type = devInfo[devNum].Type; 
                deviceInfo->ID = devInfo[devNum].ID; 
                deviceInfo->LocId = devInfo[devNum].LocId; 
                strcpy(deviceInfo->SerialNumber, devInfo[devNum].SerialNumber); 
                strcpy(deviceInfo->Description , devInfo[devNum].Description); 
                deviceInfo->ftHandle = devInfo[devNum].ftHandle; 
            }
        }
        return 0;    
}

int simple_2xx(void)
{
	char 	cBufWrite[BUF_SIZE];
	char * 	pcBufLD[MAX_DEVICES + 1];
	char 	cBufLD[MAX_DEVICES][64];
	DWORD	dwRxSize = 0;
	DWORD 	dwBytesWritten, dwBytesRead;
	FT_STATUS	ftStatus;
	//FT_HANDLE	ftHandle;
	int	iNumDevs = 0;
	int	i, j;
	int	iDevicesOpen = 0;

	for(i = 0; i < MAX_DEVICES; i++) {
		pcBufLD[i] = cBufLD[i];
		ftHandle_simple[i] = NULL;
	}
	pcBufLD[MAX_DEVICES] = NULL;
 
    FT_DEVICE_LIST_INFO_NODE *devInfo; 
    DWORD numDevs;
    
    // create the device information list 
    ftStatus = FT_CreateDeviceInfoList(&numDevs);
    if (ftStatus == FT_OK) { 
        printf("Number of devices is %d\n",numDevs);
    }
    if (numDevs > 0) { 
        // allocate storage for list based on numDevs 
        devInfo = (FT_DEVICE_LIST_INFO_NODE*)malloc(sizeof(FT_DEVICE_LIST_INFO_NODE)*numDevs); 
        // get the device information list 
        ftStatus = FT_GetDeviceInfoList(devInfo,&numDevs); 
        if (ftStatus == FT_OK) {
        
            for (int i = 0; i < numDevs; i++) { 
                printf("Dev %d:\n",i);
                printf(" Flags=0x%lx\n",devInfo[i].Flags); 
                printf(" Type=0x%lx\n",devInfo[i].Type); 
                printf(" ID=0x%lx\n",devInfo[i].ID); 
                printf(" LocId=0x%x\n",devInfo[i].LocId); 
                printf(" SerialNumber=%s\n",devInfo[i].SerialNumber); 
                printf(" Description=%s\n",devInfo[i].Description); 
                printf(" ftHandle=0x%x\n",(int)devInfo[i].ftHandle);
        }
    }
}
    
    
	ftStatus = FT_ListDevices(pcBufLD, &iNumDevs, FT_LIST_ALL | FT_OPEN_BY_SERIAL_NUMBER);
	
	if(ftStatus != FT_OK) {
        printf("Error: FT_ListDevices(%lu)\n", ftStatus);
		return 1;
	}

	for(j = 0; j < BUF_SIZE; j++) {
		cBufWrite[j] = j;
	}
	
	for(i = 0; ( (i <MAX_DEVICES) && (i < iNumDevs) ); i++) {
        printf("Device %d Serial Number - %s\n", i, cBufLD[i]);
	}
	
    signal(SIGINT, quit_simple);		// trap ctrl-c call quit fn 
		
	for(i = 0; ( (i <MAX_DEVICES) && (i < iNumDevs) ) ; i++) {
		/* Setup */
		if((ftStatus = FT_OpenEx(cBufLD[i], FT_OPEN_BY_SERIAL_NUMBER, &ftHandle_simple[i])) != FT_OK){
			/* 
				This can fail if the ftdi_sio driver is loaded
		 		use lsmod to check this and rmmod ftdi_sio to remove
				also rmmod usbserial
		 	*/
            printf("Error FT_OpenEx(%lu), device : %d\n", ftStatus, i);
			return 1;
		}
        printf("Opened device %s\n", cBufLD[i]);

		iDevicesOpen++;
		if((ftStatus = FT_SetBaudRate(ftHandle_simple[i], 115200)) != FT_OK) {
			

            printf("Error FT_SetBaudRate(%lu), cBufLD[i] = %s\n", ftStatus, cBufLD[i]);
            break;
		}
		for(j = 0; j < BUF_SIZE; j++) {
			printf("cBufWrite[%d] = 0x%02X\n", j, cBufWrite[j]);
		}
		
        
        /* Write */
		if((ftStatus = FT_Write(ftHandle_simple[i], cBufWrite, 2, &dwBytesWritten)) != FT_OK) {
			printf("Error FT_Write(%lu)\n", ftStatus);
			break;
		}
        
		/* Write */
		if((ftStatus = FT_Write(ftHandle_simple[i], cBufWrite, 12, &dwBytesWritten)) != FT_OK) {
			printf("Error FT_Write(%lu)\n", ftStatus);
			break;
		}
		
		/* Read */
		dwRxSize = 0;			
		while ((dwRxSize < BUF_SIZE) && (ftStatus == FT_OK)) {
			ftStatus = FT_GetQueueStatus(ftHandle_simple[i], &dwRxSize);
		}
		if(ftStatus == FT_OK) {
			pcBufRead_simple = (char*)realloc(pcBufRead_simple, dwRxSize);
			memset(pcBufRead_simple, 0xFF, dwRxSize);
			for(j = 0; j < dwRxSize; j++) {
				printf("pcBufRead[%d] = 0x%02X\n", j, pcBufRead_simple[j]);
			}
			if((ftStatus = FT_Read(ftHandle_simple[i], pcBufRead_simple, dwRxSize, &dwBytesRead)) != FT_OK) {
				printf("Error FT_Read(%lu)\n", ftStatus);
			}
			else {
				printf("FT_Read = %d\n", dwBytesRead);
				for(j = 0; j < dwBytesRead; j++) {
					printf("pcBufRead[%d] = 0x%02X\n", j, pcBufRead_simple[j]);
				}
			}
		}
		else {
			printf("Error FT_GetQueueStatus(%lu)\n", ftStatus);	
		}
	}

	for(i = 0; i < iDevicesOpen; i++) {
		if(ftHandle_simple[i] != NULL) {
			FT_Close(ftHandle_simple[i]);
			ftHandle_simple[i] = NULL;
			printf("Closed device %s\n", cBufLD[i]);
		}
	}

	if(pcBufRead_simple)
		free(pcBufRead_simple);
	return 0;
}
