//
//  UIView+AttributeVisualization.h
//  DianShiStore
//
//  Created by jinghao on 15/12/4.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

//IB_DESIGNABLE

@interface UIView (AttributeVisualization)
@property (nonatomic, assign) IBInspectable BOOL shouldRasterize;
@property (nonatomic, assign) IBInspectable BOOL masksToBounds;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *borderColor;

@property (nonatomic, strong) IBInspectable UIColor *shadowColor;
@property (nonatomic, assign) IBInspectable CGFloat shadowOpacity;
@property (nonatomic, assign) IBInspectable CGFloat shadowRadius;
@property (nonatomic, assign) IBInspectable CGSize shadowOffset;
@end

//IB_DESIGNABLE
//@interface UIView (AttributeVisualization)
//@property (nonatomic, assign)  BOOL shouldRasterize;
//@property (nonatomic, assign)  BOOL masksToBounds;
//@property (nonatomic, assign)  CGFloat cornerRadius;
//@property (nonatomic, assign)  CGFloat borderWidth;
//@property (nonatomic, strong)  UIColor *borderColor;
//
//@property (nonatomic, strong)  UIColor *shadowColor;
//@property (nonatomic, assign)  CGFloat shadowOpacity;
//@property (nonatomic, assign)  CGFloat shadowRadius;
//@property (nonatomic, assign)  CGSize shadowOffset;
//@end
