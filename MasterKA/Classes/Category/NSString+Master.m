//
//  NSString+Master.m
//  MasterKA
//
//  Created by jinghao on 16/4/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "NSString+Master.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
NSString *const SERVICE = @"com.shishiTec.MasterKA";

@implementation NSString (Master)
- (NSString *)md5HexDigest{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int)strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}

- (NSString*)masterFullImageUrl
{
    NSString *url = self;
    if(![url hasPrefix:@"http://"]&&![url  hasPrefix:@"https://"]){
        url = [NSString stringWithFormat:@"%@/%@",IMAGE_DOMAIN,[url urldecode]];
    }
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return url;
}
- (NSString*)ClipImageUrl:(NSString *)wide {
    NSString *url = self;
    NSString *clipStr = self;
    if ([url containsString:@".png"]) {
       clipStr = [NSString stringWithFormat:@"%@_%@.png",[[url componentsSeparatedByString:@".png"] firstObject],wide];
    }else if ([url containsString:@".jpg"]) {
        clipStr = [NSString stringWithFormat:@"%@_%@.jpg",[[url componentsSeparatedByString:@".jpg"] firstObject],wide];
    }else if ([url containsString:@".JPG"]) {
        clipStr = [NSString stringWithFormat:@"%@_%@.JPG",[[url componentsSeparatedByString:@".JPG"] firstObject],wide];
    }else if ([url containsString:@".PNG"]) {
        clipStr = [NSString stringWithFormat:@"%@_%@.PNG",[[url componentsSeparatedByString:@".PNG"] firstObject],wide];
    }
//    else if ([url containsString:@".gif"]) {
//        clipStr = [NSString stringWithFormat:@"%@_%@.png",[[url componentsSeparatedByString:@".gif"] firstObject],wide];
//    }else if ([url containsString:@".GIF"]) {
//        clipStr = [NSString stringWithFormat:@"%@_%@.png",[[url componentsSeparatedByString:@".GIF"] firstObject],wide];
//    }
    else if ([url containsString:@".bmp"]) {
        clipStr = [NSString stringWithFormat:@"%@_%@.bmp",[[url componentsSeparatedByString:@".bmp"] firstObject],wide];
    }else if ([url containsString:@".BMP"]) {
        clipStr = [NSString stringWithFormat:@"%@_%@.BMP",[[url componentsSeparatedByString:@".BMP"] firstObject],wide];
    }else if ([url containsString:@".jpeg"]) {
        clipStr = [NSString stringWithFormat:@"%@_%@.jpeg",[[url componentsSeparatedByString:@".jpeg"] firstObject],wide];
    }else if ([url containsString:@".JPEG"]) {
        clipStr = [NSString stringWithFormat:@"%@_%@.JPEG",[[url componentsSeparatedByString:@".JPEG"] firstObject],wide];
    }else{
        clipStr = self;
    }
    
    return clipStr;
}
#pragma mark -- base64  加密解密

- (NSString *)base64StringFromText{
    if (self && self.length>0) {
        NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
        return [self base64EncodedStringFrom:data];
    }
    return @"";
}
- (NSString *)textFromBase64String{
    if (self && self.length>0) {
        NSData *data = [self dataWithBase64EncodedString:self];
        
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return @"";
}

- (NSString *)base64EncodedStringFrom:(NSData *)data
{
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

- (NSData *)dataWithBase64EncodedString:(NSString *)string
{
    if (string == nil || [string length] == 0)
        return [NSData data];
    
    static char *decodingTable = NULL;
    if (decodingTable == NULL)
    {
        decodingTable = malloc(256);
        if (decodingTable == NULL)
            return nil;
        memset(decodingTable, CHAR_MAX, 256);
        NSUInteger i;
        for (i = 0; i < 64; i++)
            decodingTable[(short)encodingTable[i]] = i;
    }
    
    const char *characters = [string cStringUsingEncoding:NSASCIIStringEncoding];
    if (characters == NULL)     //  Not an ASCII string!
        return nil;
    char *bytes = malloc((([string length] + 3) / 4) * 3);
    if (bytes == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (YES)
    {
        char buffer[4];
        short bufferLength;
        for (bufferLength = 0; bufferLength < 4; i++)
        {
            if (characters[i] == '\0')
                break;
            if (isspace(characters[i]) || characters[i] == '=')
                continue;
            buffer[bufferLength] = decodingTable[(short)characters[i]];
            if (buffer[bufferLength++] == CHAR_MAX)      //  Illegal character!
            {
                free(bytes);
                return nil;
            }
        }
        
        if (bufferLength == 0)
            break;
        if (bufferLength == 1)      //  At least two characters are needed to produce one byte!
        {
            free(bytes);
            return nil;
        }
        
        //  Decode the characters in the buffer to bytes.
        bytes[length++] = (buffer[0] << 2) | (buffer[1] >> 4);
        if (bufferLength > 2)
            bytes[length++] = (buffer[1] << 4) | (buffer[2] >> 2);
        if (bufferLength > 3)
            bytes[length++] = (buffer[2] << 6) | buffer[3];
    }
    
    bytes = realloc(bytes, length);
    return [NSData dataWithBytesNoCopy:bytes length:length];
}

#pragma mark -- DES 加密解密
//加密
- (NSString *)encryptWithText{
    return [self encrypt:self encryptOrDecrypt:kCCEncrypt key:@"gomaster"];
}
//解密
- (NSString *)decryptWithText{
    return [self encrypt:self encryptOrDecrypt:kCCDecrypt key:@"gomaster"];
}
- (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key
{
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递过来的是decrypt 解码
    {
        //解码 base64
        NSData *decryptData =[self dataWithBase64EncodedString:sText];//转成utf-8并decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    /*
     DES加密 ：用CCCrypt函数加密一下，然后用base64编码下，传过去
     DES解密 ：把收到的数据根据base64，decode一下，然后再用CCCrypt函数解密，得到原本的数据
     */
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    NSString *initIv = @"gomaster";
    const void *vkey = (const void *) [key UTF8String];
    const void *iv = (const void *) [initIv UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,  //密钥    加密和解密的密钥必须一致
                       kCCKeySizeDES,//   DES 密钥的大小（kCCKeySizeDES=8）
                       iv, //  可选的初始矢量
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //得到解密出来的data数据，改变为utf-8的字符串
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
    }
    else //encryptOperation==0  （加密过程中，把加好密的数据转成base64的）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result =[self base64EncodedStringFrom:data];
    }
    
    return result;
}


+(NSString *)UUID{
    
    // 读取设备号
    NSString *UUID = [SAMKeychain passwordForService:SERVICE account:@"UUID"];
    if ([UUID isEqualToString:@""] ||!UUID) {
        // 如果没有UUID 则保存设备号
        CFUUIDRef deviceId = CFUUIDCreate(NULL);
        assert(deviceId != NULL);
        CFStringRef deviceIdStr = CFUUIDCreateString(NULL, deviceId);
         UUID = [NSString stringWithFormat:@"%@", deviceIdStr];
        [SAMKeychain setPassword:UUID forService:SERVICE account:@"UUID"];
       
    }
    
    return UUID;
}


@end
