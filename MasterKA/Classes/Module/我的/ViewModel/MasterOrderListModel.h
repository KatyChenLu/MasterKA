//
//  MasterOrderListModel.h
//  MasterKA
//
//  Created by xmy on 16/5/25.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "TableViewModel.h"
#import "MasterOrderInfoCell.h"

@interface MasterOrderListModel : TableViewModel<MasterOrderInfoCellDelegate,UIActionSheetDelegate>

@property(nonatomic, strong) NSMutableArray *dateSection;
@property(nonatomic, strong) NSString *orderStatus;
@property (nonatomic, strong, readonly) RACCommand *didClickTagButtonCommand;
@property (nonatomic,strong, readonly)RACCommand *followCommand;
@property (nonatomic,strong, readonly)RACCommand *masterCommand;
@property(nonatomic, strong) NSString *comeIdentifier;

@property (nonatomic,strong)NSMutableArray* orderDataSource;
@property (nonatomic,strong)NSMutableDictionary* groupDataSource;
@property (nonatomic,strong)NSMutableArray* reasonDataSource;
@property (nonatomic,strong)id refuseOrder;
@property (nonatomic,strong)id refuseOrderReason;

@property (nonatomic,strong)NSString* orderType;


@end
