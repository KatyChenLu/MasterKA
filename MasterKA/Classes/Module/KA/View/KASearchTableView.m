//
//  KASearchTableView.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/12.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KASearchTableView.h"

#import "UITableView+FDTemplateLayoutCell.h"
#import "KAHomeTableViewCell.h"
#import "MasterTableHeaderView.h"
#import "MasterTableFooterView.h"
#import "KADetailViewController.h"
@interface KASearchTableView ()<UITableViewDelegate, UITableViewDataSource>{
    CALayer     *layer;
    UIImageView *_imageView;
    UIButton    *_btn;
}

@property (nonatomic,strong) UIBezierPath *path;
@end

@implementation KASearchTableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ( self = [super initWithFrame:frame style:UITableViewStylePlain]) {
        
        self.backgroundColor = RGBFromHexadecimal(0xf7f5f6);
        
        self.delegate = self;
        
        self.dataSource = self;
        
        //        [self setSeparatorInset:UIEdgeInsetsZero];
        
        [self setSeparatorColor:RGBFromHexadecimal(0xdbdbdb)];
        
        [self registerNib:[UINib nibWithNibName:@"KAHomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"KAHomeTableViewCell"];
        
        
        self.estimatedRowHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        
    }
    
    return self;
}
- (void)setKaHomeData:(NSMutableArray *)kaHomeData {
    if (self.isChange) {
        [_kaHomeData removeAllObjects];
        self.isChange = NO;
    }
    if (_kaHomeData.count == 0) {
        _kaHomeData = kaHomeData;
    }else {
        [_kaHomeData addObjectsFromArray:kaHomeData];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:@"KAHomeTableViewCell" cacheByIndexPath:indexPath configuration:nil];;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.kaHomeData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KAHomeTableViewCell *kaHomeCell =[tableView dequeueReusableCellWithIdentifier:@"KAHomeTableViewCell" forIndexPath:indexPath];
    kaHomeCell.kaHomeModel = self.kaHomeData[indexPath.row];
    
    
    
    @weakify(self);
    
    [kaHomeCell setCanceljoinClick:^(NSString *ka_course_id) {
        @strongify(self);
                [self.baseVC deleteVoteActionWithKaCourseId:ka_course_id];
        
    }];
    
    [kaHomeCell setJoinClick:^(UIImageView *joinImgView,NSString *ka_course_id) {
        @strongify(self);
        
       [self.baseVC addVoteActionWithJoinImgView:joinImgView KaCourseId:ka_course_id Animation:YES];
    }];
    
    return kaHomeCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KAHomeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    KADetailViewController *kaDetailVC = [[KADetailViewController alloc] init];
    
    kaDetailVC.ka_course_id = self.kaHomeData[indexPath.row][@"ka_course_id"];
    
    kaDetailVC.headViewUrl = self.kaHomeData[indexPath.row][@"course_cover"];
    
    id object = [self nextResponder];
    
    while (![object isKindOfClass:[UIViewController class]] &&
           object != nil) {
        object = [object nextResponder];
    }
    
    UIViewController *uc=(UIViewController*)object;
    [uc.navigationController pushViewController:kaDetailVC animated:YES];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
