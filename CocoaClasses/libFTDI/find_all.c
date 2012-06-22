/* find_all.c

   Example for ftdi_usb_find_all()

   This program is distributed under the GPL, version 2
   Modified by Li Richard on 12-6-03.
*/

#include <stdio.h>
#include <string.h>
#include <ftdi.h>


#define usbi_mutex_t                    pthread_mutex_t 

typedef unsigned char                   UInt8;
typedef unsigned short                  UInt16;

#if __LP64__
typedef unsigned int                    UInt32;
typedef signed int                      SInt32;
#else
typedef unsigned long                   UInt32;
typedef signed long                     SInt32;
#endif

#ifndef _UINT8_T
#define _UINT8_T
typedef unsigned char         uint8_t;
#endif /*_UINT8_T */

#ifndef _UINT32_T
#define _UINT32_T
typedef unsigned int         uint32_t;
#endif /* _UINT32_T */

#ifndef _PTHREAD_MUTEX_T
#define _PTHREAD_MUTEX_T
typedef __darwin_pthread_mutex_t	pthread_mutex_t;
#endif

/** \ingroup dev
 * Speed codes. Indicates the speed at which the device is operating.
 */
enum libusb_speed {
    /** The OS doesn't report or know the device speed. */
    LIBUSB_SPEED_UNKNOWN = 0,
    
    /** The device is operating at low speed (1.5MBit/s). */
    LIBUSB_SPEED_LOW = 1,
    
    /** The device is operating at full speed (12MBit/s). */
    LIBUSB_SPEED_FULL = 2,
    
    /** The device is operating at high speed (480MBit/s). */
    LIBUSB_SPEED_HIGH = 3,
    
    /** The device is operating at super speed (5000MBit/s). */
    LIBUSB_SPEED_SUPER = 4,
};

/*!
 @typedef IOUSBDeviceDescriptor
 @discussion Descriptor for a USB Device.  See the USB Specification at <a href="http://www.usb.org"TARGET="_blank">http://www.usb.org</a>.
 */
struct IOUSBDeviceDescriptor {
	UInt8 			bLength;
	UInt8 			bDescriptorType;
	UInt16 			bcdUSB;
	UInt8 			bDeviceClass;
	UInt8 			bDeviceSubClass;
	UInt8 			bDeviceProtocol;
	UInt8 			bMaxPacketSize0;
	UInt16 			idVendor;
	UInt16 			idProduct;
	UInt16 			bcdDevice;
	UInt8 			iManufacturer;
	UInt8 			iProduct;
	UInt8 			iSerialNumber;
	UInt8 			bNumConfigurations;
};
typedef struct IOUSBDeviceDescriptor		IOUSBDeviceDescriptor;

struct list_head {
	struct list_head *prev, *next;
};

struct libusb_device {
	/* lock protects refcnt, everything else is finalized at initialization
	 * time */
	usbi_mutex_t lock;
	int refcnt;
    
	struct libusb_context *ctx;
    
	uint8_t bus_number;
	uint8_t device_address;
	uint8_t num_configurations;
	enum libusb_speed speed;
    
	struct list_head list;
	unsigned long session_data;
	unsigned char os_priv[0];
};

int find_all(char **deviceDesc);
int GetFTDIDevicePortNumUSingLibFTDI(UInt32 locationIDFromInterface);


/*  return the location ID of the device by peeking into libusb's internals 
    for the host operating system (yes it's that bad and will stay so until 
    libusbx 2.0 offers APIs for such data) */ 
static int xlibusb_get_device_location_id(struct libusb_device *dev, uint32_t *locationId) 
{ 
    /* private structures, taken from darwin_usb.h and truncated */ 
 	struct darwin_device_priv { 
        IOUSBDeviceDescriptor dev_descriptor; 
        UInt32                location; 
    }; 

    /* taken from libusbi.h */ 
    struct list_head { 
        struct list_head *prev, *next; 
    }; 

    struct libusb_device { 
    /* lock protects refcnt, everything else is finalized at initialization time */ 
        usbi_mutex_t lock; 
        int refcnt; 

        struct libusb_context *ctx; 

        uint8_t bus_number; 
        uint8_t device_address; 
        uint8_t num_configurations; 
        enum libusb_speed speed; 

        struct list_head list; 
        unsigned long session_data; 
        unsigned char os_priv[0]; 
    }; 

    struct darwin_device_priv *dpriv = (struct darwin_device_priv *) ((struct libusb_device *) dev)->os_priv; 
    *locationId = dpriv->location; 
    printf("LocationID: 0x%lx:", dpriv->location);
    return 0; 
} 

