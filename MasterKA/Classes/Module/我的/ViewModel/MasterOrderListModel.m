//
//  MasterOrderListModel.m
//  MasterKA
//
//  Created by xmy on 16/5/25.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MasterOrderListModel.h"
#import "GoodDetailViewController.h"
#import "CommonSelectViewController.h"

@implementation MasterOrderListModel

- (void)initialize
{
    [super initialize];
    self.showNoMoreWithAll = YES;
    @weakify(self)
    [[RACObserve(self, orderStatus) filter:^BOOL(NSString *orderStatus) {
        return @(orderStatus.length>0);
    }] subscribeNext:^(NSString *orderStatus) {
        @strongify(self)
        NSLog(@"=====categoryId  ===== %@",orderStatus);
        if (orderStatus) {
            [self first];
        }
    }];
    
    
}

- (void)bindTableView:(UITableView *)tableView
{
    [super bindTableView:tableView];
    self.cellReuseIdentifier = @"MasterOrderInfoCell";
    _dateSection = [NSMutableArray new];
    [self.mTableView registerCellWithReuseIdentifier:@"MasterOrderInfoCell"];
    self.shouldMoreToRefresh = YES;
    self.shouldPullToRefresh = YES;
    self.pageSize = @(10);
}

- (RACSignal*)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    RACSignal *fetchSignal = [self.httpService getMasterOrders:self.orderStatus page:page pageSize:self.pageSize.integerValue resultClass:nil];
    
    return [[[fetchSignal collect] doNext:^(id x) {
        NSLog(@"===== x %@",x);
        if(self.mTableView.mj_footer.isRefreshing ){
            [self.mTableView.mj_footer endRefreshing];
        }
        if (self.mTableView.mj_header.isRefreshing) {
            [self.mTableView.mj_header endRefreshing];
        }
        
    }] map:^id(NSArray *responses) {
        NSLog(@"===== value  %@",responses);
        
        BaseModel *model = responses.firstObject;
        NSArray * array = [NSArray new];
        NSMutableArray * dateSection = [NSMutableArray new];
        
        NSMutableArray * order = [NSMutableArray new];
        if (model.code==200) {
            if (![model.data  isEqual:@""]) array = model.data;
            for (NSDictionary *dic in array) {
                if([self.orderStatus  isEqual:@"3"]){
                    NSMutableArray *needScore =[NSMutableArray array];
                    for (NSDictionary *orderDetail in [dic objectForKey:@"detail"]) {
                        if([orderDetail[@"needScore"]  isEqual:@"1"]){
                            [needScore addObject:order];
                        }
                    }
                    if(needScore.count>0){
                        [dateSection addObject:[dic objectForKey:@"day"]];
                        [order addObject:needScore];
                    }
                }
                else{
                    [order addObject:[dic objectForKey:@"detail"]];
                    [dateSection addObject:[dic objectForKey:@"day"]];
                }
            }
            if(order && order.count){
                if([self.curPage intValue] > 1){
                    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithArray:self.dataSource];
                    [indexPaths addObjectsFromArray:order];
                    [_dateSection addObjectsFromArray:dateSection];
                    self.dataSource = indexPaths;
                }else{
                    _dateSection=dateSection;
                    self.dataSource = order;
                }
                
                [self.mTableView reloadData];
                
            }
            
        }else{
//            [self.viewController hiddenHUDWithString:model.message error:NO];
            [self showRequestErrorMessage:model];
        }
        
        
        return array;
        
    }];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *Idlabel =[[UILabel alloc]initWithFrame:CGRectMake(50, 0, 40, 0)];
    Idlabel.font=[UIFont systemFontOfSize:12];
    Idlabel.backgroundColor = [UIColor colorWithRed:235/255.f green:235/255.f  blue:235/255.f  alpha:1.0f];
    Idlabel.text =[NSString stringWithFormat:@"    %@" ,[self.dateSection objectAtIndex:section]];
    return Idlabel;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}
