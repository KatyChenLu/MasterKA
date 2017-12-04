//
//  UIDeviceHardware.m
//  KKTV
//
//  Created by Sheng Richard on 12-11-28.
//
//

#import "UIDeviceHardware.h"
#include <sys/types.h>
#include <sys/sysctl.h>

@implementation UIDeviceHardware
+ (NSString *) platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char * machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString * platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

+ (NSString *) platformString
{
    NSString *deviceString = [self platform];
    // iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4 GSM";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"iPhone 4 GSM Rev A";
    if ([deviceString isEqualToString:@"iPhone3,3"])    return @"iPhone 4 CDMA";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4s";
    if ([deviceString isEqualToString:@"iPhone5,1"])    return @"iPhone 5 GSM";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5 GSM+CDMA";
    if ([deviceString isEqualToString:@"iPhone5,3"])    return @"iPhone 5c GSM";
    if ([deviceString isEqualToString:@"iPhone5,4"])    return @"iPhone 5c Global";
    if ([deviceString isEqualToString:@"iPhone6,1"])    return @"iPhone 5s GSM";
    if ([deviceString isEqualToString:@"iPhone6,2"])    return @"iPhone 5s Global";
    if ([deviceString isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceString isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceString isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceString isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceString isEqualToString:@"iPhone8,3"] || [deviceString isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceString isEqualToString:@"iPhone9,4"] || [deviceString isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceString isEqualToString:@"iPhone9,3"] || [deviceString isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone10,1"] || [deviceString isEqualToString:@"iPhone10,4"])    return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"] || [deviceString isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"] || [deviceString isEqualToString:@"iPhone10,6"])    return @"iPhone X";
    
    // iPod Touch
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([deviceString isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";
    
    // iPad
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad 1";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 WiFi";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 GSM";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 CDMA";
    if ([deviceString isEqualToString:@"iPad2,4"])      return @"iPad 2 32nm";
    
    if ([deviceString isEqualToString:@"iPad3,1"])      return @"iPad 3 WiFi";
    if ([deviceString isEqualToString:@"iPad3,2"])      return @"iPad 3 CDMA ";
    if ([deviceString isEqualToString:@"iPad3,3"])      return @"iPad 3 4G ";
    if ([deviceString isEqualToString:@"iPad3,4"])      return @"iPad 4 WiFi";
    if ([deviceString isEqualToString:@"iPad3,5"])      return @"iPad 4 4G";
    if ([deviceString isEqualToString:@"iPad3,6"])      return @"iPad 4 CDMA";
    if ([deviceString isEqualToString:@"iPad4,1"] || [deviceString isEqualToString:@"iPad4,2"] || [deviceString isEqualToString:@"iPad4,3"])
        return @"iPad Air";
    if ([deviceString isEqualToString:@"iPad5,3"] || [deviceString isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceString isEqualToString:@"iPad6,7"] || [deviceString isEqualToString:@"iPad6,8"])      return @"iPad Pro";
    if ([deviceString isEqualToString:@"iPad6,11"] || [deviceString isEqualToString:@"iPad6,12"])      return @"iPad 5";
    if ([deviceString isEqualToString:@"iPad7,1"] || [deviceString isEqualToString:@"iPad7,2"] || [deviceString isEqualToString:@"iPad7,3"]|| [deviceString isEqualToString:@"iPad7,4"])    return @"iPad Pro 2";
    
    // iPad mini
    if ([deviceString isEqualToString:@"iPad2,5"])      return @"iPad mini WiFi";
    if ([deviceString isEqualToString:@"iPad2,6"])      return @"iPad mini GSM";
    if ([deviceString isEqualToString:@"iPad2,7"])      return @"iPad mini CDMA";
    if ([deviceString isEqualToString:@"iPad4,4"] || [deviceString isEqualToString:@"iPad4,5"]
        ||[deviceString isEqualToString:@"iPad4,6"])
        return @"iPad mini 2";
    if ([deviceString isEqualToString:@"iPad4,7"] || [deviceString isEqualToString:@"iPad4,8"] ||[deviceString isEqualToString:@"iPad4,9"])
        return @"iPad mini 3";
    if ([deviceString isEqualToString:@"iPad5,1"] || [deviceString isEqualToString:@"iPad5,2"])
        return @"iPad mini 4";
    
    // Simulator
    if ([deviceString isEqualToString:@"i386"])        return @"iPhone Simulator";
    if ([deviceString isEqualToString:@"x86_64"])      return @"iPhone Simulator";
    
    return deviceString;
}

+ (KKDeviceType)platformType {
    
    static KKDeviceType type = KKDeviceTypeOthers;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *platform = [self platform];
        
        if ([platform hasPrefix:@"iPhone1,1"]) {
            type = KKDeviceTypePhone1;
        }
        else if ([platform hasPrefix:@"iPhone1,2"]) {
            type = KKDeviceTypePhone3G;
        }
        else if ([platform hasPrefix:@"iPhone2"]) {
            type = KKDeviceTypePhone3GS;
        }
        else if ([platform hasPrefix:@"iPhone2,1"]) {
            type = KKDeviceTypePhone3GS;
        }
        else if ([platform hasPrefix:@"iPhone3"]) {
            type = KKDeviceTypePhone4;
        }
        else if ([platform hasPrefix:@"iPhone3,1"]) {
            type = KKDeviceTypePhone4;
        }
        else if ([platform hasPrefix:@"iPhone3,2"]) {
            type = KKDeviceTypePhone4;
        }
        else if ([platform hasPrefix:@"iPhone3,3"]) {
            type = KKDeviceTypePhone4;
        }
        else if ([platform hasPrefix:@"iPhone4"]) {
            // iPhone3.1（GSM）iPhone3.2 iPhone3.3（CDMA）
            type = KKDeviceTypePhone4s;
        }
        else if ([platform hasPrefix:@"iPhone4,1"]) {
            type = KKDeviceTypePhone4s;
        }
        else if ([platform hasPrefix:@"iPhone5,1"] || [platform hasPrefix:@"iPhone5,2"]) {
            type = KKDeviceTypePhone5;
        }
        else if ([platform hasPrefix:@"iPhone5,3"] || [platform hasPrefix:@"iPhone5,4"]) {
            type = KKDeviceTypePhone5c;
        }
        else if ([platform hasPrefix:@"iPhone6"]) {
            type = KKDeviceTypePhone5s;
        }
        else if ([platform hasPrefix:@"iPhone6,1"]) {
            type = KKDeviceTypePhone5s;
        }
        else if ([platform hasPrefix:@"iPhone6,2"]) {
            type = KKDeviceTypePhone5s;
        }
        else if ([platform hasPrefix:@"iPhone7,2"]) {
            type = KKDeviceTypePhone6;
        }
        else if ([platform hasPrefix:@"iPhone7,1"]) {
            type = KKDeviceTypePhone6Plus;
        }
        else if ([platform hasPrefix:@"iPhone8,1"]) {
            type = KKDeviceTypePhone6s;
        }
        else if ([platform hasPrefix:@"iPhone8,2"]) {
            type = KKDeviceTypePhone6sPlus;
        }
        else if ([platform hasPrefix:@"iPhone8,3"] || [platform hasPrefix:@"iPhone8,4"]) {
            type = KKDeviceTypePhoneSE;
        }
        else if ([platform hasPrefix:@"iPhone9,1"] || [platform hasPrefix:@"iPhone9,3"]) {
            type = KKDeviceTypePhone7;
        }
        else if ([platform hasPrefix:@"iPhone9,2"] || [platform hasPrefix:@"iPhone9,4"]) {
            type = KKDeviceTypePhone7Plus;
        }
        else if ([platform hasPrefix:@"iPhone10,1"] || [platform hasPrefix:@"iPhone10,4"]) {
            type = KKDeviceTypePhone8;
        }
        else if ([platform hasPrefix:@"iPhone10,2"] || [platform hasPrefix:@"iPhone10,5"]) {
            type = KKDeviceTypePhone8Plus;
        }
        else if ([platform hasPrefix:@"iPhone10,3"] || [platform hasPrefix:@"iPhone10,6"]) {
            type = KKDeviceTypePhoneX;
        }
        else if ([platform hasPrefix:@"iPod1,1"]) {
            type = KKDeviceTypePod1;
        }
        else if ([platform hasPrefix:@"iPod2,1"]) {
            type = KKDeviceTypePod2;
        }
        else if ([platform hasPrefix:@"iPod3,1"]) {
            type = KKDeviceTypePod3;
        }
        else if ([platform hasPrefix:@"iPod4,1"]) {
            type = KKDeviceTypePod4;
        }
        else if ([platform hasPrefix:@"iPod5,1"]) {
            type = KKDeviceTypePod5;
        }
        else if ([platform hasPrefix:@"iPad"]) {
            type = KKDeviceTypePad;
        }
    });
    
    return type;
}

@end
