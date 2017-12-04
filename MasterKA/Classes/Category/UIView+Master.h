//
//  UIView+Master.h
//  MasterKA
//
//  Created by jinghao on 15/12/10.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+Master.h"

typedef void (^GestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);

@interface UIView (Master)

#pragma mark -- UIView+Frame

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

// shortcuts for positions
@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;


@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat left;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;


@property (nonatomic,assign) NSLayoutConstraint *widthConstraint;
@property (nonatomic,assign) NSLayoutConstraint *heightConstraint;


#pragma mark --  UIView+loadNib


+ (UINib *)loadNib;
+ (UINib *)loadNibNamed:(NSString*)nibName;
+ (UINib *)loadNibNamed:(NSString*)nibName bundle:(NSBundle *)bundle;
+ (instancetype)loadInstanceFromNib;
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName;
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner;
+ (instancetype)loadInstanceFromNibWithName:(NSString *)nibName owner:(id)owner bundle:(NSBundle *)bundle;
- (void)fillet;
- (void)fillet:(CGFloat)radius;
- (void)fillet:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor*)color;

#pragma mark --  UIView+BlockGesture
/**
 *  @brief  添加tap手势
 *
 *  @param block 代码块
 */
- (void)setTapActionWithBlock:(GestureActionBlock)block;
/**
 *  @brief  添加长按手势
 *
 *  @param block 代码块
 */
- (void)setLongPressActionWithBlock:(GestureActionBlock)block;


- (UIImage*)viewImage;
#pragma mark -- viewcontroler

/**
 *  找到当前view所在的viewcontroler
 */
@property (readonly) UIViewController *superViewController;

@end
