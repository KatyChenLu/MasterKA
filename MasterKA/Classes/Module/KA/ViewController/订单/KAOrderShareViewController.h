//
//  KAOrderShareViewController.h
//  MasterKA
//
//  Created by ChenLu on 2017/12/20.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "BaseViewController.h"

@interface KAOrderShareViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *shareImgView;
@property (weak, nonatomic) IBOutlet UILabel *shareTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *erweimaImgView;
@property (weak, nonatomic) IBOutlet UILabel *conLabel;
- (void)showShareOrder:(NSDictionary *)dic;
@property (nonatomic, strong)NSString *oid;
@property (nonatomic, strong)NSString *orderStatus;
@end
