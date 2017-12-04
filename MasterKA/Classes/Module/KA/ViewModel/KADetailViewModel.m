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
        self.course_id=model[@"course_id"];
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
//    [self.mTableView registerCellWithReuseIdentifier:@"UserShareListCell"];
//    [self.mTableView registerCellWithReuseIdentifier:@"MasterShareTableViewCell"];
//    [self.mTableView registerCellWithReuseIdentifier:@"CourseTableViewCell"];
//    [self.mTableView registerCellWithReuseIdentifier:@"GuessLikeCell"];
//    [self.mTableView registerCellWithReuseIdentifier:@"TimeAndStoreCell"];
//    [self.mTableView registerCellWithReuseIdentifier:@"LeaderDetailCell"];
//    [self.mTableView registerCellWithReuseIdentifier:@"StudentCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"KATitleTableViewCell"];
    
}
- (NSString*)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath
{
    
//    return @"KADetailTableViewCell";
//    if([self haveShare:indexPath]){
//        NSLog(@"%@",[[[self.dataSource objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"master"]);
//        if ([[[[self.dataSource objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"master"] isEqual:@"user"]) {
//            return  @"UserShareListCell";
//        }else{
//            return @"MasterShareTableViewCell";
//        }
//    }
//    else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"进阶课程"]){
//        return @"CourseTableViewCell";
//    }
////    else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"相关推荐"]){
////        return @"GuessLikeCell";
////    }
//    else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"时间地点"]){
//        return @"TimeAndStoreCell";
//
//    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"秒杀价格"]){
//        return @"SeckillTableViewCell";
//    }
//
//    else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"详细"]){
//        return @"LeaderDetailCell";
//    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"课程流程"]){
//        return @"CourseProgressCell";
//    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"他们也喜欢"]){
//        return @"StudentCell";
//    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"套餐"]){
//        return @"CoursePackageCell";
//    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqualToString:@"问大家"]){
//        return @"AskQuestionsCell";
//    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqualToString:@"提问题"]){
//        return @"NoneQuestionCell";
//    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"masters"]){
//        return @"MasterMsgCell";
//    }else
    if([[_detailSection objectAtIndex:indexPath.section]isEqual:@"标题"]){//标题、金额和酱油卡
        return @"KATitleTableViewCell";
    }
        else{
        return @"KADetailTableViewCell";
    }
    
}
- (RACSignal*)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    RACSignal *fetchSignal = [self.httpService getCourseDetail:@"4747" resultClass:nil];
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
            
            NSDictionary *dic = model.data;
            
            NSMutableArray*data =[NSMutableArray array];
              self.detailSection=[NSMutableArray array];
            
            [data addObject:[self getNameAndMoney:self.info]];
          
            [data addObjectsFromArray:[self getDetail:self.info]];
            
            self.dataSource=data;
            
            [self.mTableView reloadData];

        }
        return self.dataSource;
    }];
    
}

- (NSMutableArray *)getDetail:(NSDictionary *)info {
    NSMutableArray *detailArr = [NSMutableArray array];
    NSArray *arr = info[@"guess_like"];
    
    for (NSDictionary * dic in arr) {
        [detailArr addObject:@[dic]];
        [self.detailSection addObject:@"内容"];
    }
    return detailArr;
}

- (NSMutableArray *)getNameAndMoney:(NSDictionary *)info{//商品名和金额
    NSMutableArray *nameAndMoney=[NSMutableArray array];//名称金额
    NSMutableDictionary *name_money=[NSMutableDictionary dictionary];
    [name_money setObject:info[@"title"] forKey:@"title"];
      [self.detailSection addObject:@"标题"];
    [nameAndMoney addObject:name_money];
    return nameAndMoney;
}


