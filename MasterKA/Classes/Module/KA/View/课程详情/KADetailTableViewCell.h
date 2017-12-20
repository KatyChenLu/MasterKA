//
//  KADetailTableViewCell.h
//  MasterKA
//
//  Created by ChenLu on 2017/10/12.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KADetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dingzhiImg;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *zhuangshiImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;

- (void)showDetail:(NSDictionary *)dic;
- (void)showDingzhiDetail:(NSDictionary *)dic;
@end
