//
//  QRCodeResultViewModel.h
//  MasterKA
//
//  Created by jinghao on 16/6/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "TableViewModel.h"

@interface QRCodeResultViewModel : TableViewModel
@property (nonatomic,strong)NSString *orderId;//订单ID
@property (nonatomic,strong)NSString *orderCode;//订单验证码
@property (nonatomic,strong)NSString *buyerId;//购买者ID
@property (nonatomic,strong,readonly)RACCommand *changeOrderCommand;

@end
