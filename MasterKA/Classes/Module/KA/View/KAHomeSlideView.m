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
    self.finishSlide(@"shoucang");
}
- (IBAction)shoucangAction:(id)sender {
//    self.finishSlide(@"shoucang");
         NSString * phones = [UserClient sharedUserClient].server_number;
        NSString* courseMobile = phones;
        courseMobile = [courseMobile stringByReplacingOccurrencesOfString:@"、" withString:@","];
        courseMobile = [courseMobile stringByReplacingOccurrencesOfString:@"，" withString:@","];
        NSArray* phonesArray = [courseMobile componentsSeparatedByString:@","];
        UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
        actionSheet.title = @"电话号码";
        [actionSheet addButtonWithTitle:@"取消"];
        for (NSString* phone in phonesArray) {
            [actionSheet addButtonWithTitle:phone];
        }
        [actionSheet setCancelButtonIndex:0];
        [actionSheet showInView:self.superViewController.view];
        [actionSheet.rac_buttonClickedSignal subscribeNext:^(NSNumber *index) {
            if (index.integerValue>0) {
                NSString* phone = [actionSheet buttonTitleAtIndex:index.integerValue];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
            }
        } ];
        
    
    
}
- (IBAction)settingAction:(id)sender {
    self.finishSlide(@"setting");
}
- (IBAction)loginBtnAction:(id)sender {
    self.finishSlide(@"");
}
- (IBAction)headerBtnAction:(id)sender {
    self.finishSlide(@"headerBtn");
}


@end
