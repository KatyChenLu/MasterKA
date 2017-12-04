//
//  MyHeadViewCell.h
//  MasterKA
//
//  Created by hyu on 16/5/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHeadViewCell : UITableViewCell
@property (nonatomic,weak)IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *mashangDenglu;

@property (weak, nonatomic) IBOutlet UIButton *changeInfo;

@property (weak, nonatomic) IBOutlet UILabel *noDenglu;

@end
