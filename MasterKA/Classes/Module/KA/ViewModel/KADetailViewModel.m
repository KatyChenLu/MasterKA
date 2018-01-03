//
//  KADetailViewModel.m
//  MasterKA
//
//  Created by ChenLu on 2017/10/12.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KADetailViewModel.h"
#import "KADetailTableViewCell.h"
#import "GoodDetailModel.h"

#import "CouseDetailCell.h"

//#import "NameAndMoneyCell.h"


#import "AskQuestionViewController.h"
#import "KADetailViewController.h"

#import "KATitleTableViewCell.h"
#import "KADetailTableViewCell.h"
#import "KADingzhiTableViewCell.h"
#import "KAImageTableViewCell.h"

@interface KADetailViewModel()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate>
@property (nonatomic,strong,readwrite)RACCommand *courseCommand;
@property (nonatomic,strong,readwrite)RACCommand *gotoDetail;


@property(nonatomic,strong) UIWebView *detailWebView;
@property(nonatomic,assign) float detailWebViewHeight;
@property(nonatomic,assign) BOOL detailWebViewLoaded;


@end


@implementation KADetailViewModel
{
    NSString * tag;
    BOOL isfromordernary;
    
}
- (void)initialize
{
    [super initialize];
    @weakify(self)
    //相关推荐
    self.fresh=YES;
    self.courseCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *model) {
        @strongify(self)
        self.ka_course_id=model[@"ka_course_id"];
        [self first];
        return [RACSignal empty];
    }];
    //购买
    self.engagements = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *yueIt) {
        @strongify(self);
        
        tag = [NSString stringWithFormat:@"%ld",yueIt.tag];
        
        if([self.info[@"is_group"]isEqual: @"1"]){
            if(![self.info[@"course_cfg"] isEqual:@[]]){
                [self gotoSelectView:0];
            }else{
                [self pushtoCourseDateViewController:nil];
            }
            
        }else{
            
            [self pushtoCourseDateViewController:nil];
        }
        
        return [RACSignal empty];
    }];
    
    //也想学
    self.gotoDetail = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSDictionary *model) {
        @strongify(self)
        [self goToStudentDetail:model];
        return [RACSignal empty];
    }];
    
}

- (UIWebView*)detailWebView
{
    if (!_detailWebView) {
        _detailWebView = [[UIWebView alloc] init];
        _detailWebView.frame = CGRectMake(0, 0, ScreenWidth, 0);
        _detailWebView.scrollView.scrollEnabled = NO;
        _detailWebView.delegate = self;
    }
    return _detailWebView;
}

- (void)setDetailWevViewUrlString:(NSString*)webUrlString{
    self.detailWebViewHeight = ScreenHeight-100;
    self.detailWebViewLoaded = FALSE;
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webUrlString]];
    [requestObj addMasterHeadInfo];
    [self.detailWebView loadRequest:requestObj];
    self.detailWebView.delegate = self;
}

- (void)bindTableView:(UITableView *)tableView
{
    [super bindTableView:tableView];
    self.cellReuseIdentifier = @"CouseDetailCell";
    [self.mTableView registerCellWithReuseIdentifier:@"KADetailTableViewCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"KATitleTableViewCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"KAImageTableViewCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"KADingzhiTableViewCell"];
    
}
- (NSString*)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath
{
    
    if([[_detailSection objectAtIndex:indexPath.section]isEqual:@"标题"]){//标题
        return @"KATitleTableViewCell";
    }else if([[_detailSection objectAtIndex:indexPath.section]isEqual:@"课程介绍"]||[[_detailSection objectAtIndex:indexPath.section]isEqual:@"产品内容"]||[[_detailSection objectAtIndex:indexPath.section]isEqual:@"活动内容"]) {
        return @"KADetailTableViewCell";
    }else if([[_detailSection objectAtIndex:indexPath.section]isEqual:@"图片列表"]){
        return @"KAImageTableViewCell";
    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"定制流程"]) {
        return @"KADingzhiTableViewCell";
    }
    else{
        return nil;
    }
    
}

