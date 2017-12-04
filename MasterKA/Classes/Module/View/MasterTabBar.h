//
//  MasterTabBar.h
//  MasterKA
//
//  Created by jinghao on 16/1/7.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MasterTabBarDelegate <NSObject>

@optional

- (void)ChangSelectIndexForm:(NSInteger)from to:(NSInteger)to;

@end

@interface MasterTabBar : UIView
@property (nonatomic,weak) id<MasterTabBarDelegate> delegate;

@end
