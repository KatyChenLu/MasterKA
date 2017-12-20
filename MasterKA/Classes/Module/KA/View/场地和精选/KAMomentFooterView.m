//
//  KAMomentFooterView.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/11.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAMomentFooterView.h"

@implementation KAMomentFooterView
- (void)showDetailFooterView:(NSDictionary *)dic {
    self.courseTitle.text = dic[@"course_title"];
    self.coursePrice.text = dic[@"course_price"];
    self.courseTime.text = dic[@"course_time"];
    self.coursePeople.text = dic[@"people_num"];
    self.kaCourseId = dic[@"ka_course_id"];
    [self.courseCover setImageFadeInWithURLString:dic[@"course_cover"] placeholderImage:nil];
}
- (IBAction)colloctBtnAction:(id)sender {
    if (self.colloctBtn.isSelected) {
        self.cancelColloctBlock(self.kaCourseId);
    }else{
        self.colloctBlock(self.kaCourseId);
    }
    self.colloctBtn.selected = !self.colloctBtn.selected;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
