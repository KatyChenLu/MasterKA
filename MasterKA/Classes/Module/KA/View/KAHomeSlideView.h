//
//  KAHomeSlideView.h
//  MasterKA
//
//  Created by ChenLu on 2017/12/11.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KAHomeSlideView : UIView
@property (weak, nonatomic) IBOutlet UIButton *headImgBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *dingdanDianView;
//@property (weak, nonatomic) IBOutlet UIView *xiangceDianView;
@property (weak, nonatomic) IBOutlet UIButton *dingdanBtn;
@property (weak, nonatomic) IBOutlet UIButton *xiangceBtn;
@property (weak, nonatomic) IBOutlet UIButton *shoucangBtn;
@property (weak, nonatomic) IBOutlet UIButton *settingBtn;

@property (nonatomic, copy) void(^finishSlide)(NSString *choose);
//@property (nonatomic, copy) void(^todoLogin)();
@end
