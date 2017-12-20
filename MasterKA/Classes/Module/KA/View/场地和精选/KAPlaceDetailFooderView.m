//
//  KAPlaceDetailFooderView.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/6.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAPlaceDetailFooderView.h"

@implementation KAPlaceDetailFooderView
- (void)showDetailFooterView:(NSDictionary *)dic {
    self.courseTitle.text = dic[@"course_title"];
    self.coursePrice.text = dic[@"course_price"];
    self.courseTime.text = dic[@"course_time"];
    self.coursePeople.text = dic[@"people_num"];
    
    [self.courseCover setImageFadeInWithURLString:dic[@"moment_img_top"] placeholderImage:nil];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
