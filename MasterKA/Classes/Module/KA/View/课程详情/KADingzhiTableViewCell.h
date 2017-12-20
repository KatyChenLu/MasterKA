//
//  KADingzhiTableViewCell.h
//  MasterKA
//
//  Created by ChenLu on 2017/12/8.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KADingzhiTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (void)showDingzhiDetail:(NSDictionary *)dic ;
@end
