//
//  MyOrderModel.m
//  MasterKA
//
//  Created by hyu on 16/5/5.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MyOrderModel.h"
#import "MyOrderCell.h"
#import "MyOrderDetailController.h"
#import "GoodDetailViewController.h"
#import "PaySuccessController.h"
@interface MyOrderModel()
@property (nonatomic,strong,readwrite)RACCommand *deleteOrder;
@property (nonatomic,strong,readwrite)RACCommand *userInfo;
@end
@implementation MyOrderModel
- (void)initialize
{
    [super initialize];
    self.showNoMoreWithAll = YES;
    //    [[self.requestRemoteDataCommand execute:nil] subscribeNext:^(id x) {
    //        NSLog(@"======111 ==== %@",x);
    //    }];
    @weakify(self)
    [[RACObserve(self, orderStatus) filter:^BOOL(NSString *orderStatus) {
        return (orderStatus!=nil);
    }] subscribeNext:^(NSString *orderStatus) {
        @strongify(self)
        NSLog(@"=====categoryId  ===== %@",orderStatus);
        if (orderStatus) {
            [self first];
        }
    }];
    self.userInfo = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *model) {
        @strongify(self)
        NSString *url = [NSString stringWithFormat:@"%@?uid=%@",URL_MasterCenter,model[@"uid"]];
        [self.viewController pushViewControllerWithUrl:url];

        return [RACSignal empty];
    }];

}

- (void)bindTableView:(UITableView *)tableView
{
    [super bindTableView:tableView];
    self.cellReuseIdentifier = @"MyOrderCell";
    self.dateSection = [NSMutableArray new];
    [self.mTableView registerCellWithReuseIdentifier:@"MyOrderCell"];
    self.shouldMoreToRefresh = YES;
    self.shouldPullToRefresh = YES;
    self.pageSize = @(10);
}

