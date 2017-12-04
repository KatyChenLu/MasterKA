//
//  NoneQuestionCell.h
//  MasterKA
//
//  Created by ChenLu on 2017/8/14.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoneQuestionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *questionBtn;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (nonatomic ,copy)void(^moreClick)();
@end
