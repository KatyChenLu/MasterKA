//
//  UINavigationItem+Master.h
//  MasterKA
//
//  Created by jinghao on 15/12/31.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (Master)

@property (nonatomic, assign) CGFloat leftMargin;
@property (nonatomic, assign) CGFloat rightMargin;
@property (nullable,nonatomic, assign) NSString *backTitle;

+ (CGFloat)systemMargin;

- (void)lockRightItem:(BOOL)lock;
- (void)lockLeftItem:(BOOL)lock;

- (void)addLeftBarButtonItem:(nullable UIBarButtonItem *)item animated:(BOOL)animated;
- (void)addRightBarButtonItem:(nullable UIBarButtonItem *)item animated:(BOOL)animated;
- (void)removeRightBarButtonItem:(nullable UIBarButtonItem *)item animated:(BOOL)animated;



@end
