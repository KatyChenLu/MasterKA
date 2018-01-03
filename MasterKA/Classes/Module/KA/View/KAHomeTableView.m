//
//  KAHomeTableView.m
//  MasterKA
//
//  Created by ChenLu on 2017/10/10.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAHomeTableView.h"


#import "UITableView+FDTemplateLayoutCell.h"
#import "KAHomeTableViewCell.h"
#import "MasterTableHeaderView.h"
#import "MasterTableFooterView.h"
#import "KADetailViewController.h"


@interface KAHomeTableView ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>{
    CALayer     *layer;
    UIImageView *_imageView;
    UIButton    *_btn;
}

@property (nonatomic,strong) UIBezierPath *path;
@property (nonatomic, strong)NSMutableArray *addVoteKAID;
@property (nonatomic, strong)NSMutableArray *cancelVoteKAID;

@property (nonatomic, strong)NSTimer *myTimer;

@end


@implementation KAHomeTableView
- (instancetype)initWithFrame:(CGRect)frame{
    
    if ( self = [super initWithFrame:frame style:UITableViewStylePlain]) {
        
        self.backgroundColor = RGBFromHexadecimal(0xf7f5f6);
        
        self.delegate = self;
        
        self.dataSource = self;
        
        self.addVoteKAID = [NSMutableArray array];
        self.cancelVoteKAID = [NSMutableArray array];
        
        //        [self setSeparatorInset:UIEdgeInsetsZero];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        //        [self setSeparatorColor:RGBFromHexadecimal(0xdbdbdb)];
        
        [self registerNib:[UINib nibWithNibName:@"KAHomeTableViewCell" bundle:nil] forCellReuseIdentifier:@"KAHomeTableViewCell"];
        
        self.isShowCusBtn = YES;
        self.estimatedRowHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addVoteBtnChange:) name:@"addVote" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelVoteBtnChange:) name:@"cancelVote" object:nil];
        if ([self.baseVC isEqual:[KAHomeViewController class]]) {
        self.myTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(showCustomBtn) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.myTimer forMode:NSRunLoopCommonModes];
        }
    }
    
    return self;
}
- (void)cancelVoteBtnChange:(NSNotification *)notify {
    NSDictionary * infoDic = [notify object];
    
    if ([self.addVoteKAID containsObject:infoDic[@"ka_course_id"]]) {
        [self.addVoteKAID removeObject:infoDic[@"ka_course_id"]];
    }
    if (![self.cancelVoteKAID containsObject:infoDic[@"ka_course_id"]]) {
        [self.cancelVoteKAID addObject:infoDic[@"ka_course_id"]];
    }
    
}
- (void)addVoteBtnChange:(NSNotification *)notify {
    NSDictionary * infoDic = [notify object];
    if ([self.cancelVoteKAID containsObject:infoDic[@"ka_course_id"]]) {
        [self.cancelVoteKAID removeObject:infoDic[@"ka_course_id"]];
    }
    if (![self.addVoteKAID containsObject:infoDic[@"ka_course_id"]]) {
        [self.addVoteKAID addObject:infoDic[@"ka_course_id"]];
    }
    
}
//-(void)logoutAction {
//    [self.addVoteKAID removeAllObjects];
//    [self.cancelVoteKAID removeAllObjects];
//}
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (self.isFilter) {
        return 0;
//    }
//    return 42;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView * headerView = [[UIView alloc]init];
//    headerView.backgroundColor = [UIColor whiteColor];
//    
//    UILabel * showLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 26)];
//    showLabel.text = @"热门推荐";
//    showLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:22];
//    showLabel.textColor = [UIColor blackColor];
//    showLabel.backgroundColor = [UIColor whiteColor];
//    [headerView addSubview:showLabel];
//    
//    return headerView;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.kaHomeData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KAHomeTableViewCell *kaHomeCell =[tableView dequeueReusableCellWithIdentifier:@"KAHomeTableViewCell" forIndexPath:indexPath];
    kaHomeCell.kaHomeModel = self.kaHomeData[indexPath.row];
    
    for (NSString * addVoteStr in self.addVoteKAID) {
        if ([self.kaHomeData[indexPath.row][@"ka_course_id"] isEqualToString:addVoteStr]) {
            [kaHomeCell.kaHomeModel setValue:@"1" forKey:@"is_vote_cart"];
            kaHomeCell.voteBtn.selected = YES;
            kaHomeCell.voteBtn.borderWidth = 1.0f;
            kaHomeCell.voteBtn.borderColor = RGBFromHexadecimal(0xb9b8af);
            
        }
    }
    
    for (NSString *cancelVoteStr in self.cancelVoteKAID) {
        if ([self.kaHomeData[indexPath.row][@"ka_course_id"] isEqualToString:cancelVoteStr]){
            [kaHomeCell.kaHomeModel setValue:@"0" forKey:@"is_vote_cart"];
            kaHomeCell.voteBtn.selected = NO;
            kaHomeCell.voteBtn.borderWidth = 0.0f;
            kaHomeCell.voteBtn.borderColor = [UIColor clearColor];
        }
    }
    
    kaHomeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    @weakify(self);
    
    [kaHomeCell setCanceljoinClick:^(NSString *ka_course_id) {
        @strongify(self);
        
        [self.baseVC deleteVoteActionWithKaCourseId:ka_course_id];
        
    }];
    
    [kaHomeCell setJoinClick:^(UIImageView *joinImgView,NSString *ka_course_id) {
        @strongify(self);
        [self.baseVC addVoteActionWithJoinImgView:joinImgView KaCourseId:ka_course_id Animation:YES];
        
    }];
    
    [kaHomeCell setTodoLogin:^{
        @strongify(self);
        BaseViewController *vc = (BaseViewController *)self.superViewController;
        [vc doLogin];
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
- (NSTimer *)myTimer {
    if (!_myTimer) {
        _myTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(showCustomBtn) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_myTimer forMode:NSRunLoopCommonModes];
    }
    return _myTimer;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
 
    if ([self.baseVC isEqual:[KAHomeViewController class]]) {
        [self.myTimer invalidate];
        self.myTimer = nil;
        [(KAHomeViewController *)self.baseVC showCusBtn:NO];
        self.isShowCusBtn = NO;
    }
   
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.baseVC isEqual:[KAHomeViewController class]]) {
    self.myTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(showCustomBtn) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.myTimer forMode:NSRunLoopCommonModes];
    }
}
-(void)showCustomBtn{

        NSLog(@"szdfasdasdd---sdasdasd99999999999999999999999@-@");
    if (!self.isShowCusBtn) {
        [(KAHomeViewController *)self.baseVC showCusBtn:YES];
        self.isShowCusBtn = YES;
    }
    [self.myTimer invalidate];
    self.myTimer = nil;
}
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addVote" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"cancelVote" object:nil];
    [self.myTimer invalidate];
    self.myTimer = nil;
}
@end
