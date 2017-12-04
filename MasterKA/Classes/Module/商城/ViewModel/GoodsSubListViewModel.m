//
//  GoodsSubListViewModel.m
//  MasterKA
//
//  Created by xmy on 16/5/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "GoodsSubListViewModel.h"
#import "CourseListModel.h"
#import "SubCourseModel.h"
#import "CourseTableViewCell.h"
#import "GoodsSubCell.h"
#import "GoodDetailViewController.h"


@interface GoodsSubListViewModel ()
@property (nonatomic,strong)CourseListModel *courseListModel;
@property (nonatomic,strong,readwrite)RACCommand *courseCommand;

@property (nonatomic,strong)NSString *orderId;
@property (nonatomic,strong)NSString *selectId;


@property (nonatomic,strong)NSArray *datas;
@property (nonatomic,strong)UIViewController *selectOrderVCT;


@property (nonatomic,strong)UIView *subHeadView;

@property float sectionImgHeight;//专题section高度

@end

@implementation GoodsSubListViewModel



- (void)initialize
{
    [super initialize];
    self.orderId = @"";
    self.selectId = @"";
    self.sectionImgHeight = ScreenWidth * (35.0/75.0);
    
    
    @weakify(self)
    RAC(self,courseListModel) = [self.requestRemoteDataCommand.executionSignals.switchToLatest map:^id(id value) {
        NSLog(@"======== %@",value);
        return value;
    }];
    
    [[RACObserve(self, categoryId) filter:^BOOL(NSString* value) {
        return (value.length && value.length>0);
    }] subscribeNext:^(id x) {
        @strongify(self);
        [self first];
    }];
    self.courseCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(CourseModel *model) {
        @strongify(self)
//        NSString *url = [NSString stringWithFormat:@"%@?courseId=%@",URL_GoodsDetail,model.course_id];
//        [self.viewController pushViewControllerWithUrl:url];
        return [RACSignal empty];
    }];

    
    [[[RACObserve(self, courseListModel) filter:^BOOL(CourseListModel* courseListModel) {
        return  (courseListModel !=nil);
    }] deliverOnMainThread] subscribeNext:^(CourseListModel* courseListModel) {
        @strongify(self)
        
        if(self.categoryId && [self.categoryId isEqualToString:@"-1"]){
            self.isCategory = YES;
        }
        
        if (!self.isCategory) {
            NSArray *list = courseListModel.course_list;

            if (self.curPage.intValue<=1) {
                self.dataSource = @[list];
                [self.mTableView reloadData];
            }else{
                
                NSMutableArray* tempDataSource = [NSMutableArray arrayWithArray:self.dataSource[0]];
                [tempDataSource addObjectsFromArray:list];
                self.dataSource = @[tempDataSource];
                [self.mTableView reloadData];
            }
        }else {
            NSArray *list = courseListModel.subject_list;
            NSMutableArray *courseArray = [[NSMutableArray alloc] initWithCapacity:list.count];
            int i = 0;
            for(SubCourseModel* sub in list){
                
                courseArray[i] = [[NSMutableArray alloc] initWithCapacity:1];
                courseArray[i][0] = sub.course_list;
                
                i++;
            }
            
            
            if (self.curPage.intValue<=1) {
                self.dataSource = courseArray;
                self.datas = list;
                [self.mTableView reloadData];
            }else{
                
                NSMutableArray* tempDataSource = [NSMutableArray arrayWithArray:self.dataSource];
                [tempDataSource addObjectsFromArray:courseArray];
                self.dataSource = tempDataSource;
                
                NSMutableArray* subArray = [NSMutableArray arrayWithArray:self.datas];
                [tempDataSource addObjectsFromArray:list];
                self.datas = subArray;
                [self.mTableView reloadData];
            }
        }
       
    }];
}

- (void)bindTableView:(UITableView *)tableView
{
    [super bindTableView:tableView];
    
    
    
    [tableView registerCellWithReuseIdentifier:@"GoodsSubCell"];
    [tableView registerCellWithReuseIdentifier:@"CourseTableViewCell"];
    
    self.shouldMoreToRefresh = YES;
    self.shouldPullToRefresh = YES;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.isCategory){
        NSArray *array =self.dataSource[section][0];
        if(array && array.count > 0){
            return 1;
        }else{
            return 0;
        }
    }else{
        NSArray *array = self.dataSource[section];
        return array.count;
    }
    
}
- (NSString*)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath
{
    if(self.isCategory){
        return @"GoodsSubCell";
    }else{
        return @"CourseTableViewCell";
    }
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    if(self.isCategory){
        GoodsSubCell *mcell=(GoodsSubCell *)cell;
        mcell.courseCommand = self.courseCommand;
        [mcell setDataItems:object];
    }else{
        CourseTableViewCell *mcell = (CourseTableViewCell*)cell;
        mcell.model = object;
    }


}