- (RACSignal*)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    RACSignal *fetchSignal = [self.httpService kaCourseDetail:self.ka_course_id resultClass:nil];
    @weakify(self);
    return [[[fetchSignal collect] doNext:^(NSArray *pageSize) {
        @strongify(self);
        if(self.mTableView.mj_footer.isRefreshing ){
            [self.mTableView.mj_footer endRefreshing];
        }
        if (self.mTableView.mj_header.isRefreshing) {
            [self.mTableView.mj_header endRefreshing];
        }
        
    }] map:^id(NSArray *responses) {
        BaseModel *model = responses.firstObject;
        @strongify(self);
        if (model.code==200) {
            
            self.info = model.data;
            
            NSMutableArray*data =[NSMutableArray array];
            self.detailSection=[NSMutableArray array];
            
            [data addObject:[self getTitleView:self.info]];
            [data addObject:[self getDesc:self.info[@"cousre_desc"]]];
            [data addObject:[self getDescImgList:self.info[@"cousre_desc_img_lists"]]];
            [data addObject:[self getContent:self.info[@"course_content"]]];
            if (![self.info[@"course_product"] isEqualToString:@""]) {
                 [data addObject:[self getProduct:self.info[@"course_product"]]];
            }
            [data addObject:[self getflowImg]];
            
            self.dataSource=data;
            
            [self.mTableView reloadData];
            
        }
        return self.dataSource;
    }];
    
}
- (NSArray *)getflowImg {
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    [contentDic setObject:@"定制流程" forKey:@"flowImg"];
    [self.detailSection addObject:@"定制流程"];
    return @[contentDic];
}
- (NSArray *)getDescImgList:(NSArray *)cousre_desc_img_lists {
    
    [self.detailSection addObject:@"图片列表"];
    return cousre_desc_img_lists;
}


- (NSArray *)getContent:(NSString *)course_content {
    
    NSMutableDictionary *contentDic = [NSMutableDictionary dictionary];
    [contentDic setObject:course_content forKey:@"course_content"];
    [contentDic setObject:@"course_content" forKey:@"type"];
    [self.detailSection addObject:@"活动内容"];
    return @[contentDic];
}
- (NSArray *)getProduct:(NSString *)course_product {
     NSMutableDictionary *producttDic = [NSMutableDictionary dictionary];
    if (course_product.length) {
       
        [producttDic setObject:course_product forKey:@"course_product"];
        [producttDic setObject:@"course_product" forKey:@"type"];
        [self.detailSection addObject:@"产品内容"];
        
    }
    return @[producttDic];
   
}

- (NSArray *)getDesc:(NSString *)cousre_desc {
    
    NSMutableDictionary *descDic = [NSMutableDictionary dictionary];
    [descDic setObject:cousre_desc forKey:@"cousre_desc"];
    [descDic setObject:@"cousre_desc" forKey:@"type"];
    [self.detailSection addObject:@"课程介绍"];
    return @[descDic];
}

