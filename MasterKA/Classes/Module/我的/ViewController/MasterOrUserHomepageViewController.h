//
//  MasterOrUserHomepageViewController.h
//  MasterKA
//
//  Created by hyu on 16/5/23.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewController.h"
#import "MyDetailCell.h"
@interface MasterOrUserHomepageViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UIButton *question;
@property (weak, nonatomic) IBOutlet UIButton *dianZan;
@property (weak, nonatomic) IBOutlet UIButton *attention;
@property (nonatomic,strong)MyDetailCell *mineHeadView;
@end
