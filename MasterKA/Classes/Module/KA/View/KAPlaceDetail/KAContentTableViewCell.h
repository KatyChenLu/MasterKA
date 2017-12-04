//
//  KAContentTableViewCell.h
//  MasterKA
//
//  Created by ChenLu on 2017/11/29.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KAContentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentBottom;
@property (weak, nonatomic) IBOutlet UIImageView *rightIcon;
- (void)configueCellWithModel:(NSDictionary * )dic;
@end
