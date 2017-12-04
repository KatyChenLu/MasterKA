//
//  MyOrderDetailmodel.m
//  MasterKA
//
//  Created by hyu on 16/6/14.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MyOrderDetailmodel.h"
#import "OrderDetailCell.h"
#import "OrderInformationCell.h"
#import "CommonSelectViewController.h"
#import "GoodDetailViewController.h"
@interface MyOrderDetailmodel ()
@property (nonatomic,strong) NSMutableArray * reasonDataSource;
@property (nonatomic,strong) NSString * refuseOrderReason;
@property (nonatomic,strong,readwrite)RACCommand *userInfo;
@property (nonatomic,strong,readwrite)RACCommand *courseDetail;
@end
@implementation MyOrderDetailmodel
- (void)initialize
{
    [super initialize];
    //    [[self.requestRemoteDataCommand execute:nil] subscribeNext:^(id x) {
    //        NSLog(@"======111 ==== %@",x);
    //    }];
    @weakify(self)
    self.userInfo = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *model) {
        @strongify(self)
        NSString *url = [NSString stringWithFormat:@"%@?uid=%@",URL_MasterCenter,model[@"uid"]];
        [self.viewController pushViewControllerWithUrl:url];
        
        return [RACSignal empty];
    }];
    self.courseDetail = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *model) {
        @strongify(self)
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
        GoodDetailViewController *myView = [story instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
        myView.params = @{@"courseId":model[@"cid"]} ;
        [self.viewController.navigationController pushViewController:myView animated:YES];
        return [RACSignal empty];
    }];
}

- (void)bindTableView:(UITableView *)tableView
{
    [super bindTableView:tableView];
    self.cellReuseIdentifier = @"OrderDetailCell";
    [self.mTableView registerCellWithReuseIdentifier:@"OrderDetailCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"OrderInformationCell"];
}

- (RACSignal*)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    RACSignal *fetchSignal = [self.httpService getOrderDetail:self.orderId mainOrderId:self.mainOrderId resultClass:nil];
    //    return fetchSignal;
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
      
        if (model.code==200) {
            if (![model.data  isEqual:@""]){
                NSMutableArray *orderDetailArray=[NSMutableArray array];
                [orderDetailArray addObject:model.data];
                [orderDetailArray addObject:model.data];
                self.dataSource =@[orderDetailArray];
    
                [self.mTableView reloadData];
                if ([model.data objectForKey:@"coupon"]==nil ) {
                    [self.delegate hideBackGroudview];
                }
                else{
                    [self.delegate showSmallred];
                }
                if([model.data objectForKey:@"coupon"]!=nil &&[self.fromCode isEqualToString:@"1"]){
                    NSDictionary* redDic = [model.data objectForKey:@"coupon"];
                    self.endTime = [redDic objectForKey:@"end_time"];
                    self.limitPrice = [redDic objectForKey:@"limit_price"];
                    self.redPrice = [redDic objectForKey:@"price"];
                   [self.delegate DotoShowRedPaket];
                }
                NSDictionary* fenxiangDic = [model.data objectForKey:@"share_data"];
                self.desc = [fenxiangDic objectForKey:@"desc"];
                self.imgUrl = [fenxiangDic objectForKey:@"imgUrl"];
                self.link = [fenxiangDic objectForKey:@"link"];
                self.fenxiangTitle = [fenxiangDic objectForKey:@"title"];
            }
        }else{
            [self showRequestErrorMessage:model];
        }
        return model;
    }];
}
- (NSString*)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==1){
        return @"OrderInformationCell";
    }else{
        return self.cellReuseIdentifier;
    }
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(NSDictionary*)object
{
    if(indexPath.row==0){
         OrderDetailCell *DetailCell = (OrderDetailCell *) cell;
        [DetailCell prepareView:object];
        [DetailCell.buttonBorder addTarget:self action:@selector(phoneTo:) forControlEvents:UIControlEventTouchUpInside];
        [DetailCell.buttonBorder setTag:100];
        [DetailCell.kefuButton addTarget:self action:@selector(phoneTo:) forControlEvents:UIControlEventTouchUpInside];
        DetailCell.userInfoRAC=self.userInfo;
        DetailCell.courseInfoRAC=self.courseDetail;
    }else{
        OrderInformationCell *DetailCell = (OrderInformationCell *) cell;
        [DetailCell prepareView:object];
        if([object[@"order_status"] intValue]==4){
            [DetailCell.refuseOrder setHidden:NO];
            [DetailCell.refuseOrder addTarget:self action:@selector(doRefuseOrder) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}
-(void)phoneTo :(id) sender{
    if([sender tag]==100){
         [self.viewController showPhonesActionSheet:self.dataSource[0][0][@"course_mobile"]];
    }else{
        [self.viewController showPhonesActionSheet:CustomerServicePhone];
    }
}
- (void)doRefuseOrder{
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"请谨慎操作" message:@"确定取消订单！！" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
    alertView.tag =201;
    [alertView show];
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
- (void)showRefuseOrderSeason{
    CommonSelectViewController* vct = [CommonSelectViewController initCommonSelectViewController];
    //    self.canSlidingBack = NO;
    NSMutableArray* textArray = [NSMutableArray array];
    for (NSString* item in self.reasonDataSource) {
        [textArray addObject:item];
    }
    vct.selectTextArray = textArray;
    @weakify(self);
    [vct popViewControllerIn:self.viewController.navigationController cancelBlock:^{
        //        self.canSlidingBack = YES;
    } sureBlock:^{
        @strongify(self);
        //        self.canSlidingBack = YES;
        self.refuseOrderReason =self.reasonDataSource[vct.selectIndex];
        [self submitRefuseOrder:self.refuseOrderReason];
    }];
    
}
- (void)submitRefuseOrder:(NSString*)reason{
    
    [self.viewController showHUDWithString:@"提交中..."];
    HttpManagerCenter *httpService = [HttpManagerCenter sharedHttpManager];
    @weakify(self);
    [[httpService  updateOrderStatus:self.dataSource[0][0][@"oid"] orderStatus:@"5" reason:reason resultClass:nil] subscribeNext:^(BaseModel *model){
        @strongify(self);
        if(model.code == 200){
            [self.viewController hiddenHUD];
            //            [[NSNotificationCenter defaultCenter] postNotificationName:changeOrderNotification object:self.refuseOrder];
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"取消订单成功" message:self.refuseOrderReason delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
            [alertView show];
        }else{
            [self.viewController showRequestErrorMessage:model];
        }
    } error:^(NSError *error) {
    } completed:^{
    }];
    
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
