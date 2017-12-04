//
//  UIStoryboard+Master.h
//  MasterKA
//
//  Created by jinghao on 15/12/22.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIStoryboard (Master)
+ (UIViewController*)rootViewController:(NSString*)storyboard;
+ (UIViewController*)viewController:(NSString*)storyboard identifier:(NSString*)identifier ;

@end
