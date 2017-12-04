//
//  UITabBar+Master.m
//  MasterKA
//
//  Created by jinghao on 16/5/4.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "UITabBar+Master.h"
#import "UIImage+Master.h"
#import <objc/runtime.h>

static NSString *backgroundColorForImageKey = @"BackgroundColorForImage";
static NSString *shadowImageColorForImageKey = @"shadowImageColorForImage";
static NSString *backgroundColorForAlphaKey = @"backgroundColorForAlpha";

@implementation UITabBar (Master)
- (void)setBackgroundImageColor:(UIColor *)backgroundImageColor{
    objc_setAssociatedObject(self, &backgroundColorForImageKey, backgroundImageColor, OBJC_ASSOCIATION_COPY);
    [self setBackgroundImage:[UIImage imageWithColor:backgroundImageColor]];
    if (self.shadowImageColor==nil) {
        [self setShadowImageColor:backgroundImageColor];
    }
}

- (UIColor*)backgroundImageColor{
    return objc_getAssociatedObject(self, &backgroundColorForImageKey);
}

- (void)setShadowImageColor:(UIColor *)shadowImageColor{
    objc_setAssociatedObject(self, &shadowImageColorForImageKey, shadowImageColor, OBJC_ASSOCIATION_COPY);
    [self setShadowImage:[UIImage imageWithColor:shadowImageColor]];
}

- (UIColor*)shadowImageColor{
    return objc_getAssociatedObject(self, &shadowImageColorForImageKey);
}

- (void)setBackgroundImageAlpha:(CGFloat)backgroundImageAlpha{
    if (backgroundImageAlpha<0) {
        backgroundImageAlpha = 0;
    }else if(backgroundImageAlpha>1){
        backgroundImageAlpha = 1.0f;
    }
    if (backgroundImageAlpha==self.backgroundImageAlpha) {
        return;
    }
    objc_setAssociatedObject(self, &backgroundColorForAlphaKey, [NSNumber numberWithFloat:backgroundImageAlpha], OBJC_ASSOCIATION_RETAIN_NONATOMIC);;
    UIColor *color = objc_getAssociatedObject(self, &backgroundColorForImageKey);
    if(color){
        color = [color colorWithAlphaComponent:backgroundImageAlpha];
        [self setBackgroundImage:[UIImage imageWithColor:color]];
    }
    UIColor *shadowColor = objc_getAssociatedObject(self, &shadowImageColorForImageKey);
    if(shadowColor){
        shadowColor = [shadowColor colorWithAlphaComponent:backgroundImageAlpha];
        [self setShadowImage:[UIImage imageWithColor:shadowColor]];
    }
}

- (CGFloat)backgroundImageAlpha{
    NSNumber *alpha = objc_getAssociatedObject(self, &backgroundColorForAlphaKey);
    if (alpha) {
        return [alpha floatValue];
    }else{
        return 1.0f;
    }
}


- (CGSize)sizeThatFits:(CGSize)size
{
        if (IsPhoneX) {
            return CGSizeMake(size.width, 88);
        }
    return CGSizeMake(size.width, CustomTabBarHeight);
}

@end