- (RACSignal*)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    RACSignal *fetchSignal = [self.httpService getMyOrder:self.orderStatus page:page pageSize:self.pageSize.integerValue resultClass:nil];
    @weakify(self);
    return [[[fetchSignal collect] doNext:^(id x) {
        NSLog(@"===== x %@",x);
        @strongify(self);
        if(self.mTableView.mj_footer.isRefreshing ){
            [self.mTableView.mj_footer endRefreshing];
        }
        if (self.mTableView.mj_header.isRefreshing) {
            [self.mTableView.mj_header endRefreshing];
        }
        
    }] map:^id(NSArray *responses) {
        NSLog(@"===== value  %@",responses);
        @strongify(self);
        BaseModel *model = responses.firstObject;
        NSArray * array = [NSArray new];
        NSMutableArray * dateSection = [NSMutableArray new];
     
        
         NSMutableArray * order = [NSMutableArray new];
        if (model.code==200) {
            if (![model.data  isEqual:@""]) array = model.data;
                for (NSDictionary *dic in array) {
//                if([self.orderStatus  isEqual:@"1"]){
//                    NSMutableArray *needScore =[NSMutableArray array];
//                    for (NSDictionary *orderDetail in [dic objectForKey:@"detail"]) {
//                        if([orderDetail[@"needScore"]  isEqual:@"1"]){
//                            [needScore addObject:order];
//                        }
//                    }
//                    if(needScore.count>0){
//                        [dateSection addObject:[dic objectForKey:@"day"]];
//                         [order addObject:needScore];
//                    }
//                }
//                else{
                    [order addObject:[dic objectForKey:@"detail"]];
                    [dateSection addObject:[dic objectForKey:@"day"]];
//                }
            }
//            NSLog(@"%@",order);
            if(order && order.count){
                if([self.curPage intValue] > 1){
                    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithArray:self.dataSource];
                    [self.dateSection addObjectsFromArray:dateSection];
                    NSArray *retureArr=[self arrayWithMemberIsOnly:self.dateSection];
                    self.dateSection=retureArr[0];
                    if([retureArr[1] isEqual:@"NO"]){
                        NSMutableArray * merge1=indexPaths[indexPaths.count-1];
                        [indexPaths removeObjectAtIndex:indexPaths.count-1];
                        NSMutableArray * merge2=order[0];
                        [order removeObjectAtIndex:0];
                        [merge1 addObjectsFromArray:merge2];
                        [indexPaths addObject:merge1];
                    }
                    [indexPaths addObjectsFromArray:order];
                    self.dataSource=indexPaths;
                }else{
                    //                    [self.dbService deleteClass:[BaseModel class]];
                    self.dateSection=dateSection;
                    self.dataSource = order;
                }
                self.info =[NSMutableArray arrayWithArray:self.dataSource];
                [self.mTableView reloadData];
                
                //                [self.dbService deleteClass:array];
                //                [self.dbService insertModelArray:array];
                
            }
            
            
        }else{
            [self showRequestErrorMessage:model];
//            [self.viewController hiddenHUDWithString:model.message error:NO];
        }

        
        return array;
        
    }];
}
- (NSMutableArray *)arrayWithMemberIsOnly:(NSMutableArray *)array
{
    NSMutableArray *categoryArray = [[NSMutableArray alloc] init];
    NSString *identity =@"YES";
    for (int i = 0; i < [array count]; i++) {
        if ([categoryArray containsObject:[array objectAtIndex:i]] == NO)
        {
            [categoryArray addObject:[array objectAtIndex:i]];
        }else{
            identity =@"NO";
        }
    }
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    [returnArray addObject:categoryArray];
    [returnArray addObject:identity];
    return returnArray;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *Idlabel =[[UILabel alloc]initWithFrame:CGRectMake(50, 0, 40, 0)];
    Idlabel.font=[UIFont systemFontOfSize:12];
    Idlabel.backgroundColor = [UIColor colorWithRed:246/255.f green:246/255.f  blue:246/255.f  alpha:1.0f];
    Idlabel.text =[NSString stringWithFormat:@"    %@" ,[self.dateSection objectAtIndex:section]];
    return Idlabel;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 35;
}
- (void)configureCell:(MyOrderCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(NSDictionary*)object
{
    NSArray *array=[self.dataSource objectAtIndex:indexPath.section];
//    NSLog(@"%@",object[@"oid"]);
//    NSLog(@"%@",[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:(array.count-1)][@"oid"]);
    if([object[@"oid"] isEqual:[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:(array.count-1)][@"oid"]] ){
        [cell showOrder:object with:@"hide"];
    }else{
        [cell showOrder:object with:@"show"];
    }
    cell.userInfoRAC=self.userInfo;
    [cell.check addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
    [cell.deleteOrder addTarget:self action:@selector(doRefuseOrder:event:) forControlEvents:UIControlEventTouchUpInside];
    
    @weakify(self);
    [cell.evaluate setTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
        @strongify(self);
        NSString *vctUrl = [NSString stringWithFormat:@"%@",URL_AddUserShare];
        UIViewController *vct = [self.viewController.urlManager viewControllerWithUrl:vctUrl];
        
        vct.title = @"评价";
        vct.params = @{@"course_id":object[@"cid"] , @"order_id":object[@"orderId"]};
        
        
        
        
        [self.viewController pushViewController:vct animated:YES];
    }];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(![[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row][@"is_groupbuy"] isEqualToString:@"1"]){
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
    MyOrderDetailController *myView = [story instantiateViewControllerWithIdentifier:@"MyOrderDetailController"]; //MyOrderInforMationController
    myView.params=@{@"oid":[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row][@"orderId"]};
    [self.viewController.navigationController pushViewController:myView animated:YES];
    }
    else{
        PaySuccessController * paySuccessVc = [[PaySuccessController alloc]init];
        paySuccessVc.orderInfo = [[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [self.viewController pushViewController: paySuccessVc animated:YES];
    }
}

- (IBAction)evaluateOrder:(id)sender {
    UIButton *btn = sender;
    
    NSString *vctUrl = [NSString stringWithFormat:@"%@",URL_AddUserShare];
    UIViewController *vct = [self.viewController.urlManager viewControllerWithUrl:vctUrl];
    
    vct.title = @"评价";
    vct.params = @{@"course_id":[NSString stringWithFormat:@"%ld",(long)btn.tag]};
    
    [self.viewController pushViewController:vct animated:YES];
}
-(void)showDetail:(id)sender{
    UIButton *button =sender;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
    GoodDetailViewController *myView = [story instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
    myView.params=@{@"courseId":[NSString stringWithFormat:@"%ld",[button tag]]};
    [self.viewController.navigationController pushViewController:myView animated:YES];
    
    
}
-(void)deleteThisOrder{
    @weakify(self);
    [[self.httpService deleteOrder:self.dataSource [self.removeIndex.section][self.removeIndex.row][@"orderId"] resultClass:nil] subscribeNext:^(BaseModel *model){
        @strongify(self);
        if (model.code==200) {
            [self.viewController hiddenHUDWithString:model.message error:NO];
            [self.info[self.removeIndex.section] removeObjectAtIndex:self.removeIndex.row];
            if([self.info[self.removeIndex.section]  isEqual:@[]]){
                [self.info removeObjectAtIndex:self.removeIndex.section];
                [self.dateSection removeObjectAtIndex:self.removeIndex.section];
            }
            self.dataSource=[self.info  isEqual:@[]]?@[]:self.info;
            [self.mTableView reloadData];
        }else{
            [self showRequestErrorMessage:model];
//            [self.viewController hiddenHUDWithString:model.message error:NO];
        }
    }];
}
- (void)doRefuseOrder:(id)senter event:(id)event{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.mTableView];
    self.removeIndex = [self.mTableView indexPathForRowAtPoint:currentTouchPosition];
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"删除订单" message:@"确定删除订单么" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag =201;
    [alertView show];
}

#pragma mark --  UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1 && alertView.tag==201) {
        [self deleteThisOrder];
    }
}
@end
