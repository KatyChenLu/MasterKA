//
//  ViewControllerAnimation.h
//  MasterKA
//
//  Created by jinghao on 15/12/18.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ViewControllerAnimationType) {
    ViewControllerAnimationNone,
    ViewControllerAnimationDefault,        // slow at beginning and end
    ViewControllerAnimationFadeIn
};

@interface ViewControllerAnimation : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic)ViewControllerAnimationType animationType ;
@property (nonatomic)NSTimeInterval animationTime;
@end
