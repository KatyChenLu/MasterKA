//
//  NSString+Master.h
//  MasterKA
//
//  Created by jinghao on 16/4/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SAMKeychain.h>

@interface NSString (Master)
- (NSString *)md5HexDigest;

- (NSString *)encryptWithText;//加密

- (NSString *)decryptWithText;//解密

- (NSString *)base64StringFromText;

- (NSString *)textFromBase64String;

- (NSString *)masterFullImageUrl;

+(NSString *)UUID;

- (NSString*)ClipImageUrl:(NSString *)wide;

@end
