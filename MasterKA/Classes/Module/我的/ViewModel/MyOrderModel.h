//
//  MyOrderModel.h
//  MasterKA
//
//  Created by hyu on 16/5/5.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "TableViewModel.h"

@interface MyOrderModel : TableViewModel
@property(nonatomic, strong) NSMutableArray *dateSection;
@property(nonatomic, strong) NSString *orderStatus;
@property(nonatomic, strong) NSMutableArray *info;
@property(nonatomic, strong) NSIndexPath *removeIndex;
@property(nonatomic, strong) NSString *comeIdentifier;
@property (nonatomic,strong,readonly)RACCommand *userInfo;
@end
