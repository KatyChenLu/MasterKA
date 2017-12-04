//
//  MineCommentVC.h
//  MasterKA
//
//  Created by xmy on 16/5/18.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewController.h"
@protocol rerfeshCommentBall <NSObject>
- (void)rerfeshCommentBall:(NSString *)identity;
@end
@interface MineCommentVC : BaseViewController
@property (nonatomic, assign) id <rerfeshCommentBall> delegate;
@end
