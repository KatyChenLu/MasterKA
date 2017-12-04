//
//  MyCardCell.m
//  MasterKA
//
//  Created by hyu on 16/4/29.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MyCardCell.h"
#import "SDWebImageManager.h"
@implementation MyCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.balckView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(12, 12)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.balckView.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.balckView.layer.mask = maskLayer;
    // Initialization code
   self.infoView.layer.masksToBounds=YES;
    self.infoView.layer.cornerRadius=12.0; //设置矩形四个圆角半径
    self.infoView.layer.borderWidth=1.0; //边框宽度
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.8, 0.8, 0.8, 1 });
    self.infoView.layer.borderColor=colorref;//边框颜色

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showCard:(NSDictionary *)dic{
     [self.cardImg setImageWithURLString:dic[@"cardUrl"] placeholderImage:[UIImage imageNamed:@"DefaultImage.png"]];
    self.cardTitle.text=[dic objectForKey:@"cardTitle"];
    self.cartPrice.text=[NSString stringWithFormat:@"￥%@",[dic objectForKey:@"cardPrice"]];
    NSString *start =[self changeTIme:[dic objectForKey:@"beginTime"]];
     NSString *end =[self changeTIme:[dic objectForKey:@"endTime"]];
    self.cardTIme.text=[NSString stringWithFormat:@"使用期限：%@-%@",start,end];
    self.infoText.text=dic[@"cardDesc"];
}

-(void)showCardForSale:(NSDictionary *)dic
{
    [self.cardImg setImageWithURLString:dic[@"pic_url"]];
    self.cardTitle.text=[dic objectForKey:@"card_name"];
    self.cartPrice.text=[NSString stringWithFormat:@"￥%@",[dic objectForKey:@"price"]];
//    NSString *start =[self changeTIme:[dic objectForKey:@"beginTime"]];
//    NSString *end =[self changeTIme:[dic objectForKey:@"endTime"]];
//    self.cardTIme.text=[NSString stringWithFormat:@"使用期限：%@-%@",start,end];
    self.infoText.text=dic[@"intro"];
    self.balckView.hidden=YES;
    self.cardTIme.hidden = YES;
}
-(NSString *)changeTIme:(NSString *)str{
    NSDate*detaildate=[NSDate dateWithTimeIntervalSince1970:[str doubleValue]];
    
    
    
    //实例化一个NSDateFormatter对象
    
    NSDateFormatter*dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    
    NSString*currentDateStr = [dateFormatter stringFromDate:detaildate];
    return currentDateStr;
}
- (IBAction)doShowInfoButton:(id)sender{
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.contentView cache:YES];
    
    
    //这里时查找视图里的子视图（这种情况查找，可能时因为父视图里面不只两个视图）
    //    NSInteger fist= [[self.contentView subviews] indexOfObject:self.cardView];
    //    NSInteger seconde= [[self.contentView subviews] indexOfObject:self.cardInfoView];
    //    [self exchangeSubviewAtIndex:fist withSubviewAtIndex:seconde];
    
    //当父视图里面只有两个视图的时候，可以直接使用下面这段.
    
    [self.contentView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}

- (IBAction)doShowCardButton:(id)sender{
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.contentView cache:YES];
    
    
    //这里时查找视图里的子视图（这种情况查找，可能时因为父视图里面不只两个视图）
    //    NSInteger fist= [[self.contentView subviews] indexOfObject:self.cardInfoView];
    //    NSInteger seconde= [[self.contentView subviews] indexOfObject:self.cardView];
    //    [self.contentView exchangeSubviewAtIndex:fist withSubviewAtIndex:seconde];
    
    //当父视图里面只有两个视图的时候，可以直接使用下面这段.
    
    [self.contentView exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    
    
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}
@end
