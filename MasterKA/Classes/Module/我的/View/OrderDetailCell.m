//
//  OrderDetailCell.m
//  MasterKA
//
//  Created by hyu on 16/6/14.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "OrderDetailCell.h"
#import <EventKit/EventKit.h>
@implementation OrderDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.buttonBorder.layer setMasksToBounds:YES];
    [self.buttonBorder.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [self.buttonBorder.layer setBorderWidth:1.0]; //边框宽度
    [self.kefuButton.layer setMasksToBounds:YES];
    [self.kefuButton.layer setCornerRadius:5.0]; //设置矩形四个圆角半径
    [self.kefuButton.layer setBorderWidth:1.0]; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.8, 0.8, 0.8, 1 });
    [self.buttonBorder.layer setBorderColor:colorref];//边框颜色
    [self.kefuButton.layer setBorderColor:colorref];//边框颜色

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)prepareView :(NSDictionary *)orderInfo{
    self.detail=orderInfo;
    self.status.text=[self checkStatus:[orderInfo[@"order_status"] integerValue]];
    self.orderTime.text=[self changeTIme:orderInfo[@"addtime"]];
    self.nikeName.text=orderInfo[@"nikename"];
    [self.userInfo addTarget:self action:@selector(gotoUserCenter) forControlEvents:UIControlEventTouchUpInside];
      [self.courseInfo addTarget:self action:@selector(gotoCourseDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.cover setImageWithURLString:orderInfo[@"cover"] placeholderImage:nil];
    self.classTitle.text=orderInfo[@"title"];
  }
-(NSString *)checkStatus:(NSInteger)status{
    NSString *statuStr;
    
    switch (status) {
        case 0:
            statuStr=@"待上课";
            [self setorderStatus:2];
            break;
        case 1:
            statuStr=@"已使用";
            [self setorderStatus:3];
            break;
        case 2:
            statuStr=@"已过期";
            break;
        case 3:
            statuStr=@"无效";
            break;
        case 4:
            statuStr=@"待接单";
            [self setorderStatus:1];
            break;
        default:
            statuStr=@"已退款";
            [self setorderStatus:4];
            break;
    }
    return statuStr;
}
-(void)setorderStatus:(NSInteger)status{
    UIColor *Color =[UIColor blackColor];
    UIColor *line =[UIColor colorWithRed:255/255.f green:216/255.f blue:1/255.f alpha:1.0f];
    if(status >=1){
        self.commitOrder.image=[UIImage imageNamed:@"tijiaodingdan-huang"];
        self.line.backgroundColor=line;
        self.commitLabel.textColor=Color;
    }
    if(status >=2){
        self.wait.image=[UIImage imageNamed:@"darenjiedan-huang"];
        self.waitLabel.textColor=Color;
        self.waitLabel.text=@"达人已接单";
        self.lineAfter.backgroundColor=line;
    }
    if(status >=3){
        if(status==3){
            self.startClass.image=[UIImage imageNamed:@"kaishishangke-huang"];
            self.startLabel.textColor=Color;
            
        }else{
            self.startClass.image=[UIImage imageNamed:@"tuikuanchenggong-huang"];
            self.startLabel.textColor=Color;
            self.waitLabel.text=@"达人已拒单";
            self.startLabel.text=@"退款成功";
        }
        
    }
}
-(NSString *)changeTIme:(NSString *)str{
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:[str doubleValue]];
    //实例化一个NSDateFormatter对象
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}
- (IBAction)addToCalendar:(id)sender {
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    //6.0及以上通过下⾯⽅式写入事件
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)]) {
        //等待用户是否同意授权日历
        //EKEntityMaskEvent提醒事项参数（该参数只能真机使用）  EKEntityTypeEvent日历时间提醒参数
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                }else if (!granted)
                {
                    //被⽤用户拒绝,不允许访问⽇日历
                }else{
                    //事件保存到⽇日历
                    //创建事件
                    EKEvent *event = [EKEvent eventWithEventStore:eventStore];
                    event.title     = self.classTitle.text;
                    event.location = self.detail[@"address"];
                    //设定事件开始时间
                    NSString *starttime =[NSString stringWithFormat:@"%@ %@",[self changeTIme:self.detail[@"start_date"]],self.detail[@"start_time"]];
                    NSString *endtime=[NSString stringWithFormat:@"%@ %@",[self changeTIme:self.detail[@"start_date"]],self.detail[@"end_time"]];
                    event.startDate = [self changStrToDate:starttime];
                    event.endDate   = [self changStrToDate:endtime];
                    event.allDay = YES;
                    //添加提醒 可以添加多个，设定事件多久以前开始提醒
                    //在事件前多少秒开始事件提醒-5.0f
                    [event addAlarm:[EKAlarm alarmWithRelativeOffset:60.0f * -60.0f*24]];
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"添加提醒" message:@"添加成功，上课前一天自动提醒" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
                    [alertView show];
                }
            });
        }];
        
    }
}
//将日期str转换成date
-(NSDate *) changStrToDate:(NSString *)str{
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy/MM/dd HH:mm"];
    NSDate *fromdate=[format dateFromString:str];
    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
    NSDate *fromDate = [fromdate  dateByAddingTimeInterval: frominterval];
    return fromDate;
}
-(void)gotoUserCenter{
    if(self.userInfoRAC){
        [self.userInfoRAC execute:self.detail];
    }
}
-(void)gotoCourseDetail{
    if(self.courseInfoRAC){
        [self.courseInfoRAC execute:self.detail];
    }
}
@end
