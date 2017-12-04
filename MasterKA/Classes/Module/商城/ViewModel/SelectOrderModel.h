//
//  SelectOrderModel.h
//  MasterKA
//
//  Created by xmy on 16/5/17.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "TableViewModel.h"

@interface SelectOrderModel : TableViewModel

@property (nonatomic,assign)NSString *orderId;
@property (nonatomic,assign)NSString *selectId;

@property (nonatomic,assign)Boolean selectedOrder;



- (void )reloadTable;

@end
