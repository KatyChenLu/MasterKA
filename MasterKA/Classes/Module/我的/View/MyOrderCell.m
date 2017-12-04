//
//  MyOrderCell.m
//  MasterKA
//
//  Created by hyu on 16/5/4.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MyOrderCell.h"
#import "SDWebImageManager.h"

@implementation MyOrderCell
{
    NSString * is_groupbuy;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.deleteOrder.layer.masksToBounds=self.evaluate.layer.masksToBounds=self.check.layer.masksToBounds=YES;
    self.deleteOrder.layer.cornerRadius=self.evaluate.layer.cornerRadius=self.check.layer.cornerRadius=4.0; //设置矩形四个圆角半径
    self.deleteOrder.layer.borderWidth=self.check.layer.borderWidth=1.0; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.8, 0.8, 0.8, 1 });
    self.deleteOrder.layer.borderColor=self.check.layer.borderColor=colorref;//边框颜色



    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showOrder:(NSDictionary *)info with:(NSString *)identifier{
    self.order=info;
    is_groupbuy = [info objectForKey:@"is_groupbuy"];
    self.evaluate.hidden=YES;
    self.check_view.priority=999;
    self.name.text=[info objectForKey:@"nikeName"];
    self.status.text=[self checkStatus:[[info objectForKey:@"orderStatus"] integerValue]];
    self.className.text=[info objectForKey:@"title"];
    [self.classImg setImageWithURLString:info[@"cover"] placeholderImage:[UIImage imageNamed:@"DefaultImage.png"]];
    if([info[@"zfType"] integerValue]==0){
        self.moneyAfter.text=[NSString stringWithFormat:@"%@ M点",[info objectForKey:@"price"]];
    }else{
        self.moneyAfter.text=[NSString stringWithFormat:@"￥%@",[info objectForKey:@"eachPrice"]];
    }
    [self.userInfo addTarget:self action:@selector(gotoUserCenter) forControlEvents:UIControlEventTouchUpInside];
    self.check.tag=[info[@"cid"] integerValue];
    if(([identifier  isEqual: @"hide"])){
        self.showLabel.hidden=YES;
        self.showLabelHeight.constant=0;
        self.linetobottom.constant=57;
        self.line.hidden=YES;
    }else{
        self.line.hidden=NO;
        self.showLabel.hidden=NO;
        self.showLabelHeight.constant=7;
        self.linetobottom.constant=64;
    }
}
-(NSString *)checkStatus:(NSInteger)status{
    NSString *statuStr;
    UIColor *Color =[UIColor colorWithRed:224/255.f green:1/255.f blue:1/255.f alpha:1.0f];
    UIColor *Color1 =[UIColor colorWithRed:169/255.f green:169/255.f blue:169/255.f alpha:1.0f];

    switch (status) {
        case 0:
            statuStr=@"待上课";
            self.deleteOrder.hidden=YES;
            self.status.textColor=Color;
            break;
        case 1:
            statuStr=@"已使用";
            self.deleteOrder.hidden=NO;
             self.status.textColor=Color1;
            if([[self.order objectForKey:@"needScore"] integerValue]==2){
                self.evaluate.hidden=YES;
                
                if(self.check_view.priority !=999){self.check_view.priority=999;}
            }else{
                self.evaluate.hidden=NO;
                if(self.check_view.priority !=1){self.check_view.priority=1;}
                
            }

            break;
        case 2:
            statuStr=@"已过期";
            self.deleteOrder.hidden=NO;
             self.status.textColor=Color1;
            break;
        case 3:
            statuStr=@"无效";
            self.deleteOrder.hidden=NO;
             self.status.textColor=Color1;
            break;
        case 4:
            statuStr=[is_groupbuy isEqualToString:@"1"]?@"拼团中":@"待接单";
            self.deleteOrder.hidden=YES;
            self.status.textColor=Color;
            break;
        default:
            statuStr=@"已退款";
            self.deleteOrder.hidden=NO;
            self.status.textColor=Color1;
            break;
    }

    return statuStr;
}
-(void)gotoUserCenter{
    if(self.userInfoRAC){
         [self.userInfoRAC execute:self.order];
    }
}
@end
