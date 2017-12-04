//
//  SelectOrderModel.m
//  MasterKA
//
//  Created by xmy on 16/5/17.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "SelectOrderModel.h"

@implementation SelectOrderModel



- (void)initialize
{
    [super initialize];
    
}

- (void)bindTableView:(UITableView *)tableView
{
    [super bindTableView:tableView];
    [self first];
    [self reloadTable];
    
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    cell.tag = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.textLabel.textColor = [UIColor colorWithHex:0x424242];
    cell.backgroundColor = [UIColor colorWithHex:0xFFFFFF];
    if(self.selectedOrder){
        OrderTypeModel* type= object;
        cell.tag = type.item_id.intValue;
        cell.textLabel.text = type.item_name;
        if(cell.tag == self.orderId.intValue){
            cell.textLabel.textColor = [UIColor colorWithHex:0x11A6E8];
            cell.backgroundColor = [UIColor colorWithHex:0xF8F8F8];
        }
    }else{
        SelectTypeModel* type= object;
        cell.tag = type.item_id.intValue;
        cell.textLabel.text = type.item_name;
        if(cell.tag == self.selectId.intValue){
            cell.textLabel.textColor = [UIColor colorWithHex:0x11A6E8];
            cell.backgroundColor = [UIColor colorWithHex:0xF8F8F8];
        }
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    return  40;
}

- (void )reloadTable
{
    NSMutableArray *list = [NSMutableArray new];
    if(self.selectedOrder){
        RLMResults *bannerResult = [OrderTypeModel allObjects];
        for (OrderTypeModel* model in bannerResult) {
            [list addObject:model];
        }
    }else{
        RLMResults *bannerResult = [SelectTypeModel allObjects];
        for (SelectTypeModel* model in bannerResult) {
            [list addObject:model];
        }
    }
    
    self.dataSource = @[list];
    [self.mTableView reloadData];
    
}




@end
