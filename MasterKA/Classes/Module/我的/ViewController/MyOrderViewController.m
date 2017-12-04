//
//  MyOrderViewController.m
//  HiGoMaster
//
//  Created by jinghao on 15/6/4.
//  Copyright (c) 2015年 jinghao. All rights reserved.
//

#import "MyOrderViewController.h"
#import "MasterOrderInfoCell.h"



@interface MyOrderViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,MasterOrderInfoCellDelegate>
{
    int orderPage;
    int pageSize;
    BOOL needFresh;
}
@property (nonatomic,weak)IBOutlet UITableView* mTableView;
@property (nonatomic,strong)NSMutableArray* orderDataSource;
@property (nonatomic,strong)NSMutableDictionary* groupDataSource;
@property (nonatomic,strong)NSMutableArray* reasonDataSource;
@property (nonatomic,strong)id refuseOrder;
@property (nonatomic,strong)id refuseOrderReason;

@end

static NSString* OrderCellIdentifier = @"NewOrderInfoTableViewCell";//@"OrderInfoTableViewCell";
static NSString* MaseterOrderCellIdentifier = @"MasterOrderInfoCell";//@"OrderInfoTableViewCell";

static NSString* removeOrderNotification = @"removeOrderNotification";
static NSString* changeOrderNotification = @"changeOrderNotification";


@implementation MyOrderViewController




- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"订单管理";
   
    orderPage = 1;
    pageSize = 10;
    
    
    self.mTableView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    self.mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([self.mTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.mTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.mTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.mTableView.rowHeight = UITableViewAutomaticDimension;
    self.mTableView.estimatedRowHeight = 60;

    UINib *cellNib = [UINib nibWithNibName:@"MasterOrderInfoCell" bundle:nil];
    [self.mTableView registerNib:cellNib forCellReuseIdentifier:MaseterOrderCellIdentifier];
    
    
    [self addNotification];
}

- (void)dealloc{
    [self removeNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (needFresh) {
        [self.mTableView reloadData];
        needFresh = FALSE;
    }
}

- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeOrderNotification:) name:removeOrderNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrderNotification:) name:changeOrderNotification object:nil];
}
- (void)removeNotification{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:removeOrderNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:changeOrderNotification object:nil];

}

- (void)changeOrderNotification:(NSNotification*)sender{
    BOOL changeed = FALSE;
    for (NSString* groupStr in self.orderDataSource) {
        NSMutableArray* orderArray = self.groupDataSource[groupStr];
        if (orderArray) {
            NSUInteger index = 0;
            for (id order in orderArray) {
                if ([order[@"oid"] isEqual:sender.object[@"oid"]]) {
                    [orderArray replaceObjectAtIndex:index withObject:sender.object];
//                    [order setObject:sender.object[@"used"] forKey:@"used"];
                    changeed = TRUE;
                    break;
                }
                index++;
            }
        }
        if (changeed) {
            [self.mTableView reloadData];
            break;
        }
    }
}

