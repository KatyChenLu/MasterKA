//
//  KAMomentHeaderView.h
//  MasterKA
//
//  Created by ChenLu on 2017/12/11.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KAMomentHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userIntro;
@property (weak, nonatomic) IBOutlet UIImageView *imgTopView;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *markBGHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *markViewHeight;
@property (nonatomic, assign) NSInteger totleHeight;

- (void)showDetailHeaderView:(NSDictionary *)dic;
@end
