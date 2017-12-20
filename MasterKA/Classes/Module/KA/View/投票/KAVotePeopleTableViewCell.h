//
//  KAVotePeopleTableViewCell.h
//  MasterKA
//
//  Created by ChenLu on 2017/12/12.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface KAVotePeopleTableViewCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *votePeopleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *votePeopleImgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
- (void)showVotePeople:(NSDictionary *)dic;
@end
