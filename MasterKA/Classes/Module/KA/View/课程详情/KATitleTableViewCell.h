//
//  KATitleTableViewCell.h
//  MasterKA
//
//  Created by ChenLu on 2017/10/12.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KATitleTableViewCell : UITableViewCell
@property (nonatomic, strong)NSString *ka_course_id;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *peopleLabel;
@property (weak, nonatomic) IBOutlet UIButton *voteBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
- (void)showTitleCell:(NSDictionary *)dic;
@property (nonatomic, copy) void(^joinClick)(NSString *ka_course_id);
@property (nonatomic, copy) void(^canceljoinClick)(NSString *ka_course_id);
@end
