//
//  AppAdView.h
//  HiGoMaster
//
//  Created by jinghao on 15/12/17.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AppAdViewBlock)(id data);
typedef void (^AppAdFinishBlock)();
@interface AppAdView : UIView
@property (nonatomic,weak)IBOutlet UIImageView* adImageView;
@property (nonatomic)NSInteger maxTimmer;
@property (nonatomic, copy)AppAdViewBlock appAdViewBlock;
@property (nonatomic, copy)AppAdFinishBlock appAdFinishBlock;
@property (nonatomic,copy)id  adData;
@end
