//
//  MineInfoViewController.h
//  MasterKA
//
//  Created by xmy on 16/4/15.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewController.h"
#import "MineRootViewController.h"
#import "SevenSwitch.h"
@interface MineInfoViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *userHeadImage;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UILabel *userSex;
@property (weak, nonatomic) IBOutlet SevenSwitch *mySwitch2;
@property (weak, nonatomic) IBOutlet UIView *sexView;
@property (weak, nonatomic) IBOutlet UITextField *signature;

@end
