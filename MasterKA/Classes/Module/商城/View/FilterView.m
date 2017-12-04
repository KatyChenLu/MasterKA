//
//  FilterView.m
//  MasterKA
//
//  Created by 余伟 on 16/12/13.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "FilterView.h"
#import "categoryFilterCell.h"

@interface FilterView ()<UITableViewDelegate , UITableViewDataSource,UIGestureRecognizerDelegate>

@end

@implementation FilterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _firstCategoryView = [[FirstLevelTableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 1)];
        
//        [_firstCategoryView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"allCategory"];
        
        
        _firstCategoryView.delegate = self;
        _firstCategoryView.dataSource = self;
        
        _twoCategoryView = [[TwoLevelTableView alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 1)];
//        _sequenceView.delegate = self;
//        _twoCategoryView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
         [_twoCategoryView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"subCategory"];

        _firstCategoryView.estimatedRowHeight = 0;
        _firstCategoryView.estimatedSectionFooterHeight = 0;
        _firstCategoryView.estimatedSectionHeaderHeight = 0;
        
        _twoCategoryView.estimatedRowHeight = 0;
        _twoCategoryView.estimatedSectionFooterHeight = 0;
        _twoCategoryView.estimatedSectionHeaderHeight = 0;
        
        
        
        [_twoCategoryView setDismiss:^(id ID){
           
            self.filter(ID);
            
            [self removeFromSuperview];
            
        }];
        
        
//        [_firstCategoryView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
//        
//         [self tableView:_firstCategoryView didSelectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

        [self addSubview:_firstCategoryView];
        [self addSubview:_twoCategoryView];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        
        tap.delegate = self;
        
        [self addGestureRecognizer:tap];
        
    }
    return self;
}



-(void)setModel:(NSArray *)model
{
    _model = model;
    
    [_firstCategoryView reloadData];
    //默认选中第一个
      [_firstCategoryView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    NSDictionary * dic = _model[0];
    _twoCategoryView.subModel = dic[@"sub_category_list"];
    
    _twoCategoryView.checkAllId = dic[@"id"];
    
    _twoCategoryView.firstLevel = dic[@"name"];
    
}

#pragma UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    categoryFilterCell * cell = [tableView dequeueReusableCellWithIdentifier:@"categoryFilterCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithHex:0xfafafa];
    
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    
    cell.selectedBackgroundView.backgroundColor =  [UIColor whiteColor];
 //   cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (indexPath.row == 0) {
        
        
        cell.categoryLabel.text = @"全部分类";
   
    }else
    {
        
        NSDictionary * model = self.model[indexPath.row-1];
        
        
        
        cell.categoryLabel.text = [NSString stringWithFormat:@"%@" , model[@"name"]];
    }
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        
        _twoCategoryView.all = YES;
        
    }else
    {
        
        NSDictionary * model = self.model[indexPath.row-1];
        
        _twoCategoryView.subModel = model[@"sub_category_list"];
        
        _twoCategoryView.checkAllId = model[@"id"];
        
        _twoCategoryView.firstLevel = model[@"name"];
        
    }
    
    
}

#pragma UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;
{
    
    if ([NSStringFromClass([touch.view class])isEqualToString:NSStringFromClass([self class])]) {
        
        
        self.twoCategoryView.categoryBtn.selected = NO;
        _firstCategoryView = nil;
        _twoCategoryView = nil;
        [self removeFromSuperview];
        
        return YES;
    }
    return NO;
}


-(void)tap:(UITapGestureRecognizer *)recognizer
{
    
    
}


@end
