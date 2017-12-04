//
//  MyScoreDetialCell.h
//  MasterKA
//
//  Created by hyu on 16/4/29.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyScoreDetialCell : UITableViewCell
-(void)showCourse:(NSDictionary *)dic;
@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *m_price;
@property (weak, nonatomic) IBOutlet UILabel *store;
@end
