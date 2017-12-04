//
//  KAPreVoteTableViewCell.h
//  MasterKA
//
//  Created by ChenLu on 2017/11/21.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface KAPreVoteTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *KAtitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *KApreVoteBtn;
@property (weak, nonatomic) IBOutlet UIImageView *KAimgV;
@property (weak, nonatomic) IBOutlet UILabel *KAtime;
@property (weak, nonatomic) IBOutlet UILabel *KApeopleNum;
@property (weak, nonatomic) IBOutlet UILabel *KAPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imvBotton;

@property (nonatomic, copy) void(^selectClick)(NSString *kaid);
@property (nonatomic, copy) void(^disselectClick)(NSString *kaid);
- (void)showKAPreVoteDetail:(NSDictionary *)dic;
@end
