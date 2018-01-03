//
//  KAOrderDetailViewModel.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/28.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAOrderDetailViewModel.h"
#import "KAOrderDetailTableViewCell.h"
@implementation KAOrderDetailViewModel
- (void)initialize {
    [super initialize];
    
    
}
- (void)bindTableView:(UITableView *)tableView {
    [super bindTableView:tableView];
    [self.mTableView registerCellWithReuseIdentifier:@"KAOrderDetailTableViewCell"];
    
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    
    
    KAOrderDetailTableViewCell *mcell = (KAOrderDetailTableViewCell *)cell;
    [mcell showOrderDetail:object];
    
    NSArray *arr = self.dataSource[0];
    if (indexPath.row == 0) {
        mcell.topLine.backgroundColor = [UIColor whiteColor];
    }else {
        mcell.timeLabel.alpha = 0.5;
        mcell.stateLabel.alpha = 0.5;
    }
    if (indexPath.row == arr.count - 1){
        mcell.bottomLine.backgroundColor = [UIColor whiteColor];
    }
    
    
    if (indexPath.row == 0) {
        if ([self.info[@"flag"] isEqualToString:@"0"]) {
            mcell.lineImgV.image = [UIImage imageNamed:@"订单进行中"];
        }else if ([self.info[@"flag"] isEqualToString:@"1"]){
            mcell.lineImgV.image = [UIImage imageNamed:@"订单成功"];
        }else if ([self.info[@"flag"] isEqualToString:@"2"]){
            mcell.lineImgV.image = [UIImage imageNamed:@"订单失败"];
        }
    }else {
        mcell.lineImgV.image = [UIImage imageNamed:@"订单首"];
    }
    
    
}
-(NSString *)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath {
    
    return @"KAOrderDetailTableViewCell";
    
    
}
- (RACSignal *)requestRemoteDataSignalWithPage:(NSUInteger)page {
    RACSignal *fetchSignal = [self.httpService getKAOrderDetailWithOid:self.oid orderStatus:self.orderStatus resultClass:nil];
    @weakify(self);
    return [[[fetchSignal collect] doNext:^(NSArray *pageSize) {
        
    }] map:^id(NSArray *responses) {
        BaseModel *model = responses.firstObject;
        @strongify(self);
        if (model.code==200) {
            self.info = model.data;
            NSArray *data = model.data[@"lists"];
            self.dataSource = @[data];
            [self.mTableView reloadData];
            [self starAnimationWithTableView:self.mTableView];
            
        }
        return self.dataSource;
    }];
    
}
- (void)starAnimationWithTableView:(UITableView *)tableView  {
    unsigned int count = 0;
    
    //Get Class Method
    Method *methodlist = class_copyMethodList(object_getClass(self.class), &count);
    
    for (int i = 0; i < count; i++) {
        Method method = methodlist[i];
        SEL selector = method_getName(method);
        NSString *methodName = NSStringFromSelector(selector);
        
        if ([methodName rangeOfString:@"AnimationWithTableView"].location != NSNotFound) {
            
            
            ((void (*)(id,SEL,UITableView *))objc_msgSend)([self class],selector,tableView);
            break;
            
        }
    }
    free(methodlist);
}
+ (void)alphaAnimationWithTableView:(UITableView *)tableView {
    
    NSArray *cells = tableView.visibleCells;
    for (int i = 0; i < cells.count; i++) {
        UITableViewCell *cell = [tableView.visibleCells objectAtIndex:i];
        cell.alpha = 0.0;
        [UIView animateWithDuration:0.3 delay:i*0.05 options:0 animations:^{
            cell.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    }
}
- (NSMutableArray *)getDetail:(NSDictionary *)info {
    NSMutableArray *detailArr = [NSMutableArray array];
    NSArray *arr = info[@"guess_like"];
    
    for (NSDictionary * dic in arr) {
        [detailArr addObject:@[dic]];
        //        [self.detailSection addObject:@"内容"];
    }
    return detailArr;
}
#pragma mark --
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}
@end
