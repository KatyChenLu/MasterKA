//
//  AdvertisementView.m
//  MasterKA
//
//  Created by jinghao on 16/5/30.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "AdvertisementView.h"

@interface AdvertisementView ()
@property (nonatomic,weak)IBOutlet UIButton *closeButton;
@end

@implementation AdvertisementView

- (void)awakeFromNib
{
    
}

- (IBAction)closeButtonOnClick:(id)sender {
    [self hiddenAnimated:YES];
}

- (void)hiddenAnimated:(BOOL)animated{
    if (animated) {
        [UIView animateWithDuration:0.3f animations:^{
            CGRect frame = self.frame;
            frame.origin.y -= frame.size.height;
            self.frame = frame;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else{
        [self removeFromSuperview];
    }
}

- (void)showAnimated:(BOOL)animated inView:(UIView*)inView{
    [self removeFromSuperview];
    if (animated) {
        self.frame = CGRectMake(0, -inView.height, inView.width, inView.height);
        [inView addSubview:self];
        [UIView animateWithDuration:0.3f animations:^{
            self.frame = inView.bounds;

        } completion:^(BOOL finished) {
            
        }];
    }else{
        self.frame = inView.bounds;
        [inView addSubview:self];
    }
}

@end