- (void)configureCell:(MasterOrderInfoCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(NSDictionary*)object
{
    NSArray *array=[self.dataSource objectAtIndex:indexPath.section];
    id itemData = array[indexPath.row];
    cell.itemData = itemData;
    cell.delegate = self;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
//    MyOrderDetailController *myView = [story instantiateViewControllerWithIdentifier:@"MyOrderDetailController"];
//    myView.orderId=[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row][@"orderId"];
//    [self.viewController.navigationController pushViewController:myView animated:YES];
    
    
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
//    UIButton *button =sender;
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
//    GoodDetailViewController *myView = [story instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
//    myView.params=@{@"courseId":[NSString stringWithFormat:@"%ld",[button tag]]};
//    [self.viewController.navigationController pushViewController:myView animated:YES];
    
    
}

- (void)masterOrderInfoCell:(MasterOrderInfoCell*)cell actionPhone:(NSString*)phones
{
//    NSString* courseMobile = phones;
//    courseMobile = [courseMobile stringByReplacingOccurrencesOfString:@"、" withString:@","];
//    courseMobile = [courseMobile stringByReplacingOccurrencesOfString:@"，" withString:@","];
//    NSArray* phonesArray = [courseMobile componentsSeparatedByString:@","];
//    //    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"电话号码" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
//    UIActionSheet* actionSheet = [[UIActionSheet alloc] init];
//    actionSheet.title = @"电话号码";
//    actionSheet.delegate = self;
//    [actionSheet addButtonWithTitle:@"取消"];
//    for (NSString* phone in phonesArray) {
//        [actionSheet addButtonWithTitle:phone];
//    }
//    [actionSheet setCancelButtonIndex:0];
//    [actionSheet showInView:self.viewController.view];
    [self.viewController showPhonesActionSheet:phones];
}

- (void)masterOrderInfoCell:(MasterOrderInfoCell *)cell actionTag:(NSInteger)actionTag
{
    //actionTag 1,达人信息；2，课程信息； 3 拒单 4 接单
    if (actionTag==1) {
        NSString *url = [NSString stringWithFormat:@"%@?uid=%@",URL_MasterCenter,cell.itemData[@"buyerUid"]];
        [self.viewController pushViewControllerWithUrl:url];
    }else if (actionTag==2){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
        GoodDetailViewController *myView = [story instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
        myView.params = @{@"courseId":cell.itemData[@"courseId"],@"coverStr":cell.itemData[@"cover"]} ;
        [self.viewController.navigationController pushViewController:myView animated:YES];

    }else if (actionTag==3){
        [self doRefuseOrder:cell.itemData];
    }else if (actionTag==4){
        [self doAcceptOrder:cell.itemData];
    }
}




- (NSMutableArray*)orderDataSource
{
    if (_orderDataSource==nil) {
        _orderDataSource = [NSMutableArray array];
    }
    return _orderDataSource;
}

- (NSMutableDictionary*)groupDataSource{
    if (_groupDataSource==nil) {
        _groupDataSource = [NSMutableDictionary dictionary];
    }
    return _groupDataSource;
}

- (NSMutableArray*)reasonDataSource{
    if (_reasonDataSource==nil) {
        _reasonDataSource = [NSMutableArray array];
    }
    return _reasonDataSource;
}
- (void)getRefuseOrderReason{
    
    NSArray *array = [UserClient sharedUserClient].order_refund_msg;
    if(array && array.count){
        [self.reasonDataSource addObjectsFromArray:array];
        [self showRefuseOrderSeason];
    }
}

- (void)doAcceptOrder:(id)orderData{
    
    [self.viewController showHUDWithString:@"提交中..."];
    HttpManagerCenter *httpService = [HttpManagerCenter sharedHttpManager];
    [[httpService  updateOrderStatus:orderData[@"oid"] orderStatus:@"0" reason:@"" resultClass:nil] subscribeNext:^(BaseModel *model){
        
        if(model.code == 200){
            
            [self.viewController hiddenHUDWithString:@"接单成功" error:FALSE];
            [orderData setObject:@"0" forKey:@"orderStatus"];
            if(self.orderType){
                [self removeOrderFromDataSource:orderData];
            }
            [self.mTableView reloadData];
//            [[NSNotificationCenter defaultCenter] postNotificationName:changeOrderNotification object:orderData];
        }else{
            [self showRequestErrorMessage:model];
//           [self.viewController hiddenHUDWithString:model.message error:FALSE];
        }
        
    } error:^(NSError *error) {
        
        
        
    } completed:^{
        //         [self hiddenHUDWithString:nil error:NO];
    }];
    
}

- (void)showRefuseOrderSeason{
    CommonSelectViewController* vct = [CommonSelectViewController initCommonSelectViewController];
//    self.canSlidingBack = NO;
    NSMutableArray* textArray = [NSMutableArray array];
    for (NSString* item in self.reasonDataSource) {
        [textArray addObject:item];
    }
    vct.selectTextArray = textArray;
    [vct popViewControllerIn:self.viewController.navigationController cancelBlock:^{
//        self.canSlidingBack = YES;
    } sureBlock:^{
//        self.canSlidingBack = YES;
        self.refuseOrderReason =self.reasonDataSource[vct.selectIndex];
        [self submitRefuseOrder:self.refuseOrderReason];
    }];
    
}


- (void)doRefuseOrder:(id)orderData{
    self.refuseOrder = orderData;
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"请谨慎操作" message:@"多次拒单会严重影响用户体验哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
    alertView.tag =201;
    [alertView show];
}

- (void)submitRefuseOrder:(NSString*)reason{
    
    [self.viewController showHUDWithString:@"提交中..."];
    HttpManagerCenter *httpService = [HttpManagerCenter sharedHttpManager];
    [[httpService  updateOrderStatus:self.refuseOrder[@"oid"] orderStatus:@"5" reason:reason resultClass:nil] subscribeNext:^(BaseModel *model){
        
        if(model.code == 200){
            [self.refuseOrder setObject:@"5" forKey:@"orderStatus"];
            if(self.orderType){
                [self removeOrderFromDataSource:self.refuseOrder];
            }
            [self.mTableView reloadData];
//            [[NSNotificationCenter defaultCenter] postNotificationName:changeOrderNotification object:self.refuseOrder];
            
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"拒单成功" message:self.refuseOrderReason delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alertView show];
        }
        
    } error:^(NSError *error) {
        
        
        
    } completed:^{
        [self.viewController hiddenHUD];
    }];
    
}

- (void)removeOrderFromDataSource:(id)orderData{
    if (orderData==nil) {
        return;
    }
    BOOL endOver = FALSE;
    for (NSString* groupStr in self.orderDataSource) {
        NSMutableArray* orderArray = self.groupDataSource[groupStr];
        if (orderArray) {
            for (id order in orderArray) {
                if ([order isEqual:orderData]) {
                    [orderArray removeObject:order];
                    if (orderArray.count==0) {
                        [self.orderDataSource removeObject:groupStr];
                        [self.groupDataSource removeObjectForKey:groupStr];
                    }
                    endOver = TRUE;
                    break;
                }
            }
        }
        if (endOver) {
            [self.mTableView reloadData];
            break;
        }
    }
}


#pragma mark --  UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1 && alertView.tag==201) {
        if (self.reasonDataSource.count==0) {
            [self getRefuseOrderReason];
        }else{
            [self showRefuseOrderSeason];
        }
    }
}

@end
