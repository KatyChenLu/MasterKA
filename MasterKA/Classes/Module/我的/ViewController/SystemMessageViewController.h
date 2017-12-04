//
//  SystemMessageViewController.h
//  HiGoMaster
//
//  Created by jinghao on 15/6/16.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "BaseViewController.h"
@protocol rerfeshSystemBall <NSObject>
- (void)rerfeshSystemBall:(NSString *)identity;
@end
@interface SystemMessageViewController : BaseViewController

@property (nonatomic, assign) id <rerfeshSystemBall> delegate;
@end