- (void)removeOrderNotification:(NSNotification*)sender{
    [self removeOrderFromDataSource:sender.object];
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

- (void)getUserOrderList:(int)page isMore:(BOOL)isMore{
    NSString* tag = @"1";
    NSString* currentTime = nil;
    if (self.orderDataSource.count>0) {
        if (isMore) {
            tag = @"3";
            NSString* mothd = [self.orderDataSource lastObject];
            NSArray* array = self.groupDataSource[mothd];
            currentTime = [array lastObject][@"addtime"];
        }else{
            //            tag = @"2";
            //            currentTime = [self.orderDataSource firstObject][@"addtime"];
        }
    }
    __typeof(self)weakSelf = self;
    [self.masterHttpManager getMyOrder:self.masterGlobal.userId
                                   tag:tag
                           orderStatus:self.orderType
                              pageSize:pageSize
                           currentTime:currentTime
                       webServiceBlock:^(id data, NSString *errorMsg, NSError *error) {
                           if (errorMsg) {
                               [weakSelf dismissLoadingView:errorMsg error:TRUE];
                           }else{
                               if (isMore==FALSE) {
                                   [weakSelf.orderDataSource removeAllObjects];
                                   [weakSelf.groupDataSource removeAllObjects];
                               }
                               NSArray* array = (NSArray*)data;
                               for (id item in array) {
                                   NSString* month = item[@"key"];
                                   NSMutableArray* itemArray = weakSelf.groupDataSource[month];
                                   if (itemArray==nil) {
                                       itemArray=[NSMutableArray array];
                                       [weakSelf.groupDataSource setObject:itemArray forKey:month];
                                       [weakSelf.orderDataSource addObject:month];
                                   }
                                   [itemArray addObjectsFromArray:item[@"values"]];
                               }
                               [weakSelf.mTableView reloadData];

                               
//                               if (array && array.count>0) {
//                                   if (isMore) {
//                                       [self.orderDataSource addObjectsFromArray:data];
//                                   }else{
//                                       [self.orderDataSource removeAllObjects];
//                                       [self.orderDataSource addObjectsFromArray:data];
//                                   }
//                                   [self.mTableView reloadData];
//                               }
                               
                           }
                           if (isMore) {
                               [weakSelf.mTableView footerEndRefreshing];
                           }else{
                               [weakSelf.mTableView headerEndRefreshing];
                           }
                       }];
}


- (void)getMasterOrderData:(BOOL)isMore{
    NSString* tag = @"1";
    NSString* currentTime = nil;
    if (self.orderDataSource.count>0) {
        if (isMore) {
            tag = @"3";
            NSString* mothd = [self.orderDataSource lastObject];
            NSArray* array = self.groupDataSource[mothd];
            currentTime = [array lastObject][@"addtime"];
        }else{
            //            tag = @"2";
            //            currentTime = [self.orderDataSource firstObject][@"addtime"];
        }
    }
    __typeof(self)weakSelf = self;

    [self.masterHttpManager getMaterOrder:self.masterGlobal.userId
                                   tag:tag
                              orderStatus:self.orderType
                              pageSize:pageSize
                           currentTime:currentTime
                       webServiceBlock:^(id data, NSString *errorMsg, NSError *error) {
                           if (errorMsg) {
                               [weakSelf dismissLoadingView:errorMsg error:TRUE];
                           }else{
                               
                               if (isMore==FALSE) {
                                   [weakSelf.orderDataSource removeAllObjects];
                                   [weakSelf.groupDataSource removeAllObjects];
                               }
                               NSArray* array = (NSArray*)data;
                               for (id item in array) {
                                   NSString* month = item[@"key"];
                                   NSMutableArray* itemArray = weakSelf.groupDataSource[month];
                                   if (itemArray==nil) {
                                       itemArray=[NSMutableArray array];
                                       [weakSelf.groupDataSource setObject:itemArray forKey:month];
                                       [weakSelf.orderDataSource addObject:month];
                                   }
                                   [itemArray addObjectsFromArray:item[@"values"]];
                               }
                               [weakSelf.mTableView reloadData];
                               
//                               NSArray* array = (NSArray*)data;
//                               if (array && array.count>0) {
//                                   if (isMore) {
//                                       [self.orderDataSource addObjectsFromArray:data];
//                                   }else{
//                                       [self.orderDataSource removeAllObjects];
//                                       [self.orderDataSource addObjectsFromArray:data];
//                                      }
//                                   [self.mTableView reloadData];
//                               }
                               
                           }
                           if (isMore) {
                               [weakSelf.mTableView footerEndRefreshing];
                           }else{
                               [weakSelf.mTableView headerEndRefreshing];
                           }
                       }];
}

- (void)headerRereshing{
//    orderPage = 1;
    if (self.masterOrder) {
        [self getMasterOrderData:FALSE];
    }else{
        [self getUserOrderList:orderPage isMore:FALSE];
    }
}

- (void)footerRereshing{
//    orderPage ++;
    if (self.masterOrder) {
        [self getMasterOrderData:TRUE];
    }else{
        [self getUserOrderList:orderPage isMore:TRUE];
    }
}


- (void)doRefuseOrder:(id)orderData{
    self.refuseOrder = orderData;
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"请谨慎操作" message:@"多次拒单会严重影响用户体验哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
    alertView.tag =201;
    [alertView show];
}

- (void)submitRefuseOrder:(NSString*)reason{
//    [self showLoadingView:nil];
//    [self.masterHttpManager updateOrderStatus:self.refuseOrder[@"oid"] orderStatus:@"5" reason:reason webServiceBlock:^(id data, NSString *errorMsg, NSError *error) {
//        if(errorMsg){
//            [self dismissLoadingView:errorMsg error:TRUE];
//        }else{
//            [self dismissLoadingView];
////            [self dismissLoadingView:@"拒单成功" error:FALSE];
//            [self.refuseOrder setObject:@"5" forKey:@"used"];
//            if(self.orderType){
//                [self removeOrderFromDataSource:self.refuseOrder];
//            }
//            [self.mTableView reloadData];
//            [[NSNotificationCenter defaultCenter] postNotificationName:changeOrderNotification object:self.refuseOrder];
//
//            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"拒单成功" message:self.refuseOrderReason[@"desc"] delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];
//            [alertView show];
//        }
//    }];
}


- (void)masterOrderInfoCell:(MasterOrderInfoCell*)cell actionPhone:(NSString*)phones
{
    [self showPhonesActionSheet:phones];
}


#pragma mark -- UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.orderDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString* mothd = self.orderDataSource[section];
    NSArray* array = self.groupDataSource[mothd];
    return array.count;
//    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* view = [UIView new];
    view.backgroundColor = [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1];
    NSString* mothd = self.orderDataSource[section];
    UILabel* label = [UILabel new];
    label.text = mothd;
    label.textColor = [UIColor colorWithHex:0x333333];
    label.font = [UIFont systemFontOfSize:14.0f];
    [label sizeToFit];
    
    CGRect frame = label.frame;
    frame.origin.x = 12;
    frame.origin.y = (40-label.height)/2.0f;
    
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return 168;
    if(self.masterOrder){
        return 290.0f;
    }
    return 190.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* mothd = self.orderDataSource[indexPath.section];
    NSArray* array = self.groupDataSource[mothd];
    id itemData = array[indexPath.row];
    
    
    MasterOrderInfoCell* cell = [tableView dequeueReusableCellWithIdentifier:MaseterOrderCellIdentifier];
    cell.itemData = itemData;
    cell.delegate = self;
    return cell;
    
    
}





@end
