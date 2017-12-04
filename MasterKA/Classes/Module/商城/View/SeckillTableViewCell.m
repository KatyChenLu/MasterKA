//
//  SeckillTableViewCell.m
//  MasterKA
//
//  Created by ChenLu on 2017/4/21.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "SeckillTableViewCell.h"

@interface SeckillTableViewCell()<CLCountDownViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *miaoshaHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceHeight;

@end

@implementation SeckillTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showSeckillDetail:(NSDictionary *)detail {
    _countDownView.themeColor = MasterDefaultColor;
    _countDownView.delegate = self;
    _countDownView.textColor = [UIColor darkGrayColor];
    _countDownView.textFont = [UIFont boldSystemFontOfSize:15];
    long long timeCut = [detail[@"time"] doubleValue] - [[self getCurrentTimestamp] doubleValue];
    _countDownView.countDownTimeInterval = timeCut;
    
    [_seckillPrice setFont:[UIFont fontWithName:@"Helvetica-Bold" size:25]];
    _seckillPrice.text = [NSString stringWithFormat:@"¥%@",detail[@"price"]];
    
    
    if ([detail[@"status"] isEqualToString:@"0"]) {
         _seckillLabel.text = @"距秒杀开始还有";
        
    }else if ([detail[@"status"] isEqualToString:@"1"]){
        _seckillLabel.text = @"距秒杀结束还有";
        _priceTop.constant = 0;
        _miaoshaHeight.constant = 0;
        _priceHeight.constant = 0;
        _miaoShaJiaLabel.hidden = YES;
        _seckillPrice.hidden = YES;
    }
   
    
}

- (void)countDownDidFinished {
    NSLog(@"/////");
    _seckillEnd();
}
//获取当前系统时间的时间戳
- (NSString *)getCurrentTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    //设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    //现在时间
    NSDate *datenow = [NSDate date];
    
    NSLog(@"设备当前的时间:%@",[formatter stringFromDate:datenow]);
    
    //时间转时间戳的方法:
    NSNumber *timeSp = [NSNumber numberWithDouble:[datenow timeIntervalSince1970]];
    //时间戳的值
    NSString *timeStamp = [NSString stringWithFormat:@"%@", timeSp];
    NSLog(@"设备当前的时间戳:%@", timeStamp);
    
    return timeStamp;
}

@end
