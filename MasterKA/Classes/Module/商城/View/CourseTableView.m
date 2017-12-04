//
//  CourseTableView.m
//  MasterKA
//
//  Created by 余伟 on 16/8/17.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "CourseTableView.h"
#import "CourseTableViewCell.h"
#import "CourseListModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "GoodDetailViewController.h"


@interface CourseTableView ()<UITableViewDelegate , UITableViewDataSource>

@end

@implementation CourseTableView


-(instancetype)initWithFrame:(CGRect)frame
{
    
    if ( self = [super initWithFrame:frame]) {
        
        self.backgroundColor = RGBFromHexadecimal(0xf7f5f6);
        self.delegate = self;
        
        self.dataSource = self;
        
         self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [self registerNib:[UINib nibWithNibName:@"CourseTableViewCell" bundle:nil] forCellReuseIdentifier:@"CourseTableViewCell"];
        
        
    }
    
    return self;
}


-(void)setModel:(CourseListModel *)model
{
    
    _model = model;
    
    if (_isChange) {
        
        [_courseArr removeAllObjects];
        
        self.isChange = NO;
        
    }

    
    if (_courseArr.count == 0) {
        
        _courseArr = model.course_list.mutableCopy;
        
    }else{
        
        [_courseArr addObjectsFromArray:model.course_list];
        
        
        
        
        
    }


}



-(void)setCourseArr:(NSMutableArray *)courseArr
{

    
    if (_courseArr.count == 0) {
        
        _courseArr = courseArr;
 
    }else
    {
          [_courseArr addObjectsFromArray:courseArr];
    }
    
}







#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    
    return _courseArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

{
    CourseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTableViewCell" forIndexPath:indexPath];
    
    cell.model = _courseArr[indexPath.row];
    
    
    return cell;
    
}


#pragma UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat height = [tableView fd_heightForCellWithIdentifier:@"CourseTableViewCell" configuration:^(id cell) {
    
    }];
    return height;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
    GoodDetailViewController *myView = [story instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
    if(_courseArr && _courseArr[indexPath.row] ){
        CourseModel *mode = _courseArr[indexPath.row];
        if([mode isKindOfClass:[CourseModel class]]){
//            myView.params = @{@"courseId":mode.course_id,@"coverStr":mode.cover} ;
            
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


@end