- (RACSignal*)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    RACSignal *fetchSignal = [self.httpService getCategoryList:self.categoryId order_type:self.orderId select_type:self.selectId page:[NSString stringWithFormat:@"%lu",(unsigned long)page] page_size:self.pageSize.stringValue resultClass:[CourseListModel class] ];
    //    return fetchSignal;
    @weakify(self)
    return [[[fetchSignal collect] doNext:^(NSArray *responses) {
        @strongify(self)
        if(self.mTableView.mj_footer.isRefreshing ){
            [self.mTableView.mj_footer endRefreshing];
        }
        if (self.mTableView.mj_header.isRefreshing) {
            [self.mTableView.mj_header endRefreshing];
        }
        
    }] map:^id(NSArray *responses) {
        BaseModel *model = responses.firstObject;
        CourseListModel *datas = model.data;
//        SubCourseModel *subCourse = datas.subject_list[0];
        
        return datas;
    }];
    
}

- (void)gotoSelectOrder{
    
    if (self.selectOrderVCT == nil) {
        NSString *vctUrl = [NSString stringWithFormat:@"%@",URL_GoodsSelectOrder];
        self.selectOrderVCT = [self.viewController.urlManager viewControllerWithUrl:vctUrl];
    }
    
    if (self.selectOrderVCT) {
        
        if (self.selectOrderVCT.maskView) {
            [self.selectOrderVCT dismissPopControllerWithMaskAnimated:YES];
        }else{
            self.selectOrderVCT.title = @"请选择筛选或排序条件";
            self.selectOrderVCT.toolsView.hidden = YES;
            self.selectOrderVCT.params = @{@"orderId":self.orderId,@"selectId":self.selectId};
            
            [self.viewController popViewControllerWithMask:self.selectOrderVCT animated:YES setEdgeInsets:UIEdgeInsetsMake(0, 0, 250, 0)];
            @weakify(self);
            [self.selectOrderVCT setCallbackBlock:^(id callBackData) {
                @strongify(self);
                NSLog(@"%@",callBackData);
                if([callBackData isKindOfClass:[SelectTypeModel class]]){
                    SelectTypeModel* type = callBackData;
                    self.selectId = type.item_id;
                    
                }else if([callBackData isKindOfClass:[OrderTypeModel class]]){
                    OrderTypeModel* type = callBackData;
                    self.orderId = type.item_id;
                }
                [self first];
                
                if(self.shuaiXuanBtn){
                    if([_orderId intValue] || [_selectId intValue] ){
                        [self.shuaiXuanBtn setImage:[UIImage imageNamed:@"selectOrder-yes"] forState:UIControlStateNormal];
                    }else{
                        [self.shuaiXuanBtn setImage:[UIImage imageNamed:@"selectOrder"] forState:UIControlStateNormal];
                    }
                }
                self.viewController.params = @{@"orderId":self.orderId,@"selectId":self.selectId};
                
            }];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.datas) {
        return _sectionImgHeight ;
    }else{
        return 0.1f;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(self.datas){
        SubCourseModel *subCourse = self.datas[section];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _sectionImgHeight)];
        
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _sectionImgHeight)];
        [imgView setContentMode:UIViewContentModeScaleAspectFill ];//不变形且撑满
        [imgView setClipsToBounds:YES];//超出部分将被裁剪
        [imgView setImageWithURLString:subCourse.cover placeholderImage:[UIImage imageNamed:@"jiazanshibaitu"]];
        [imgView setTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
           [self.viewController pushViewControllerWithUrl:subCourse.pfurl ];
        }];
        
        UIImageView *triangleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2-11, _sectionImgHeight-12, 23 , 12)];
        [triangleImgView setImage:[UIImage imageNamed:@"sanjiaoxing"]];
        
        
        [view addSubview:imgView];
        [view insertSubview:triangleImgView aboveSubview:imgView];
        
        
        return view;
    }else{
        return [UIView new];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseRootViewControllerNotification" object:scrollView];
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
    GoodDetailViewController *myView = [story instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
    if(self.dataSource[indexPath.section] && self.dataSource[indexPath.section][indexPath.row] ){
        CourseModel *mode = self.dataSource[indexPath.section][indexPath.row];
        if([mode isKindOfClass:[CourseModel class]]){
//            myView.params = @{@"courseId":mode.course_id,@"coverStr":mode.cover} ;
            [self.viewController.navigationController pushViewController:myView animated:YES];
        }
    }
    
    
//    NSString *url = [NSString stringWithFormat:@"%@?courseId=%@",URL_GoodsDetail,self.shareDetailModel.course[@"course_id"]];
//    [self.viewController pushViewControllerWithUrl:url];
    
}

@end
