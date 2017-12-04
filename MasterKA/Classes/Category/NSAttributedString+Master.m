//
//  NSAttributedString+Master.m
//  HiGoMaster
//
//  Created by jinghao on 15/4/13.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//
#import "NSAttributedString+Master.h"
#import "EmojiEmoticons.h"
#import "FaceUtil.h"

@implementation EmojiTextAttachment
- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex
{
    return CGRectMake( 0 , -5, 20, 20);
}
@end

@implementation NSAttributedString (Master)

/*
 * 返回绘制NSAttributedString所需要的区域
 */
- (CGRect)boundsWithSize:(CGSize)size
{
    CGRect contentRect = [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return contentRect;
}

/*
 * 返回绘制文本需要的区域
 */
+ (CGRect)boundsForString:(NSString *)string size:(CGSize)size attributes:(NSDictionary *)attrs
{
    NSAttributedString *attributedString = [NSAttributedString emotionAttributedStringFrom:string attributes:attrs];
    CGRect contentRect = [attributedString boundingRectWithSize:size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil];
    return contentRect;
}

/*
 * 返回Emotion替换过的 NSAttributedString
 */
+ (NSAttributedString *)emotionAttributedStringFrom:(NSString *)string attributes:(NSDictionary *)attrs
{
    
    
    NSMutableAttributedString *attributedEmotionString = [[NSMutableAttributedString alloc] initWithString:string attributes:attrs];
    NSArray *attachmentArray = [NSAttributedString attachmentsForAttributedString:attributedEmotionString];
    for (int i = (int)attachmentArray.count -1; i >= 0; i--){
        EmojiTextAttachment *attachment = attachmentArray[i];
        NSAttributedString *emotionAttachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        [attributedEmotionString replaceCharactersInRange:attachment.range withAttributedString:emotionAttachmentString];
    }

//    for (EmojiTextAttachment *attachment in attachmentArray)
//    {
//        NSAttributedString *emotionAttachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
//        [attributedEmotionString replaceCharactersInRange:attachment.range withAttributedString:emotionAttachmentString];
//    }
//    [attributedEmotionString addAttributes:attrs range:NSMakeRange(0, attributedEmotionString.length-1)];
    return attributedEmotionString;
}

+ (NSArray *)attachmentsForAttributedString:(NSMutableAttributedString *)attributedString
{
    NSDictionary* faceDict = [FaceUtil getFaceDictionary];
    NSString * regexStr = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    NSMutableArray* emojiAttributedString = [[NSMutableArray alloc] init];
    NSError* error;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:&error];
    NSString *string = attributedString.string;
    if (regex !=nil) {
        NSArray* emjoiArray = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
        for(NSTextCheckingResult *match in emjoiArray) {
            NSString *subStr = [string substringWithRange:[match range]];
            NSUInteger index = [faceDict.allValues indexOfObject:subStr];
            if (index != NSNotFound) {
                NSString* emojiKey = [faceDict.allKeys objectAtIndex:index];
                EmojiTextAttachment *emojiTextAttachment = [EmojiTextAttachment new];
                emojiTextAttachment.emojiTag = subStr;
                emojiTextAttachment.image = [UIImage imageNamed:emojiKey];
                emojiTextAttachment.range = [match range];
                [emojiAttributedString addObject:emojiTextAttachment];
            }
        }
    }
    return emojiAttributedString;
}

- (void)addEmoji:(NSString*)emojiStr image:(UIImage*)image{
    
}

- (NSString *)getPlainString {
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      if (value && [value isKindOfClass:[EmojiTextAttachment class]]) {
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:((EmojiTextAttachment *) value).emojiTag];
                          base += ((EmojiTextAttachment *) value).emojiTag.length - 1;
                      }
                  }];
    
    return plainString;
}

@end
