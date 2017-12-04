//
//  UIDeviceHardware.h
//  KKTV
//
//  Created by Sheng Richard on 12-11-28.
//
//

#import <Foundation/Foundation.h>

typedef enum {
    KKDeviceTypePod1 = 1,
    KKDeviceTypePod2,
    KKDeviceTypePod3,
    KKDeviceTypePod4,
    KKDeviceTypePod5,
    KKDeviceTypePhone1,
    KKDeviceTypePhone3G,
    KKDeviceTypePhone3GS,
    KKDeviceTypePhone4,
    KKDeviceTypePhone4s,
    KKDeviceTypePhone5,
    KKDeviceTypePhone5c,
    KKDeviceTypePhone5s,
    KKDeviceTypePhone6,
    KKDeviceTypePhone6Plus,
    KKDeviceTypePhone6s,
    KKDeviceTypePhone6sPlus,
    KKDeviceTypePhoneSE,
    KKDeviceTypePhone7,
    KKDeviceTypePhone7Plus,
    KKDeviceTypePhone8,
    KKDeviceTypePhone8Plus,
    KKDeviceTypePhoneX,
    KKDeviceTypePad,
    KKDeviceTypeOthers
} KKDeviceType;

@interface UIDeviceHardware : NSObject
+ (NSString *) platform;
+ (NSString *) platformString;
+ (KKDeviceType)platformType;

@end
