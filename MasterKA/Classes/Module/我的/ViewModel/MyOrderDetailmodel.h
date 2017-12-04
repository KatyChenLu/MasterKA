//
//  MyOrderDetailmodel.h
//  MasterKA
//
//  Created by hyu on 16/6/14.
//  Copyright © 2016年 jinghao. All rights reserved.
//
@protocol redPacketDelegate <NSObject>

- (void)DotoShowRedPaket;
-(void)hideBackGroudview;
-(void)showSmallred;
@end
#import "TableViewModel.h"

@interface MyOrderDetailmodel : TableViewModel
{
        id <redPacketDelegate> delegate;
}
@property (nonatomic, strong) NSString *orderId;
@property (nonatomic,strong,readonly)RACCommand *userInfo;
@property (nonatomic,strong,readonly)RACCommand *courseDetail;
@property (nonatomic, assign) id <redPacketDelegate> delegate;
@property(nonatomic ,strong)NSString *mainOrderId;
@property(nonatomic,strong)NSString* endTime;
@property(nonatomic,strong)NSString* limitPrice;
@property(nonatomic,strong)NSString* redPrice;
@property(nonatomic,strong)NSString* desc;
@property(nonatomic,strong)NSString* imgUrl;
@property(nonatomic,strong)NSString* link;
@property(nonatomic,strong)NSString* fenxiangTitle;
@property(nonatomic,strong)NSString* fromCode;
@end
