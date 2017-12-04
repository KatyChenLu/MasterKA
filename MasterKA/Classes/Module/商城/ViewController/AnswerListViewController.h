//
//  QuestionDetailViewController.h
//  MasterKA
//
//  Created by ChenLu on 2017/8/11.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "BaseViewController.h"

@interface AnswerListViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITableView *mTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *askLabel;

@end