- (NSArray *)getTitleView:(NSDictionary *)info{//标题View
    
    NSMutableDictionary *titleViewDic=[NSMutableDictionary dictionary];
    [titleViewDic setObject:info[@"course_title"] forKey:@"course_title"];
    [titleViewDic setObject:info[@"course_sub_title"] forKey:@"course_sub_title"];
    [titleViewDic setObject:info[@"course_time"] forKey:@"course_time"];
    [titleViewDic setObject:info[@"people_num"] forKey:@"people_num"];
    [titleViewDic setObject:info[@"course_price"] forKey:@"course_price"];
    [titleViewDic setObject:info[@"is_vote_cart"] forKey:@"is_vote_cart"];
    [titleViewDic setObject:info[@"ka_course_id"] forKey:@"ka_course_id"];
    [self.detailSection addObject:@"标题"];
    
    return @[titleViewDic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    CGFloat height = [tableView fd_heightForCellWithIdentifier:[self getReuseIdentifierWithIndexPath:indexPath] configuration:^(id cell) {
        @strongify(self);
        id object = self.dataSource[indexPath.section][indexPath.row];
        [self configureCell:cell atIndexPath:indexPath withObject:(id)object];
    }];
    return height;
}
- (void)configureCell:(CouseDetailCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"标题"]) {
        KATitleTableViewCell *_cell=(KATitleTableViewCell *)cell;
        [_cell showTitleCell:object];
        @weakify(self);
        [_cell setJoinClick:^(NSString *ka_course_id) {
            @strongify(self);
            [self.viewController addVoteActionWithJoinImgView:nil KaCourseId:ka_course_id Animation:NO];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"addVote" object:@{@"ka_course_id":ka_course_id}];
        }];
        [_cell setCanceljoinClick:^(NSString *ka_course_id) {
            @strongify(self);
            [self.viewController deleteVoteActionWithKaCourseId:ka_course_id];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelVote" object:@{@"ka_course_id":ka_course_id,@"isDetail2Vote":@"1"}];
        }];
        
    }else if([[_detailSection objectAtIndex:indexPath.section]isEqual:@"课程介绍"]||[[_detailSection objectAtIndex:indexPath.section]isEqual:@"产品内容"]||[[_detailSection objectAtIndex:indexPath.section]isEqual:@"活动内容"]){
        KADetailTableViewCell *detailCell = (KADetailTableViewCell *)cell;
        [detailCell showDetail:object];
    }else if([[_detailSection objectAtIndex:indexPath.section]isEqual:@"定制流程"]) {
        KADingzhiTableViewCell *detailCell = (KADingzhiTableViewCell *)cell;
        [detailCell showDingzhiDetail:object];
    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"图片列表"]) {
        KAImageTableViewCell *detailCell = (KAImageTableViewCell *)cell;
        [detailCell showContentImg:object];
    }
    
    
}
#pragma mark -- tableViewDataSource;

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
}
- (void)gotoSelectView :(NSIndexPath *)index{//选择套餐或者上课地址
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
    UIViewController *vct = [story instantiateViewControllerWithIdentifier:@"SelectDetailController"];
    if(index.row==0){
        vct.title = @"选择套餐";
        if(tag==nil){
            tag = @"1";
        }
        vct.params = @{@"info":self.info,@"identifier":@"course_cfg",@"grouptag":tag};
    }else{
        vct.title = @"选择地址";
        vct.params = @{@"info":self.info,@"identifier":@"store"};
    }
    if (vct) {
        
        [self.viewController popViewControllerWithMask:vct animated:YES setEdgeInsets:UIEdgeInsetsMake(ScreenHeight/2, 0, 0, 0)];
        @weakify(self);
        [vct setCallbackBlock:^(NSDictionary *callBackData) {
            @strongify(self);
            NSLog(@"%@",callBackData);
            if(callBackData[@"ka_course_id"]){
                self.ka_course_id=callBackData[@"ka_course_id"];
                //                [self.mTableView reloadData];
            }else{
                [self pushtoCourseDateViewController:callBackData];
            }
            [self first];
        }];
    }
    
}
#pragma mark -- webViewDelegate;
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if (self.detailWebViewLoaded==FALSE) {
        self.detailWebViewLoaded = YES;
        //        float webViewHeight = [[webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] floatValue];
        //        self.detailWebViewHeight = webViewHeight;
        //        self.detailWebView.height = webViewHeight;
        //        [self.mTableView reloadData];
    }
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    if(self.detailWebViewLoaded && ![request.URL.absoluteString isEqualToString:self.info[@"detail_link"]]){
        [self.viewController pushViewControllerWithUrl:request.URL.absoluteString];
        return NO;
    }
    NSLog(@"==shouldStartLoadWithRequest==== %@",request);
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.mTableView)
    {
        
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY > 0) {
            CGFloat alpha = 1 - ((64 - offsetY) / 64);
            if (alpha>1.0f) {
                alpha =1.0f;
            }
            self.alphaNavigationBar = alpha;
        } else {
            self.alphaNavigationBar = 0.0f;
            
            KADetailViewController * view=(BaseViewController*)self.viewController;
            CGRect rect = view.mineHeadView.frame;
            rect.origin.y =offsetY;
            rect.size.width = ScreenWidth-offsetY;
            rect.size.height = ScreenWidth/375*234 -offsetY;
            rect.origin.x =offsetY/2;
            view.mineHeadView.frame = rect;
        }
        
        //        CGFloat sectionHeaderHeight = 57;
        //        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        //            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        //        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        //            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        //        }
        //        CGFloat offsetY = scrollView.contentOffset.y;
        //        if (offsetY< 0) {
        //            GoodDetailViewController * view=(GoodDetailViewController*)self.viewController;
        //            CGRect frame = view.mineHeadView.frame;
        //            frame.origin.y = offsetY;
        //            frame.origin.x = offsetY/2;
        //            frame.size.width = ScreenWidth-offsetY;
        //            frame.size.height = RatioBase6(326) - offsetY;
        //            view.mineHeadView.frame = frame;
        //        }else{
        //            UIColor * color = MasterDefaultColor;
        //            CGFloat offsetY = scrollView.contentOffset.y;
        //            if (offsetY > NAVBAR_CHANGE_POINT) {
        //                CGFloat alpha = MIN(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64));
        //                [self.viewController.navigationController.navigationBar setBackgroundImageColor:[color colorWithAlphaComponent:alpha]];
        //            } else {
        //                [self.viewController.navigationController.navigationBar setBackgroundImageColor:[color colorWithAlphaComponent:0]];
        //            }
        //
        //        }
        //
    }
    
}
- (void)goToStudentDetail:(NSDictionary *)info{//课程粉丝列表
    NSString *url = [NSString stringWithFormat:@"%@?uid=%@",URL_MasterCenter,info[@"uid"]];
    [self.viewController pushViewControllerWithUrl:url];
}
-(NSString *)setDiscountText:(NSArray *)array{//优惠券信息
    NSString *str=@"";
    for (NSString *discount in array) {
        if(array.count >1){
            str=[str stringByAppendingString:[NSString stringWithFormat:@"%@、",discount]];
            //            str=[str substringToIndex:str.length-1];
        }else{
            str=discount;
        }
    }
    if(array.count >1){
        return [str substringToIndex:str.length-1];
    }
    return str;
}
-(void)pushtoCourseDateViewController:(NSDictionary *)dic{//进入日历或者直接付款
    if (![self.viewController doLogin]) {
        return ;
    }
    UIViewController* vct;
    if(dic){
        vct = [UIViewController viewControllerWithName:@"CourseDateViewController"];
        NSString * gourpId = dic[@"course_cfg_id"];
        //tag = @"1";
        if(isfromordernary == YES){
            vct.params =@{@"courseId":self.ka_course_id,@"gourpId":gourpId,@"info":self.info};}
        else{
            vct.params =@{@"courseId":self.ka_course_id,@"gourpId":gourpId,@"info":self.info,@"tag":tag};
        }
        isfromordernary = NO;
    }else{
        vct = [UIViewController viewControllerWithName:@"CoursePayViewController"];
        vct.params =@{@"courseId":self.ka_course_id ,@"info":self.info,@"tag":tag};
        
    }
    [self.viewController pushViewController:vct animated:YES];
}
-(void)pushtoUserOrMasterViewController:(NSDictionary *)dic{//进入分享详情
    if([[dic objectForKey:@"master"] isEqual:@"master"]){
        NSString * url = [NSString stringWithFormat:@"%@?shareId=%@",URL_MasterShareDetail,dic[@"share_id"]];
        [self.viewController pushViewControllerWithUrl:url];
        
    }else{
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserShare" bundle:[NSBundle mainBundle]];
        UIViewController* vct= [story instantiateViewControllerWithIdentifier:@"UserShareDetailViewController"];
        vct.params =@{@"shareId":dic[@"share_id"]};
        [self.viewController pushViewController:vct animated:YES];
    }
    
}
-(BOOL)haveShare: (NSIndexPath*)indexPath{
    if([[_detailSection objectAtIndex:indexPath.section] rangeOfString:@"玩家评论"].location != NSNotFound){
        return YES;
    }
    return NO;
}
-(void)showShare{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
    UIViewController* vct= [story instantiateViewControllerWithIdentifier:@"MyShareViewController"];
    vct.params =@{@"course_id":self.ka_course_id,@"title":@"课程分享"};
    [self.viewController pushViewController:vct animated:YES];
    
}
-(void) phoneMaster{//电话
    [self.viewController showPhonesActionSheet:self.info[@"course_mobile"]];
}
-(void)questionToMaster{//私信
    NSString * url = [NSString stringWithFormat:@"%@?userId=%@",URL_IMChating,self.info[@"uid"]];
    [self.viewController pushViewControllerWithUrl:url];
    
}

@end
