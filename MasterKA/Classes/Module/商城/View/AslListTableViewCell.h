//
//  AslListTableViewCell.h
//  MasterKA
//
//  Created by ChenLu on 2017/8/10.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AslListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *askLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *answerNumTop;

@property (nonatomic, copy) NSString * questionId;
- (void)showAskList:(NSDictionary *)dic;
@end
