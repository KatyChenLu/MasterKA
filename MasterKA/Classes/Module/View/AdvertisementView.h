//
//  AdvertisementView.h
//  MasterKA
//
//  Created by jinghao on 16/5/30.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdvertisementView : UIView
@property (nonatomic,weak)IBOutlet UIImageView *AdImageView;
@property (nonatomic,strong)NSDictionary *adData;

- (void)hiddenAnimated:(BOOL)animated;

- (void)showAnimated:(BOOL)animated inView:(UIView*)inView;

@end
