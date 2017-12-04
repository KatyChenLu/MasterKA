//
//  CommonSelectViewController.h
//  HiGoMaster
//
//  Created by jinghao on 15/9/10.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "BaseViewController.h"

@interface CommonSelectViewController : BaseViewController

+ (CommonSelectViewController*)initCommonSelectViewController;

@property (nonatomic,assign)NSInteger selectIndex;
@property (nonatomic,strong)NSArray* selectTextArray;

- (void)popViewControllerIn:(UIViewController *)poppedVC;

- (void)popViewControllerIn:(UIViewController *)poppedVC cancelBlock:(void (^)(void))cancelBlock sureBlock:(void (^)(void))sureBlock;
- (void)dismissPopController;
@end
