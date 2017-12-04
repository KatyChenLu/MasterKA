//
//  UIStoryboard+Master.m
//  MasterKA
//
//  Created by jinghao on 15/12/22.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "UIStoryboard+Master.h"

@implementation UIStoryboard (Master)
+ (UIViewController*)rootViewController:(NSString*)storyboard{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:storyboard
                                                             bundle: nil];
    return [mainStoryboard instantiateInitialViewController];

}
+ (UIViewController*)viewController:(NSString*)storyboard identifier:(NSString*)identifier
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:storyboard
                                                             bundle: nil];
    return [mainStoryboard instantiateViewControllerWithIdentifier:identifier];
}

@end
