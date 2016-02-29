//
//  UIDevice(Identifier).m
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import "UIDevice+IdentifierAddition.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

@interface UIDevice(Private)

- (NSString *) macaddress;

@end

@implementation UIDevice (IdentifierAddition)

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Private Methods

// Return the local MAC addy
// Courtesy of FreeBSD hackers email list
// Accidentally munged during previous update. Fixed thanks to erica sadun & mlamb.
- (NSString *) macaddress{
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public Methods

- (NSString *)uniqueDeviceIdentifier{
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@",macaddress,bundleIdentifier];
    
    NSString *uniqueIdentifier = [Helper md5:stringToHash];
    return uniqueIdentifier;
}

- (NSString *)uniqueGlobalDeviceIdentifier{
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    
    NSString *uniqueIdentifier = [Helper md5:macaddress];
    return uniqueIdentifier;
}


/*
 *   check the device if it is IPhone6 or IPhone6s and so on
 *
 */
- (NSString*)machine{
    
    int mib[2];
    size_t len;
    char *name;
    
    mib[0] = CTL_HW;
    mib[1] = HW_MACHINE;
    sysctl(mib, 2, NULL, &len, NULL, 0);
    name = malloc(len);
    sysctl(mib, 2, name, &len, NULL, 0);
    NSString *platform = [NSString stringWithCString:name encoding:NSASCIIStringEncoding];
    free(name);
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G "; //(A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G "; //(A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS "; //(A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 "; //(A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 "; //(A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 "; //(A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S "; //(A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 "; //(A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 "; //(A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c "; //(A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c "; //(A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s "; //(A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s "; //(A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus "; //(A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 "; //(A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s ";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus ";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G "; //(A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G "; //(A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G "; //(A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G "; //(A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G "; //(A1421/A1509)";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G "; //(A1219/A1337)";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 "; //(A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 "; //(A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 "; //(A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 "; //(A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G "; //(A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G "; //(A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G "; //(A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 "; //(A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 "; //(A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 "; //(A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 "; //(A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 "; //(A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 "; //(A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air "; //(A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air "; //(A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air "; //(A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G "; //(A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G "; //(A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G "; //(A1491)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}


/*
 *   检测当前网络状况
 */
+ (BOOL)checkNowNetworkStatus
{
    //状态栏是由当前app控制的，首先获取当前app
    UIApplication *app = [UIApplication sharedApplication];
    NSArray *children = [[[app valueForKeyPath:@"statusBar"] valueForKeyPath:@"foregroundView"] subviews];
    int type = 0;
    for (id child in children) {
        
        if ([child isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            
            type = [[child valueForKeyPath:@"dataNetworkType"] intValue];
        }
    }
    //打印出的type数字对应的网络状态依次是：0 - 无网络; 1 - 2G; 2 - 3G; 3 - 4G; 5 - WIFI
    return type;
}
@end





#import <CommonCrypto/CommonHMAC.h>
@implementation Helper

+ (NSString *) md5:(NSString *)str {
    if (str == nil) {
        return nil;
    }
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (int)strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
@end


