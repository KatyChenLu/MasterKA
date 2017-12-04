//
//  NSAttributedString+Master.h
//  HiGoMaster
//
//  Created by jinghao on 15/4/13.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EmojiTextAttachment:NSTextAttachment
@property(strong, nonatomic) NSString *emojiTag;
@property (nonatomic,assign) NSRange  range;
@end

@interface NSAttributedString (Master)

//-----------------------------------------------------实例方法-----------------------------------------------------
/*
 * 返回绘制NSAttributedString所需要的区域
 */
- (CGRect)boundsWithSize:(CGSize)size;

//-----------------------------------------------------静态方法-----------------------------------------------------

/*
 * 返回绘制文本需要的区域
 */
+ (CGRect)boundsForString:(NSString *)string size:(CGSize)size attributes:(NSDictionary *)attrs;

/*
 * 返回Emotion替换过的 NSAttributedString
 */
+ (NSAttributedString *)emotionAttributedStringFrom:(NSString *)string attributes:(NSDictionary *)attrs;

- (void)addEmoji:(NSString*)emojiStr image:(UIImage*)image;
- (NSString *)getPlainString;
@end
