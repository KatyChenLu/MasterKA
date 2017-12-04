//
//  TwoLevelTableView.m
//  MasterKA
//
//  Created by 余伟 on 16/12/13.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "TwoLevelTableView.h"

@interface TwoLevelTableView()<UITableViewDelegate , UITableViewDataSource>

@end


@implementation TwoLevelTableView

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
        
        self.delegate = self;
        self.dataSource = self;
        
       self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
      
        self.tableFooterView = [UIView new];
    }
    
    return self;
}


-(void)setSubModel:(NSArray *)subModel
{
    _subModel = subModel;
    
    [self reloadData];
    
  
    
}

#pragma UITableViewDataSource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.subModel.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"subCategory" forIndexPath:indexPath];
    
   
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.contentView.height, self.width, 1)];
    
    lineView.backgroundColor = [UIColor colorWithHex:0xe1e1e1];
    
    [cell addSubview:lineView];
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"查看全部";
    }else
    {
        NSDictionary * model = self.subModel[indexPath.row-1];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@" , model[@"name"]];
    }
    
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary * model = nil;
    

    if (indexPath.row != 0) {
        
       model = self.subModel[indexPath.row-1];
        
        self.dismiss(model[@"id"]);
        
        [self.categoryBtn setTitle:model[@"name"] forState:UIControlStateNormal];
        
    }else
    {
        if (self.all){
            
           [self.categoryBtn setTitle:@"全部分类" forState:UIControlStateNormal];
            self.dismiss(@"0");
        }else
        {
            self.all = NO;
            [self.categoryBtn setTitle:self.firstLevel forState:UIControlStateNormal];
            self.dismiss(self.checkAllId);
        }
    }
    
    
    
}
@end
