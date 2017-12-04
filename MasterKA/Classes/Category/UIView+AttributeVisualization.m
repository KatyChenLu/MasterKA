//
//  UIView+AttributeVisualization.m
//  DianShiStore
//
//  Created by jinghao on 15/12/4.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "UIView+AttributeVisualization.h"
#import <objc/runtime.h>

@implementation UIView (AttributeVisualization)
#pragma mark - Dynamic Properties

- (BOOL)shouldRasterize
{
    return self.layer.shouldRasterize;
}

- (void)setShouldRasterize:(BOOL)shouldRasterize
{
    self.layer.shouldRasterize = shouldRasterize;
    if (shouldRasterize)
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (BOOL)masksToBounds
{
    return self.layer.masksToBounds;
}

- (void)setMasksToBounds:(BOOL)masksToBounds
{
    self.layer.masksToBounds = masksToBounds;
}

- (CGFloat)cornerRadius
{
    return self.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    self.layer.cornerRadius = cornerRadius;
}

- (UIColor *)borderColor
{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor
{
    self.layer.borderColor = borderColor.CGColor;
}

- (CGFloat)borderWidth
{
    return self.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    self.layer.borderWidth = borderWidth;
}

#pragma mark - Shadow

- (UIColor *)shadowColor
{
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

- (void)setShadowColor:(UIColor *)shadowColor
{
    self.layer.shadowColor = shadowColor.CGColor;
}

- (CGFloat)shadowOpacity
{
    return self.layer.shadowOpacity;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity
{
    self.layer.shadowOpacity = shadowOpacity;
}

- (CGFloat)shadowRadius
{
    return self.layer.shadowRadius;
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    self.layer.shadowRadius = shadowRadius;
}

- (CGSize)shadowOffset
{
    return self.layer.shadowOffset;
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
    self.layer.shadowOffset = shadowOffset;
}

//- (void)drawRect:(CGRect)rect{
//    NSLog(@"======= %@",self);
//}

@end
