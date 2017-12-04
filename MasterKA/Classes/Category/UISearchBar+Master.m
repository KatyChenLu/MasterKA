//
//  UISearchBar+Master.m
//  MasterKA
//
//  Created by jinghao on 16/5/3.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "UISearchBar+Master.h"

@implementation UISearchBar (Master)
- (void)setSearchTextFieldBackgroundColor:(UIColor *)backgroundColor
{
    [self setSearchFieldBackgroundImage:[UIImage imageWithColor:backgroundColor size:CGSizeMake(10, 30)] forState:UIControlStateNormal];
//    float version = [[[ UIDevice currentDevice ] systemVersion ] floatValue ];
//    UIView *searchTextField = nil;
//    self.backgroundColor=[UIColor clearColor];
//    for (UIView *view in self.subviews)
//    {
//        for (UIView* subView in [view subviews]) {
//            if([subView isKindOfClass:[UITextField class]])
//            {
//                subView.backgroundColor = backgroundColor;
//            }
//            else if ([subView isKindOfClass:[UIButton class]])
//            {
//                UIButton* button = (UIButton*)subView;
//                [button setTintColor:self.barTintColor];
//                [button setTitleColor:self.barTintColor forState:UIControlStateNormal];
//            }
//        }
//        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
//            [[view.subviews objectAtIndex:0] removeFromSuperview];
//            break;
//        }
//    }
}

- (void)setTextFiledRadius:(float)radius
{
    for (UIView *view in self.subviews)
    {
        for (UIView* subView in [view subviews]) {
            if([subView isKindOfClass:[UITextField class]])
            {
                subView.layer.cornerRadius = radius;
            }
        }
    }
}


-(void)setSearchBarBackgroundColor:(UIColor *)backgroundColor{
    [[[[ self . subviews objectAtIndex : 0 ] subviews ] objectAtIndex : 0 ] removeFromSuperview ];
    [ self setBackgroundColor :[ UIColor colorWithHex:0xEFEFF4 ]];
}

@end
