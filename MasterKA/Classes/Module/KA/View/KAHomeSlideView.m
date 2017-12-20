//
//  KAHomeSlideView.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/11.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAHomeSlideView.h"

@implementation KAHomeSlideView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)dingdanAction:(id)sender {
    self.finishSlide(@"dingdan");
}
- (IBAction)xiangceAction:(id)sender {
    self.finishSlide(@"xiangce");
}
- (IBAction)shoucangAction:(id)sender {
    self.finishSlide(@"shoucang");
}
- (IBAction)settingAction:(id)sender {
    self.finishSlide(@"setting");
}
- (IBAction)loginBtnAction:(id)sender {
    self.todoLogin();
}
- (IBAction)headerBtnAction:(id)sender {
    self.todoLogin();
}


@end
