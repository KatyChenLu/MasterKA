//
//  KAPlaceDetailFooderView.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/25.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAPlaceDetailFooderView.h"

@implementation KAPlaceDetailFooderView
- (void)showPlaceDetailFooterView:(NSDictionary *)dic {
    self.courseTitle.text = dic[@"course_title"];
    self.courseTitle.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    self.coursePrice.text = [NSString stringWithFormat:@"￥%@",dic[@"course_price"]];
    self.coursePrice.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    self.courseTime.text = dic[@"course_time"];
    self.coursePeople.text =  [NSString stringWithFormat:@"%@人起",dic[@"people_num"]];
    self.kaCourseId = dic[@"ka_course_id"];
//    [self.courseCover setImageFadeInWithURLString:dic[@"course_cover"] placeholderImage:nil];
    [self.courseCover setImageFadeInWithURLString:[dic[@"course_cover"] ClipImageUrl:[NSString stringWithFormat:@"%f",96*0.75*ScreenScale]] placeholderImage:nil];
    self.colloctBtn.selected = [dic[@"is_like"] integerValue];
}

- (IBAction)voteBtnAction:(id)sender {
     if ([(BaseViewController *)self.superViewController doLogin]) {
    if (self.colloctBtn.isSelected) {
        self.cancelColloctBlock(self.kaCourseId);
    }else{
        self.colloctBlock(self.kaCourseId);
    }
    self.colloctBtn.selected = !self.colloctBtn.selected;
     }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
