//
//  MasterOrderInfoCell.m
//  HiGoMaster
//
//  Created by jinghao on 15/7/15.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "MasterOrderInfoCell.h"

@interface MasterOrderInfoCell ()<UIAlertViewDelegate>
@property (nonatomic,weak)IBOutlet UIImageView* userHeaderImageView;
@property (nonatomic,weak)IBOutlet UILabel* userNameView;
@property (nonatomic,weak)IBOutlet UIButton* userPhoneButton;
@property (nonatomic,weak)IBOutlet UIButton* refuseOrderButton;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint* refuseOrderButtonWidth;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint* refuseOrderButtonRight;

@property (nonatomic,weak)IBOutlet UIButton* acceptOrderButton;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint* acceptOrderButtonWidth;
@property (nonatomic,weak)IBOutlet NSLayoutConstraint* acceptOrderButtonRight;


@property (nonatomic,weak)IBOutlet UIImageView* courseImageView;
@property (nonatomic,weak)IBOutlet UILabel* courseTitleView;
@property (nonatomic,weak)IBOutlet UILabel* coursePriceView;
@property (nonatomic,weak)IBOutlet UILabel* packageView;//套餐
@property (weak, nonatomic) IBOutlet UILabel *gotoAddress;

@property (nonatomic,weak)IBOutlet UILabel* timeView;//上课时间
@property (nonatomic,weak)IBOutlet UILabel* timeBuyView;//购买时间

@property (nonatomic,weak)IBOutlet UILabel* orderSNView;
@property (nonatomic,weak)IBOutlet UILabel* orderStateView;

@property (nonatomic,weak)IBOutlet UIView* userInfoView;
@property (nonatomic,weak)IBOutlet UIView* courseInfoView;

@end

@implementation MasterOrderInfoCell

- (void)awakeFromNib {
    UITapGestureRecognizer* userTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoOnClick:)];
    userTap.numberOfTapsRequired=1;
    userTap.numberOfTouchesRequired=1;
    [self.userInfoView addGestureRecognizer:userTap];
    
    UITapGestureRecognizer* courseTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(courseInfoOnClick:)];
    courseTap.numberOfTapsRequired=1;
    courseTap.numberOfTouchesRequired=1;
    [self.courseInfoView addGestureRecognizer:courseTap];
   
    [self.userPhoneButton fillet:4.0f borderWidth:0.5f borderColor:[UIColor colorWithHex:0xa9a9a9]];
    [self.refuseOrderButton fillet:4.0f  borderWidth:0.5f borderColor:[UIColor colorWithHex:0xa9a9a9]];
    //    [self.orderCommentButton fillet:4.0f  borderWidth:0.5f borderColor:[UIColor colorWithHex:0xeeeeee]];
    [self.acceptOrderButton fillet:4.0f];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)userInfoOnClick:(UITapGestureRecognizer*)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(masterOrderInfoCell:actionTag:)]) {
        [self.delegate masterOrderInfoCell:self actionTag:1];
    }
}
- (void)courseInfoOnClick:(UITapGestureRecognizer*)sender{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(masterOrderInfoCell:actionTag:)]) {
//        [self.delegate masterOrderInfoCell:self actionTag:2];
//    }
}

- (void)clearCellData{
    self.userNameView.text = @"";
    self.courseTitleView.text = @"";
    self.coursePriceView.text = @"";
    self.packageView.text = @"";
    self.gotoAddress.text = @"";
    self.timeView.text = @"";
    self.orderSNView.text = @"";
    self.coursePriceView.text = @"";
    self.timeBuyView.text = @"";
    self.refuseOrderButton.hidden = YES;
    self.refuseOrderButtonRight.constant=0.0f;
    self.refuseOrderButtonWidth.constant=0.0f;

    self.acceptOrderButton.hidden = YES;
    self.acceptOrderButtonRight.constant=0.0f;
    self.acceptOrderButtonWidth.constant=0.0f;

}

- (void)setItemDataForDetail:(id)itemData
{
   
}

