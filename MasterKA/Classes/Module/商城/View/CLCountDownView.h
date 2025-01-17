//
//  CLCountDownView.h
//  MasterKA
//
//  Created by ChenLu on 2017/5/9.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CLCountDownViewDelegate;
@interface CLCountDownView : UIView

// 剩余的秒数
@property (nonatomic, assign) NSTimeInterval countDownTimeInterval;

// 倒计时文字的颜色
@property (nonatomic) UIColor *textColor;

// 倒计时label的背景色
@property (nonatomic) UIColor *themeColor;

// 显示时间的冒号的字体颜色
@property (nonatomic) UIColor *colonColor;

// 倒计时label的字体
@property (nonatomic) UIFont *textFont;

@property (nonatomic, weak) id <CLCountDownViewDelegate> delegate;

// 默认为NO，当进入后台一段时间后定时器将会暂停及时，再次
// 回到前台才会启动，设置为YES时弥补这种状态 如果用户更改系统时间的话，此方法不适用
@property (nonatomic, assign) BOOL recoderTimeIntervalDidInBackground;

- (void)stopCountDown;

@end

@protocol CLCountDownViewDelegate <NSObject>

- (void)countDownDidFinished;
@end
