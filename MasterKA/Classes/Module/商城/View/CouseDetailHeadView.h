//
//  CouseDetailHeadView.h
//  MasterKA
//
//  Created by hyu on 16/5/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouseDetailHeadView : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headCover;
@property (weak, nonatomic) IBOutlet UILabel *courseTitle;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *course_store;
@property (weak, nonatomic) IBOutlet UILabel *time_period;
@property (weak, nonatomic) IBOutlet UILabel *adress;
@property (weak, nonatomic) IBOutlet UIImageView *hide;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightStore;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineToImage;
@property (weak, nonatomic) IBOutlet UILabel *discount;
@property (weak, nonatomic) IBOutlet UIImageView *discountImg;

@end
