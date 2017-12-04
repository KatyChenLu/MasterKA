//
//  AskDetailTableViewCell.h
//  MasterKA
//
//  Created by ChenLu on 2017/8/11.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AskDetailTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)showAskDetailList:(NSDictionary *)dic;
@end
