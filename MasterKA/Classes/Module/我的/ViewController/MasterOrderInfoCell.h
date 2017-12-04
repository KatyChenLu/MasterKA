//
//  MasterOrderInfoCell.h
//  HiGoMaster
//
//  Created by jinghao on 15/7/15.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "BaseTableViewCell.h"

@class MasterOrderInfoCell;

@protocol MasterOrderInfoCellDelegate <NSObject>

- (void)masterOrderInfoCell:(MasterOrderInfoCell*)cell actionTag:(NSInteger)actionTag;
- (void)masterOrderInfoCell:(MasterOrderInfoCell*)cell actionPhone:(NSString*)phones;

@end

@interface MasterOrderInfoCell : BaseTableViewCell
@property (nonatomic,strong)id<MasterOrderInfoCellDelegate> delegate;
@property (nonatomic,strong)id itemData;
- (void)setItemDataForDetail:(id)itemData;
@end
