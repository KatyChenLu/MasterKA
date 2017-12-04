//
//  UITextView+Master.h
//  HiGoMaster
//
//  Created by jinghao on 15/4/13.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSAttributedString+Master.h"
@interface UITextView (Master)

@property (nonatomic, readonly) UILabel *placeholderLabel;
@property (nonatomic, strong) NSString *placeholderStr;
@property (nonatomic, strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic, strong) UIColor *placeholderColor;

+ (UIColor *)defaultPlaceholderColor;

- (void)checkAttachment;
- (BOOL)deleteEmojiValue;
- (void)addEmojiValue:(NSString*)value;
- (NSString*)emojiText;
@end
