//
//  KAMomentFooterView.h
//  MasterKA
//
//  Created by ChenLu on 2017/12/11.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KAMomentFooterView : UIView

@property (weak, nonatomic) IBOutlet UILabel *courseTitle;
@property (weak, nonatomic) IBOutlet UIImageView *courseCover;
@property (weak, nonatomic) IBOutlet UILabel *courseTime;
@property (weak, nonatomic) IBOutlet UILabel *coursePeople;
@property (weak, nonatomic) IBOutlet UILabel *coursePrice;
@property (weak, nonatomic) IBOutlet UIButton *colloctAction;
@property (nonatomic, strong)NSString *kaCourseId;
- (void)showDetailFooterView:(NSDictionary *)dic;
@property (nonatomic, copy) void(^colloctBlock)(NSString *kaCourseid);
@property (nonatomic, copy) void(^cancelColloctBlock)(NSString *kaCourseid);

@end