- (void)setItemData:(id)itemData
{
    //used  4：待接单，1：已使用，2：已过期，3：无效；0:待验单; 5:已拒单; 
    _itemData = itemData;
    [self clearCellData];
    if (itemData) {
        [self.courseImageView setImageWithURLString:itemData[@"cover"]];
        self.courseTitleView.text = itemData[@"title"];
        [self.userHeaderImageView setImageWithURLString:itemData[@"buyer_imgTop"]];
        self.userNameView.text = itemData[@"buyer_nikename"];
        self.orderSNView.text =  [NSString stringWithFormat:@"%@",itemData[@"orderId"]];
        if (itemData[@"buyDateTime"]) {
            self.timeBuyView.text = itemData[@"buyDateTime"];
        }
            self.timeView.text = itemData[@"show_start_date"];
        
        
        self.orderSNView.textColor = [UIColor colorWithHex:0x333333];
        self.orderSNView.textAlignment = NSTextAlignmentRight;
//        NSNumber* zfType = itemData[@"zfType"];
//        NSInteger num = [itemData[@"num"] integerValue];
//        if (zfType.integerValue==0) {
//            NSInteger price = [itemData[@"price"] integerValue];
//            self.coursePriceView.text = [NSString stringWithFormat:@"实付：%ldM点",(long)(price*num)];
//            
//        }else{
            float price = [itemData[@"eachPrice"] floatValue];
            NSString* totalPrice = [NSString stringWithFormat:@"￥%.2f",price];
            NSMutableString* totalTextPrice = [[NSMutableString alloc] init];
            [totalTextPrice appendFormat:@"实付：%@",totalPrice];
            NSMutableAttributedString* payPrice = [[NSMutableAttributedString alloc] initWithString:totalTextPrice];
            [payPrice addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:[totalTextPrice rangeOfString:totalPrice]];
            self.coursePriceView.attributedText = payPrice;
//        }
        double buyTime = [itemData[@"addtime"] doubleValue];
        if (buyTime>0) {
            NSDate* date = [NSDate dateWithTimeIntervalSince1970:buyTime];
            NSDateFormatter* df = [[NSDateFormatter alloc] init];
            NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
            [df setTimeZone:sourceTimeZone];
            [df setDateFormat:@"yyyy/MM/dd HH:mm"];
            self.timeBuyView.text = [df stringFromDate:date];
        }else{
            self.timeBuyView.text = [NSString stringWithFormat:@"%@",itemData[@"addtime"]];
        }
        
        self.packageView.text = itemData[@"specName"];
        self.gotoAddress.text = itemData[@"address"];
        
        NSNumber* used = itemData[@"orderStatus"];
        switch (used.integerValue) {
            case 0://准备上课，待验单
                self.orderStateView.text = @"待验单";
                break;
            case 1://已使用
                self.orderStateView.text = @"已使用";
                break;
            case 2://已过期
                self.orderStateView.text = @"已过期";
                break;
            case 3://已作废
                self.orderStateView.text = @"已作废";
                break;
            case 4://待接单
                self.orderStateView.text = @"待接单";
                self.refuseOrderButton.hidden = NO;
                self.refuseOrderButtonWidth.constant= 80.0f;
                self.refuseOrderButtonRight.constant= 12.0f;

                self.acceptOrderButton.hidden = NO;
                self.acceptOrderButtonWidth.constant= 80.0f;
                self.acceptOrderButtonRight.constant= 12.0f;
                break;
            case 5://已拒单
                self.orderStateView.text = @"已拒单";
                break;
            default:
                break;
        }
        
    }
}

- (IBAction)doButtonOnClick:(id)sender{
    if (sender==self.userPhoneButton) {
        if ([self.delegate respondsToSelector:@selector(masterOrderInfoCell:actionPhone:)]) {
            [self.delegate masterOrderInfoCell:self actionPhone:self.itemData[@"buyer_mobile"]];
        }
    }else if(sender==self.refuseOrderButton){
        if (self.delegate && [self.delegate respondsToSelector:@selector(masterOrderInfoCell:actionTag:)]) {
            [self.delegate masterOrderInfoCell:self actionTag:3];
        }

    }else if(sender==self.acceptOrderButton){
        if (self.delegate && [self.delegate respondsToSelector:@selector(masterOrderInfoCell:actionTag:)]) {
            [self.delegate masterOrderInfoCell:self actionTag:4];
        }
    }    
}
@end
