//
//  UILabel+Master.h
//  HiGoMaster
//
//  Created by jinghao on 15/3/9.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Master)
@property (nonatomic)BOOL canCopy;

-(void)addHotspotHandler;
- (void)setEmojiText:(NSString*)text;
- (void)setEmojiText:(NSString *)text attributes:(NSDictionary *)attrs;
- (void)checkPhoneAndLink;
- (void)setParagraphText:(NSString*)text;
/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;

@end
