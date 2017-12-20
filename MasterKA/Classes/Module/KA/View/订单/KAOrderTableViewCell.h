//
//  KAOrderTableViewCell.h
//  MasterKA
//
//  Created by ChenLu on 2017/12/20.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface KAOrderTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *KAtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *KAimgV;
@property (weak, nonatomic) IBOutlet UILabel *KAtime;
@property (weak, nonatomic) IBOutlet UILabel *KApeopleNum;
@property (weak, nonatomic) IBOutlet UILabel *KAPrice;
@property (weak, nonatomic) IBOutlet UIImageView *peopleNumImgView;
@property (weak, nonatomic) IBOutlet UIImageView *dizhiImgView;
@property (weak, nonatomic) IBOutlet UIButton *tongzhiBtn;
@property (weak, nonatomic) IBOutlet UIImageView *yijianImgView;
@property (weak, nonatomic) IBOutlet UILabel *qiLabel;

@property (weak, nonatomic) IBOutlet UIImageView *statueImgView;
@property (weak, nonatomic) IBOutlet UIImageView *yizhongzhiImgView;



//订单id
@property (nonatomic, strong)NSString *oid;
//订单状态
@property (nonatomic, strong)NSString *orderStatus;
- (void)showKAOrder:(NSDictionary *)dic;
@end
