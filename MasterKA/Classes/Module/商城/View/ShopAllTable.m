//
//  ShopAllTable.m
//  MasterKA
//
//  Created by 余伟 on 16/9/26.
//  Copyright © 2016年 jinghao. All rights reserved.
//


#define counts 2
#define btnW  ([UIScreen mainScreen].bounds.size.width-MARGIN)*0.5
#define btnH    69
#define MARGIN  2
#define RANDOMCOLOR [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0];

#import "ShopAllTable.h"
#import "ImageTopBtn.h"
#import "CourseTableView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "GoodDetailViewController.h"
#import "CourseTableViewCell.h"


@interface ShopAllTable ()<UITableViewDelegate , UITableViewDataSource>

@end

@implementation ShopAllTable

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ( self = [super initWithFrame:frame style:UITableViewStylePlain]) {
        
        self.backgroundColor = RGBFromHexadecimal(0xf7f5f6);
        
        self.delegate = self;
        
        self.dataSource = self;
        
        [self setSeparatorInset:UIEdgeInsetsZero];
        
        [self setSeparatorColor:RGBFromHexadecimal(0xdbdbdb)];
        
        [self registerNib:[UINib nibWithNibName:@"CourseTableViewCell" bundle:nil] forCellReuseIdentifier:@"CourseTableViewCell"];
        
    }
    
    return self;
}

- (void)setItemModel:(NSArray *)itemModel{
    
    if (_ischange) {
        
        [_itemModel removeAllObjects];
        
    }
    
    if (_itemModel.count == 0) {
        
        _itemModel = itemModel.mutableCopy;
    }
    
}

- (void)setModel:(NSMutableArray *)model{
    
    if (_ischange) {
        
        [_model removeAllObjects];
        
        self.ischange = NO;
        
    }
    
    
    if (_model.count == 0) {
        
        _model = model.mutableCopy;
        
    }else{
        
        [_model addObjectsFromArray:model];
    }
    
    NSLog(@"%ld" , _model.count);
}

#pragma UITableViewDataSource


-(NSInteger)numberOfRowsInSection:(NSInteger)section
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        return self.model.count;
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CourseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTableViewCell"];
    
    cell.layoutMargins = UIEdgeInsetsZero;
    
    cell.model = self.model[indexPath.row];
    
    return cell;
}


#pragma UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"CourseTableViewCell" configuration:nil];
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
    GoodDetailViewController *myView = [story instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
    if(_model && _model[indexPath.row] ){
        CourseModel *mode = _model[indexPath.row];
        if([mode isKindOfClass:[CourseModel class]]){
//            myView.params = @{@"courseId":mode.course_id,@"coverStr":mode.cover,@"title":mode.title,@"price":mode.price} ;
            
            id object = [self nextResponder];
            
            while (![object isKindOfClass:[UIViewController class]] &&
                   object != nil) {
                object = [object nextResponder];
            }
            
            UIViewController *uc=(UIViewController*)object;
            [uc.navigationController pushViewController:myView animated:YES];
        }
        
        
    }
    
    
}


-(void)pushH5:(ShopTopImageBtn *)sender
{
    
    self.jumpH5(sender.pfurl);
    
}


@end
