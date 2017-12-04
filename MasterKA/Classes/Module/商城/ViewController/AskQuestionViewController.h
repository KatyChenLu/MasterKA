//
//  AskQuestionViewController.h
//  MasterKA
//
//  Created by ChenLu on 2017/8/10.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "BaseViewController.h"

@interface AskQuestionViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *questionTextView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end
