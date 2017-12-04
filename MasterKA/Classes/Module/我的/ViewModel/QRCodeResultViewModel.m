//
//  QRCodeResultViewModel.m
//  MasterKA
//
//  Created by jinghao on 16/6/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "QRCodeResultViewModel.h"
#import "QROrderDetail0Cell.h"
#import "QROrderDetail1Cell.h"
#import "QROrderDetail2Cell.h"
#import "NSString+MasterTime.h"

@interface QRCodeResultViewModel ()
@property (nonatomic,strong)NSDictionary *resultInfo;
@property (nonatomic,strong,readwrite)RACCommand *changeOrderCommand;

@end

@implementation QRCodeResultViewModel

- (void)initialize
{
    [super initialize];
    @weakify(self);
    RAC(self,resultInfo) = [self.requestRemoteDataCommand.executionSignals.switchToLatest  map:^id(BaseModel *model) {
        @strongify(self);
        if (model.code==200) {
            return model.data;
        }else{
            [self showRequestErrorMessage:model];
        }
        return nil;
    }];
    
    [RACObserve(self, resultInfo) subscribeNext:^(id x) {
        @strongify(self);
        [self.mTableView reloadData];
    }];
    
    [self.changeOrderCommand.executing subscribeNext:^(NSNumber *x) {
        @strongify(self);
        if (x.boolValue) {
            [self.viewController showHUDWithString:@"提交中..."];
        }else{
            [self.viewController hiddenHUD];
        }
    }];
    
    [self.changeOrderCommand.executionSignals.switchToLatest subscribeNext:^(BaseModel *model) {
        @strongify(self);
        if (model.code==200) {
            alertShowMessage(@"验单成功");
            [self.viewController gotoBack];
        }else{
            [self showRequestErrorMessage:model];
        }
    }];
}

- (void)bindTableView:(UITableView *)tableView{
    [super bindTableView:tableView];
    [tableView registerCellWithReuseIdentifier:@"QROrderDetail0Cell"];
    [tableView registerCellWithReuseIdentifier:@"QROrderDetail1Cell"];
    [tableView registerCellWithReuseIdentifier:@"QROrderDetail2Cell"];
}

- (RACSignal*)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    return [self.httpService orderVerification:self.orderId uid:self.buyerId code:self.orderCode resultClass:nil];
}

- (RACCommand*)changeOrderCommand{
    if (!_changeOrderCommand) {
        @weakify(self);
        _changeOrderCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            return [self.httpService updateOrderStatus:self.orderId orderStatus:@"1" reason:nil resultClass:nil];
        }];
    }
    return _changeOrderCommand;
}

#pragma mark -- UITableViewDataSource,UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;//self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resultInfo==nil?0:6;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
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
    if (indexPath.row==0) {
        return 120.0f;
    }else if (indexPath.row==1){
        return 85.0f;
    }else{
        return 35.0f;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell;
    if (indexPath.row==0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"QROrderDetail0Cell" ];
        UIImageView* imageView = (UIImageView*)[cell viewWithTag:100];
        [imageView setImageWithURLString:self.resultInfo[@"user"][@"img_top"] placeholderImage:nil];
        UILabel* label = (UILabel*)[cell viewWithTag:101];
        label.text = self.resultInfo[@"user"][@"nikename"];
        label = (UILabel*)[cell viewWithTag:102];
        label.text = self.resultInfo[@"user"][@"intro"];
        
    }else if (indexPath.row==1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"QROrderDetail1Cell" ];
        UIImageView* imageView = (UIImageView*)[cell viewWithTag:100];
        [imageView setImageWithURLString:self.resultInfo[@"cover"] placeholderImage:nil];
        UILabel* label = (UILabel*)[cell viewWithTag:101];
        label.text = self.resultInfo[@"title"];
        label = (UILabel*)[cell viewWithTag:102];
        NSNumber* zfType = self.resultInfo[@"zf_type"];
        if (zfType.intValue==0) {
            label.text = [NSString stringWithFormat:@"单价：%@M点", self.resultInfo[@"price"]];
        }else{
            label.text = [NSString stringWithFormat:@"单价：￥%@", self.resultInfo[@"price"]];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"QROrderDetail2Cell" ];
        UILabel* label = (UILabel*)[cell viewWithTag:100];
        UILabel* label1 = (UILabel*)[cell viewWithTag:101];
        
        if(indexPath.row==2){
            label.text = @"验证码：";
            label1.text = self.resultInfo[@"code"];
        }else if(indexPath.row==3){
            label.text = @"套餐：";
            label1.text = self.resultInfo[@"specName"];
        }else if(indexPath.row==4){
            label.text = @"使用数量：";
            NSString *num = self.resultInfo[@"num"];
            if (num==nil || [num isEmpty]) {
                num=@"1";
            }
            label1.text = [NSString stringWithFormat:@"%@次",num];
        }else if(indexPath.row==5){
            label.text = @"上课时间：";
            label1.text = @"";
            NSString* startDate = [NSString timestampSwitchTime:[self.resultInfo[@"start_date"] doubleValue] andFormatter:@"YYYY-MM-dd"];
            if (startDate && [startDate isKindOfClass:[NSString class]] && startDate.length>0) {
                label1.text = [NSString stringWithFormat:@"%@ %@-%@",startDate,self.resultInfo[@"start_time"],self.resultInfo[@"end_time"]];
            }
        }else{
            label.text = @"";
            label1.text = @"";
        }
    }
    return cell;
}


@end