int GetFTDIDevicePortNumUSingLibFTDI(UInt32 locationIDFromInterface)
{
    int ret, i;
    struct ftdi_context ftdic;
    struct ftdi_device_list *devlist, *curdev;
    char manufacturer[128], description[128];
    
    if (ftdi_init(&ftdic) < 0)
    {
        fprintf(stderr, "ftdi_init failed\n");
        return -1;
    }
    
    if ((ret = ftdi_usb_find_all(&ftdic, &devlist, 0x0403, 0x6001)) < 0)
    {
        fprintf(stderr, "ftdi_usb_find_all failed: %d (%s)\n", ret, ftdi_get_error_string(&ftdic));
        return -1;
    }
    
    printf("Number of FTDI devices found: %d\n", ret);
    
    i = 0;
    for (curdev = devlist; curdev != NULL; i++)
    {
        //printf("Checking device: %d\n", i);
        if ((ret = ftdi_usb_get_strings(&ftdic, curdev->dev, manufacturer, 128, description, 128, NULL, 0)) < 0)
        {
            fprintf(stderr, "ftdi_usb_get_strings failed: %d (%s)\n", ret, ftdi_get_error_string(&ftdic));
            return -1;
        }
        uint32_t *locationId = (uint32_t *)malloc(sizeof(uint32_t)); 
        
        xlibusb_get_device_location_id((struct libusb_device *)curdev->dev->dev,locationId);
        printf("Manufacturer: %s, Description: %s\n\n", manufacturer, description);
        if ((*locationId) == locationIDFromInterface) {
             free(locationId);
             return i;
        }
        
        free(locationId);
        //printf("0x%x deviceDesc[%d] %s",(unsigned int)&(deviceDesc[i]),i,deviceDesc[i]);
        curdev = curdev->next;
    }
    
    ftdi_list_free(&devlist);
    ftdi_deinit(&ftdic);
    
    return -1;
}

int find_all(char **deviceDesc)
{
    int ret, i;
    struct ftdi_context ftdic;
    struct ftdi_device_list *devlist, *curdev;
    char manufacturer[128], description[128];

    if (ftdi_init(&ftdic) < 0)
    {
        fprintf(stderr, "ftdi_init failed\n");
        return -1;
    }

    if ((ret = ftdi_usb_find_all(&ftdic, &devlist, 0x0403, 0x6001)) < 0)
    {
        fprintf(stderr, "ftdi_usb_find_all failed: %d (%s)\n", ret, ftdi_get_error_string(&ftdic));
        return -1;
    }

    printf("Number of FTDI devices found: %d\n", ret);

    i = 0;
    for (curdev = devlist; curdev != NULL; i++)
    {
        printf("Checking device: %d\n", i);
        if ((ret = ftdi_usb_get_strings(&ftdic, curdev->dev, manufacturer, 128, description, 128, NULL, 0)) < 0)
        {
            fprintf(stderr, "ftdi_usb_get_strings failed: %d (%s)\n", ret, ftdi_get_error_string(&ftdic));
            return -1;
        }
        uint32_t *locationId = (uint32_t *)malloc(sizeof(uint32_t)); 
        
        xlibusb_get_device_location_id((struct libusb_device *)curdev->dev->dev,locationId);
        printf("Manufacturer: %s, Description: %s\n\n", manufacturer, description);
        free(locationId);
        strcpy((char *)(deviceDesc[i]),(const char *)description);
        //printf("0x%x deviceDesc[%d] %s",(unsigned int)&(deviceDesc[i]),i,deviceDesc[i]);
        curdev = curdev->next;
    }

    ftdi_list_free(&devlist);
    ftdi_deinit(&ftdic);

    return i;
}
