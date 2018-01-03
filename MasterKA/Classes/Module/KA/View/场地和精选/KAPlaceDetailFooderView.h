//
//  KAPlaceDetailFooderView.h
//  MasterKA
//
//  Created by ChenLu on 2017/12/25.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KAPlaceDetailFooderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *courseTitle;
@property (weak, nonatomic) IBOutlet UIImageView *courseCover;
@property (weak, nonatomic) IBOutlet UILabel *courseTime;
@property (weak, nonatomic) IBOutlet UILabel *coursePeople;
@property (weak, nonatomic) IBOutlet UILabel *coursePrice;
@property (weak, nonatomic) IBOutlet UIButton *colloctBtn;
@property (nonatomic, strong)NSString *kaCourseId;
- (void)showPlaceDetailFooterView:(NSDictionary *)dic;
@property (nonatomic, copy) void(^colloctBlock)(NSString *kaCourseid);
@property (nonatomic, copy) void(^cancelColloctBlock)(NSString *kaCourseid);
@end
