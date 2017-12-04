//
//  CouseDetailCell.m
//  HiMaster3
//
//  Created by hyu on 16/5/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "CouseDetailCell.h"

@implementation CouseDetailCell
#define IMGVIEW_WIDTH ([UIScreen mainScreen].bounds.size.width/9.4)
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showCourseDetail:(id)detail{
    if([detail isKindOfClass:[NSDictionary class]]){
        if(detail[@"coupon_id"]||detail[@"card_id"]){
            [self selectViewShow:1];
            if(detail[@"coupon_id"]){
                [_cardOrCoupon setImage:[UIImage imageNamed:@"quan"]];
                _name.text=detail[@"coupon_name"];
                _brief.text=detail[@"coupon_brief"];
            }else{
                [_cardOrCoupon setImage:[UIImage imageNamed:@"ka"]];
                _name.text=detail[@"card_name"];
                _brief.text=detail[@"card_brief"];
            }
        }else if (detail[@"course_cfg_id"]){
            [self selectViewShow:2];
        }
    }else{
        NSArray *students=detail;
        if(students.count>0){
              [self selectViewShow:3];
            for (int i=0;i<[_studentView subviews].count-2;i++) {
                UIImageView* imgView=(UIImageView *)[_studentView viewWithTag:(i+10)];
                if(i < students.count){
                    imgView.hidden=false;
                    imgView.cornerRadius=IMGVIEW_WIDTH/2;
                    [imgView setImageWithURLString:[[detail objectAtIndex:i] objectForKey:@"img_top"] placeholderImage:nil];
                }else{
                    imgView.hidden=YES;
                }
            }
        }
    }

}
-(void)selectViewShow:(NSInteger)identifier {
    switch (identifier) {
        case 1:
            _cardView.hidden=false;
            _cardHeight.constant=70;
            _detailView.hidden=YES;
            _detailHeight.constant=0;
            _studentView.hidden=YES;
            _student_height.constant=0;
            _course_cfgView.hidden=YES;
            _course_cfgHeight.constant=0;
            break;
        case 2:
            _cardView.hidden=YES;
            _cardHeight.constant=0;
            _detailView.hidden=YES;
            _detailHeight.constant=0;
            _studentView.hidden=YES;
            _student_height.constant=0;
            _course_cfgView.hidden=NO;
            _course_cfgHeight.constant=88;

            break;
        case 3:
            _cardView.hidden=YES;
            _cardHeight.constant=0;
            _detailView.hidden=YES;
            _detailHeight.constant=0;
            _studentView.hidden=NO;
            _student_height.constant=128;
            _course_cfgView.hidden=YES;
            _course_cfgHeight.constant=0;
            break;
        default:
            break;
    }
}

@end
