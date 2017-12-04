//
//  UIButton+Master.h
//  HiGoMaster
//
//  Created by jinghao on 15/2/6.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Master)
- (void)buttonTextCenter;

- (void)setImageUrlForState:(UIControlState)state
                    withUrl:(NSString *)url
           placeholderImage:(UIImage *)placeholderImage;
- (void)setBackgroundImageUrlForState:(UIControlState)state
                              withUrl:(NSString *)url
                     placeholderImage:(UIImage *)placeholderImage;

- (void)centerImageAndTitle:(float)space;
- (void)centerImageAndTitle;
- (void)rightImage;
- (void)rightImage:(float)spacing;


@property(nonatomic , strong) NSString * cityStr;

@end
