//
//  AskQuestionsCell.h
//  MasterKA
//
//  Created by ChenLu on 2017/8/9.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AskQuestionsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *askLabel;
@property (weak, nonatomic) IBOutlet UILabel *askNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UIButton *showAllButton;
@property (copy, nonatomic) NSString *questionTime;
@property (copy, nonatomic) NSString *questionId;
@property (nonatomic ,copy)void(^moreClick)();

- (void)showAskCell:(NSDictionary *)dic;
@end