- (void)configureCell:(CouseDetailCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object
{
    
    if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"标题"]) {
        KATitleTableViewCell *_cell=(KATitleTableViewCell *)cell;
        [_cell showTitleCell:object];
        
    }else{
        KADetailTableViewCell *detailCell = (KADetailTableViewCell *)cell;
        [detailCell showDetail:object];
    }
    
    
}
#pragma mark -- tableViewDataSource;

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIColor *back= [UIColor colorWithRed:235/255.f green:235/255.f  blue:235/255.f  alpha:1.0f];;
//    UIView *backGround=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
//    backGround.backgroundColor=back;
//    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 47)];;
//    [backGround addSubview:sectionView];
//    sectionView.backgroundColor =[UIColor whiteColor];
//    
//    UIButton *Idlabel =[UIButton buttonWithType:UIButtonTypeCustom];
//    Idlabel.frame=CGRectMake(0, 0, ScreenWidth, 46);
//    [Idlabel.titleLabel setFont: [UIFont systemFontOfSize:15]];
//    Idlabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [Idlabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [Idlabel setTitle:[NSString stringWithFormat:@"    %@" ,[self.detailSection objectAtIndex:section]] forState:UIControlStateNormal];
//    [sectionView addSubview:Idlabel];
//    UIImageView *jiantou =[[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-26, 16, 15, 15)];
//    jiantou.image=[UIImage imageNamed:@"gerenqianming-jiantou"];
//    jiantou.contentMode=UIViewContentModeScaleAspectFit;
//    [sectionView addSubview:jiantou];
//    sectionView.hidden=YES;
//    if(![[self.detailSection objectAtIndex:section]  isEqual:@""]&&![[self.detailSection objectAtIndex:section]  isEqual:@"时间地点"]&&![[self.detailSection objectAtIndex:section]  isEqual:@"秒杀价格"]&&![[self.detailSection objectAtIndex:section]  isEqual:@"详细"]&&![[self.detailSection objectAtIndex:section]isEqual:@"他们也想学"]&&![[self.detailSection objectAtIndex:section]isEqual:@"课程流程"]&&![[self.detailSection objectAtIndex:section]isEqual:@"masters"]){
//        backGround.height=57;
//        sectionView.hidden=NO;
//        sectionView.height=46;
//        if([[_detailSection objectAtIndex:section] rangeOfString:@"玩家评论"].location != NSNotFound){
//            [Idlabel addTarget:self action:@selector(showShare)forControlEvents:UIControlEventTouchUpInside];
//        }
//        if([[_detailSection objectAtIndex:section] isEqual:@"套餐"]&&[[_detailSection objectAtIndex:section] isEqual:@"问大家"]&&[[_detailSection objectAtIndex:section] isEqual:@"提问题"]){
//            jiantou.hidden=YES;
//        }
//        
//        if([[_detailSection objectAtIndex:section] isEqual:@"进阶课程"]){
//            jiantou.hidden=YES;
//            CGRect frame=sectionView.frame;
//            frame.origin.y=0;
//            frame.size.height=sectionView.height+10;
//            sectionView.frame=frame;
//            //            backGround.backgroundColor=[UIColor whiteColor];
//        }
//        if([[_detailSection objectAtIndex:section] isEqual:@"相关推荐"]){
//            jiantou.hidden=YES;
//            sectionView.backgroundColor=[UIColor whiteColor];
//            Idlabel.backgroundColor=[UIColor whiteColor];
//        }
//        
//    }
//    return backGround;
//}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if([[self.detailSection objectAtIndex:section]  isEqual:@""]||[[self.detailSection objectAtIndex:section]  isEqual:@"详细"]||[[self.detailSection objectAtIndex:section]  isEqual:@"他们也想学"]||[[self.detailSection objectAtIndex:section]isEqual:@"课程流程"]){
//        return 10;
//    }
//    if([[self.detailSection objectAtIndex:section]  isEqual:@"时间地点"] ||[[self.detailSection objectAtIndex:section]  isEqual:@"秒杀价格"]){
//        return 0.5;
//    }
//    if(section==0){
//        return 0;
//    }
//    if ([[self.detailSection objectAtIndex:section]  isEqual:@"masters"]) {
//        return 10;
//    }
//    
//    return 57;
//}
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
            if(callBackData[@"course_id"]){
                self.course_id=callBackData[@"course_id"];
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
            rect.size.height = ScreenWidth - offsetY;
            rect.size.width = ScreenWidth-offsetY;
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
            vct.params =@{@"courseId":self.course_id,@"gourpId":gourpId,@"info":self.info};}
        else{
            vct.params =@{@"courseId":self.course_id,@"gourpId":gourpId,@"info":self.info,@"tag":tag};
        }
        isfromordernary = NO;
    }else{
        vct = [UIViewController viewControllerWithName:@"CoursePayViewController"];
        vct.params =@{@"courseId":self.course_id ,@"info":self.info,@"tag":tag};
        
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
    vct.params =@{@"course_id":self.course_id,@"title":@"课程分享"};
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
