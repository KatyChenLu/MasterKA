//
//  PaySuccessController.m
//  MasterKA
//
//  Created by 余伟 on 16/8/30.
//  Copyright © 2016年 jinghao. All rights reserved.
//
#define PaySuccessCellIdentifer  @"PaySuccessCell"
#define GroupMemberCellIdentifer  @"GroupMemberCell"
#define GroupMethodCellIdentifer  @"GroupMethodCell"


#define Margin 28
#define counts 5
#define avgWidth @(([UIScreen mainScreen].bounds.size.width-6*Margin)/counts)
#import "PaySuccessController.h"
#import "PaySuccessTableView.h"
#import "PaySuccessCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "GroupMemberCell.h"
#import "GroupMethodCell.h"
#import "PaySuccessModel.h"
#import "GoodDetailViewController.h"
#import "MyOrderDetailController.h"
@interface PaySuccessController ()<UITableViewDelegate , UITableViewDataSource>

@property(nonatomic , strong)HttpManagerCenter * httpService;

@end

@implementation PaySuccessController
{
    NSDictionary* _data;
    PaySuccessTableView * payTableView;
    NSString * num;
     UIButton * _inviteBtn;
    UIView * footView;
    UIView *backgroudView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestRemoteDataSignalWithPage:1];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BackNormal"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoBack)];
    [self.navigationItem setLeftBarButtonItem:backItem];

    
    
    payTableView = [PaySuccessTableView PaySuccessTableViewWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-44)];
    
    [payTableView registerClass:[PaySuccessCell class] forCellReuseIdentifier:PaySuccessCellIdentifer];
    
    [payTableView registerClass:[GroupMemberCell class] forCellReuseIdentifier:GroupMemberCellIdentifer];
    
    [payTableView registerClass:[GroupMethodCell class] forCellReuseIdentifier:GroupMethodCellIdentifer];
    
    payTableView.delegate = self;
    
    payTableView.dataSource = self;
    
//
    
    [self.view addSubview:payTableView];
    _inviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _inviteBtn.layer.cornerRadius = 6;
    
    [_inviteBtn setTitle:@"邀请好友参团" forState:UIControlStateNormal];
    
    [_inviteBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_inviteBtn setBackgroundColor:MasterDefaultColor];
    
    [_inviteBtn addTarget: self action:@selector(Share:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_inviteBtn];
    
    [_inviteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.bottom.equalTo(self.view);
        
        make.centerX.equalTo(self.view);
        //        make.left.equalTo(self.contentView).offset(20);
        make.width.equalTo(@(self.view.width));
        make.height.equalTo(@44);
        //        make.bottom.mas_equalTo(footView.mas_bottom).offset(-15);
        
    }];

    
}


-(void)clicktoBackGround{
    
    [backgroudView removeFromSuperview];
    
    backgroudView = nil;

}





-(void)gotoBack
{
    
    if (self.isBuy) {
        
        for (BaseViewController * vc in self.navigationController.viewControllers) {
            
            if ([vc isKindOfClass:[GoodDetailViewController class]]) {
                
                
                [self.navigationController popToViewController:vc animated:YES];
                
                self.isBuy = NO;
            }
            
        }
        
    }else{
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    
    
    
    
}


- (void)Share:(UIButton *)sender{
    
    NSDictionary * dic = _data[@"share_data"];
    
    [self shareContentOfApp:dic];
  
}

- (HttpManagerCenter *)httpService{
    
    if (!_httpService) {
        
        _httpService = [HttpManagerCenter sharedHttpManager];
        
    }
    
    return _httpService;
    
}

- (void)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    
    RACSignal *fetchSignal = [self.httpService getOrderDetail:self.orderInfo[@"orderId"] mainOrderId:self.orderInfo[@"main_order_id"] resultClass:nil];
    //    return fetchSignal;
    
    [fetchSignal subscribeNext:^(BaseModel * model) {
        
        NSLog(@"%@",model.data);
        _data = model.data;
        if([_data[@"is_groupbuy"]isEqualToString:@"0"])
        {
                UIViewController *vct = [UIViewController viewControllerWithStoryboard:@"Mine" identifier:@"MyOrderDetailController"];
                if([self.orderInfo objectForKey:@"main_order_id"]!=nil)
                {
                    NSDictionary * dic = @{@"oid":[self.orderInfo objectForKey:@"main_order_id"],@"isfrom":@"1"};
                    [(MyOrderDetailController*)vct setValue:dic forKey:@"params"];
                    
                }
                [self pushViewController:vct animated:YES];
        }
        else{
            [payTableView reloadData];
        }
    }];
    
}

#pragma UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell * cell;
    
    if (indexPath.row == 0) {
        
        cell =[tableView dequeueReusableCellWithIdentifier:PaySuccessCellIdentifer forIndexPath:indexPath];
        
        ((PaySuccessCell *)cell).infoDic = _data[@"course"];
        
    }
    
    else if (indexPath.row == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:GroupMemberCellIdentifer forIndexPath:indexPath];
        
        if (_data != nil) {
            
            
            ((GroupMemberCell *)cell).infoDic = @{@"current_time":_data[@"current_time"],@"groupbuy_endtime":_data[@"groupbuy_endtime"],@"groupbuy_num":_data[@"groupbuy_num"],@"user":_data[@"user"]};
            
            num = _data[@"groupbuy_num"] ;
        }
        
        
    }else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:GroupMethodCellIdentifer forIndexPath:indexPath];
        
        

        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



#pragma UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //    switch (indexPath.row) {
    //        case 0:
    //            return [tableView fd_heightForCellWithIdentifier:PaySuccessCellIdentifer cacheByIndexPath:indexPath configuration:nil];
    //            break;
    //        case 1:
    //            return [tableView fd_heightForCellWithIdentifier:GroupMemberCellIdentifer cacheByIndexPath:indexPath configuration:nil];
    //            break;
    //        case 2:
    //            return [tableView fd_heightForCellWithIdentifier:PaySuccessCellIdentifer cacheByIndexPath:indexPath configuration:nil];
    //            break;
    
    
    if (indexPath.row == 0) {
        
        return [tableView fd_heightForCellWithIdentifier:PaySuccessCellIdentifer cacheByIndexPath:indexPath configuration:nil];
        
    }else if (indexPath.row == 1){
        
//        return [tableView fd_heightForCellWithIdentifier:GroupMemberCellIdentifer cacheByIndexPath:indexPath configuration:nil];
        
        if ([num integerValue] / counts == 0) {
            
            return Margin + [avgWidth integerValue] + 75;
        }else
        {
            
            NSInteger index = [num integerValue] / counts;
            return  index *(Margin+ [avgWidth integerValue])+75;
        }
      
    }else{
        
        return [tableView fd_heightForCellWithIdentifier: GroupMethodCellIdentifer cacheByIndexPath:indexPath configuration:nil];
        
    }
    
    
}






@end

