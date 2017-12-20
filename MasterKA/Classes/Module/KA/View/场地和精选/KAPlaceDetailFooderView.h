//
//  KAPlaceDetailFooderView.h
//  MasterKA
//
//  Created by ChenLu on 2017/12/6.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KAPlaceDetailFooderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *courseTitle;
@property (weak, nonatomic) IBOutlet UIImageView *courseCover;
@property (weak, nonatomic) IBOutlet UILabel *courseTime;
@property (weak, nonatomic) IBOutlet UILabel *coursePeople;
@property (weak, nonatomic) IBOutlet UILabel *coursePrice;
- (void)showDetailFooterView:(NSDictionary *)dic;
@end
