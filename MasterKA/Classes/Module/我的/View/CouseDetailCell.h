//
//  CouseDetailCell.h
//  HiMaster3
//
//  Created by hyu on 16/5/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CouseDetailCell : UITableViewCell
-(void)showCourseDetail:(id)detail;
@property (weak, nonatomic) IBOutlet UIImageView *cardOrCoupon;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *brief;
@property (weak, nonatomic) IBOutlet UILabel *custom_spec_name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIImageView *img_top;
@property (weak, nonatomic) IBOutlet UILabel *nikename;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *course_cfgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *student_height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cardHeight;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UIView *studentView;
@property (weak, nonatomic) IBOutlet UIView *course_cfgView;

@end
