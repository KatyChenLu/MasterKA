//
//  MinePrivateListVC.h
//  MasterKA
//
//  Created by xmy on 16/5/18.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewController.h"
@protocol rerfeshMinePrivateBall <NSObject>
- (void)rerfeshMinePrivateBall:(NSString *)identity;
@end
@interface MinePrivateListVC : BaseViewController
@property (nonatomic, assign) id <rerfeshMinePrivateBall> delegate;

@end
