//
//  UINavigationBar+Master.h
//  MasterKA
//
//  Created by jinghao on 15/12/30.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (Master)
@property (nonatomic)CGFloat backgroundImageAlpha;
@property (nonatomic,strong)UIColor *backgroundImageColor;
@property (nonatomic,strong)UIColor *shadowImageColor;

//- (void)setBackgroundColorForImage:(UIColor *)color;
//- (void)setShadowImageOfColor:(UIColor *)color;
//- (void)setBackgroundImageAlpha:(float)alpha;
@end
