//
//  GoodDetailModel.m
//  MasterKA
//
//  Created by hyu on 16/5/13.
//  Copyright © 2016年 jinghao. All rights reserved.
//
#import "GoodDetailViewController.h"
#import "GoodDetailModel.h"
#import "CouseDetailCell.h"
//#import "MasterShareTableViewCell.h"
//#import "UserShareListCell.h"
#import "CourseTableViewCell.h"
#import "GuessLikeCell.h"
#import "TimeAndStoreCell.h"
#import "LeaderDetailCell.h"
#import "MapViewController.h"
#import "StudentCell.h"
#import "QuestionView.h"
#import "NameAndMoneyCell.h"
#import "CoursePackageCell.h"
#import "CourseProgressCell.h"
#import "MasterMsgCell.h"
#import "SeckillTableViewCell.h"
#import "AskQuestionsCell.h"
#import "AskViewController.h"
#import "NoneQuestionCell.h"
#import "AskQuestionViewController.h"

#define NAVBAR_CHANGE_POINT 50
@interface GoodDetailModel()<UIWebViewDelegate>
@property (nonatomic,strong,readwrite)RACCommand *courseCommand;
@property (nonatomic,strong,readwrite)RACCommand *gotoDetail;
@property(nonatomic,strong) QuestionView *quest;
@property(nonatomic,strong) UIWebView *detailWebView;
@property(nonatomic,assign) float detailWebViewHeight;
@property(nonatomic,assign) BOOL detailWebViewLoaded;

@end
@implementation GoodDetailModel
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
    [self.mTableView registerCellWithReuseIdentifier:@"CouseDetailCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"UserShareListCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"MasterShareTableViewCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"CourseTableViewCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"GuessLikeCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"TimeAndStoreCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"LeaderDetailCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"StudentCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"NameAndMoneyCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"CoursePackageCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"AskQuestionsCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"NoneQuestionCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"SeckillTableViewCell"];
    [self.mTableView registerClass:[CourseProgressCell class] forCellReuseIdentifier:@"CourseProgressCell"];
    //    [self.mTableView registerClass:[LeaderDetailCell class] forCellReuseIdentifier:@"LeaderDetailCell"];
    
    [self.mTableView registerClass:[MasterMsgCell class] forCellReuseIdentifier:@"MasterMsgCell"];
}
- (NSString*)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath
{
    if([self haveShare:indexPath]){
        NSLog(@"%@",[[[self.dataSource objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"master"]);
        if ([[[[self.dataSource objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"master"] isEqual:@"user"]) {
            return  @"UserShareListCell";
        }else{
            return @"MasterShareTableViewCell";
        }
    }
    else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"进阶课程"]){
        return @"CourseTableViewCell";
    }
    else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"相关推荐"]){
        return @"GuessLikeCell";
    }
    else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"时间地点"]){
        return @"TimeAndStoreCell";
       
    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"秒杀价格"]){
         return @"SeckillTableViewCell";
    }
    
    else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"详细"]){
        return @"LeaderDetailCell";
    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"课程流程"]){
        return @"CourseProgressCell";
    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"他们也喜欢"]){
        return @"StudentCell";
    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"套餐"]){
        return @"CoursePackageCell";
    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqualToString:@"问大家"]){
        return @"AskQuestionsCell";
    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqualToString:@"提问题"]){
        return @"NoneQuestionCell";
    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"masters"]){
        return @"MasterMsgCell";
    }else if(indexPath.section ==0){//标题、金额和酱油卡
        return @"NameAndMoneyCell";
    }else{
        return self.cellReuseIdentifier;
    }
    
}
- (RACSignal*)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    RACSignal *fetchSignal = [self.httpService getCourseDetail:self.course_id resultClass:nil];
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
            
            NSLog(@"%ld" , [self.info[@"groupby_info"]allKeys].count);
            
            if ([self.info[@"groupby_info"]allKeys].count) {
                
                self.group_buy(self.info);
                
            }
            
            self.detailSection=[NSMutableArray array];
            NSMutableArray*data =[NSMutableArray array];
            NSMutableArray *cardAndCoupon=[NSMutableArray array];//优惠券
            NSMutableArray *course_cfg=[NSMutableArray array];//套餐
            //            NSMutableArray *students=[NSMutableArray array];//他们也想学
            NSMutableArray *askQuestion = [NSMutableArray array];//问大家
            NSMutableArray *share=[NSMutableArray array];//分享
            NSMutableArray *course_advance=[NSMutableArray array];//进阶课程
            NSMutableArray *detailArr=[NSMutableArray array];//课程内容
            NSMutableArray *guessLike=[NSMutableArray array];//相关推荐
            NSMutableArray *masterMsg= [NSMutableArray array];//达人信息
            NSMutableArray *progress= [NSMutableArray array];//课程流程
            [data addObject:[self getNameAndMoney:self.info]];
            [self.info[@"is_seckill"] isEqualToString:@"1"]?[data addObject:[self getseckillAndMonry:self.info]]:nil;
            [data addObject:[self getTimeAndStore:self.info]];
            if( [self.info[@"is_enterprise"] intValue]==0){
                if(![self.info[@"card"]  isEqual:@[]]||![self.info[@"coupon"]  isEqual:@[]]){
                    [self.detailSection addObject:@""];
                    if(![self.info[@"card"]  isEqual:@[]])[cardAndCoupon addObjectsFromArray:self.info[@"card"]];
                    if(![self.info[@"coupon"]  isEqual:@[]]){
                        [cardAndCoupon addObjectsFromArray:self.info[@"coupon"]];
                        //                        self.discount=[self setDiscountText:self.info[@"coupon"]];
                    }
                    [data addObject:cardAndCoupon];
                }
                if(![self.info[@"course_cfg"]  isEqual:@[]]){
                    [course_cfg addObjectsFromArray:self.info[@"course_cfg"]];
                    [self.detailSection addObject:@"套餐"];
                    [data addObject:course_cfg];
                    
                   
                }
            }
            if (![self.info[@"question"] isEqual:@{}]) {
                [askQuestion addObject:self.info[@"question"]];
                [self.detailSection addObject:@"问大家"];
                [data addObject:askQuestion];
            }else{
                [askQuestion addObject:self.info[@"question"]];
                [self.detailSection addObject:@"提问题"];
                [data addObject:askQuestion];
            }
            //            if(![self.info[@"student"]  isEqual:@[]]){
            //                [students addObject:self.info[@"student"]];
            //                [self.detailSection addObject:@"他们也想学"];
            //                [data addObject:students];
            //            }
            if (![self.info[@"course_process"] isEqual:@[]]) {
                
                [progress addObject:self.info[@"course_process"]];
                
                [self.detailSection addObject:@"课程流程"];
                [data addObject:progress];
            }
            
            
            NSMutableDictionary *detail=[NSMutableDictionary dictionary];
            
            [detail setObject:self.info[@"detail_link"] forKey:@"detail_link"];
            [detailArr addObject:detail];
            
            //加载web
            
            [self setDetailWevViewUrlString:self.info[@"detail_link"]];
            
            [data addObject:detailArr];
            [self.detailSection addObject:@"详细"];
            if(![self.info[@"course_advance"]  isEqual:@[]]){
                [course_advance addObjectsFromArray:self.info[@"course_advance"]];
                [self.detailSection addObject:@"进阶课程"];
                [data addObject:course_advance];
            }
            NSMutableDictionary * master = [NSMutableDictionary dictionary];
            [master setObject:self.info[@"img_top"] forKey:@"img_top"];
            [master setObject:self.info[@"nikename"] forKey:@"nikename"];
            [master setObject:self.info[@"intro"] forKey:@"intro"];
            [masterMsg addObject:master];
            [self.detailSection addObject:@"masters"];
            [data addObject:masterMsg];
            if(![self.info[@"share"][@"list"] isEqual:@[]]){
                [share addObjectsFromArray:self.info[@"share"][@"list"]];
                [self.detailSection addObject:[NSString stringWithFormat:@"玩家评论  (%@)",self.info[@"share"][@"share_count"]]];
                [data addObject:share];
            }
            if( [self.info[@"is_enterprise"] intValue]==0){
                if(![self.info[@"guess_like"]  isEqual:@[]]){
                    [guessLike addObject:self.info[@"guess_like"]];
                    [self.detailSection addObject:@"相关推荐"];
                    [data addObject:guessLike];
                }
            }
            
            self.dataSource=data;
            [self.mTableView reloadData];
            [self.mTableView setContentOffset:CGPointMake(0, 0) animated:YES];
        }else {
            //            [self.viewController hiddenHUDWithString:model.message error:NO];
            [self showRequestErrorMessage:model];
        }
        
        return self.dataSource;
    }];
    
}
-(NSMutableArray *)getNameAndMoney:(NSDictionary *)info{//商品名和金额
    NSMutableArray *nameAndMoney=[NSMutableArray array];//名称金额
    NSMutableDictionary *name_money=[NSMutableDictionary dictionary];
    [name_money setObject:info[@"title"] forKey:@"title"];
    [name_money setObject:info[@"m_price"] forKey:@"m_price"];
    if([info[@"is_enterprise"] intValue]==1){
        [name_money setObject:@"底部联系我们了解更多" forKey:@"price"];
    }else{
        [name_money setObject:info[@"price"] forKey:@"price"];
        [name_money setObject:info[@"is_mpay"] forKey:@"is_mpay"];
        if(![info[@"discount"]  isEqual:@[]]){
            NSString *discount=[self setDiscountText:info[@"discount"]];
            [name_money setObject:discount forKey:@"coupon"];
        }
    }
    [_detailSection addObject:@"名称价格"];
    [nameAndMoney addObject:name_money];
    return nameAndMoney;
}
- (NSMutableArray *)getseckillAndMonry:(NSDictionary *)info {
    
    NSMutableArray *seckillAndMoney = [NSMutableArray array];
    NSMutableDictionary *seckill_money = [NSMutableDictionary dictionary];
    
        [seckill_money setObject:info[@"seckill"][@"first_time"] forKey:@"time"];
        [seckill_money setObject:info[@"seckill"][@"sk_price"] forKey:@"price"];
        [seckill_money setObject:info[@"seckill"][@"status"] forKey:@"status"];
        [_detailSection addObject:@"秒杀价格"];
        [seckillAndMoney addObject:seckill_money];
    
    return seckillAndMoney;
}
-(NSMutableArray *)getTimeAndStore:(NSDictionary *)info{
    NSMutableArray *timeAndStore=[NSMutableArray array];//时间地点
    NSMutableDictionary *timeDic=[NSMutableDictionary dictionary];
    NSMutableDictionary *storeDic=[NSMutableDictionary dictionary];
    [timeDic setObject:info[@"time_period"] forKey:@"name"];
    [timeDic setObject:@"rili" forKey:@"img_name"];
    [storeDic setObject:info[@"address"] forKey:@"name"];
    [storeDic setObject:@"dizhi" forKey:@"img_name"];
    [timeAndStore addObject:timeDic];
    [timeAndStore addObject:storeDic];
    NSArray *course_store=info[@"course_store"];
    if(course_store.count>0){
        NSMutableDictionary *stores=[NSMutableDictionary dictionary];
        [stores setObject:[NSString stringWithFormat:@"其他%lu处开课地址",(unsigned long)course_store.count] forKey:@"name"];
        [stores setObject:@"" forKey:@"img_name"];
        [timeAndStore addObject:stores];
    }
    [_detailSection addObject:@"时间地点"];
    return timeAndStore;
}

- (void)configureCell:(CouseDetailCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{}
//{
//    if([self haveShare:indexPath]){//玩家评论
//        if ([[[[self.dataSource objectAtIndex:indexPath.section]objectAtIndex:indexPath.row] objectForKey:@"master"] isEqual:@"user"]) {
//            UserShareListCell *shareCell = (UserShareListCell*)cell;
//            [shareCell showMyShare:object WithIndex:nil];
//        }else{
//            MasterShareTableViewCell *shareCell = (MasterShareTableViewCell*)cell;
//            shareCell.contentLabel.text = object[@"content"];
//            shareCell.nikeNameLabel.text = object[@"nikename"];
//            shareCell.titleLabel.text = object[@"title"];
//            if (object [@"tag_name"] && ![object[@"tag_name"] isEmpty]) {
//                [shareCell.tagButton setTitle:object[@"tag_name"] forState:UIControlStateNormal];
//            }else{
//                shareCell.tagButton.hidden = YES;
//            }
//            [shareCell.likeButton setTitle:object[@"like_count"] forState:UIControlStateNormal];
//            [shareCell.browseButton setTitle:object[@"browse_count"] forState:UIControlStateNormal];
//
//            [shareCell.userHeadView setImageWithURLString:object[@"img_top"]];
//            [shareCell.coverView setImageWithURLString:object[@"cover"]];
//            //        [shareCell.tagButton addTarget:self action:@selector(tagButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//        }
//    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"进阶课程"]){
//        CourseTableViewCell *_cell=(CourseTableViewCell *)cell;
//        CourseModel *model =[[CourseModel alloc]init];
//        model.course_id=object[@"course_id"];
//        model.cover=object[@"cover"];
//        model.view_count=object[@"view_count"];
//        model.title=object[@"title"];
//        model.is_mpay=object[@"is_mpay"];//1是M点课程 0是现金课程
//        model.m_price=object[@"m_price"];
//        model.price=object[@"price"];
//        model.market_price=object[@"market_price"];
//        model.show_market_price=object[@"show_market_price"];
//        model.store=object[@"store"];
//        model.nikename=object[@"nikename"];
//        model.uid=object[@"uid"];
//        model.distance=object[@"distance"];
//        model.tags=object[@"tags"];
//        _cell.model = model;
//    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"相关推荐"]){
//        GuessLikeCell *_cell=(GuessLikeCell *)cell;
//        [_cell setDataItems:object];
//        _cell.courseCommand=self.courseCommand;
//    } else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"时间地点"]){
//        TimeAndStoreCell *_cell=(TimeAndStoreCell *)cell;
//        [_cell showTimeAndStore:object];
//
//    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"秒杀价格"]){
//         SeckillTableViewCell *_cell = (SeckillTableViewCell *)cell;
//        [_cell showSeckillDetail:object];
//        [_cell setSeckillEnd:^{
//             [self.mTableView reloadData];
//        }];
//    }
//
//    else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"详细"]){
//        LeaderDetailCell *_cell=(LeaderDetailCell *)cell;
//        [_cell.img_top setImageWithURLString:object[@"img_top"] placeholderImage:nil];
//        _cell.nikename.text=object[@"nikename"];
//        _cell.webUrlString =object[@"detail_link"];
//        _cell.webViewHeightLayout.constant = self.detailWebViewHeight;
//        if(_cell.webView!=self.detailWebView){
//            _cell.webView = self.detailWebView;
//        }
//
//        [_cell setMoreClick:^{
//
//            float webViewHeight = [[self.detailWebView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] floatValue];
//            self.detailWebViewHeight = webViewHeight;
//            self.detailWebView.height = webViewHeight;
//            [self.mTableView reloadData];
//
//            _cell.moreBtn.hidden = YES;
//            _cell.Shadow.hidden = YES;
//            _cell.xiaJiantou.hidden = YES;
//
//
//        }];
//
//    }
//    //    else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"他们也想学"]){
//    //        StudentCell *_cell=(StudentCell *)cell;
//    //        [_cell setDataItems:object];
//    //        _cell.goToDetail=self.gotoDetail;
//    //    }
//    else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"课程流程"]){
//        CourseProgressCell *_cell=(CourseProgressCell *)cell;
//        _cell.progress = object;
//        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"masters"]){
//        MasterMsgCell *_cell=(MasterMsgCell *)cell;
//        _cell.dic = object;
//
//        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
//
//        [_cell setMaster:^{
//
//            [self goToStudentDetail:self.info];
//        }];
//
//        //        [_cell.img_top setImageWithURLString:object[@"img_top"] placeholderImage:nil];
//        //        _cell.nikename.text=object[@"nikename"];
//
//    }else if (indexPath.section ==0){
//        NameAndMoneyCell *_cell=(NameAndMoneyCell *)cell;
//        [_cell showMoneyAndname:object];
//    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"套餐"]){
//        CoursePackageCell *_cell=(CoursePackageCell *)cell;
//        _cell.custom_spec_name.text=object[@"custom_spec_name"];
//        _cell.price.text=[NSString stringWithFormat:@"￥%@",object[@"price"]];
//
//    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"问大家"]){
//        AskQuestionsCell *_cell = (AskQuestionsCell *)cell;
//        [_cell showAskCell:object];
//
//        [_cell setMoreClick:^{
//            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
//            AskViewController *myView = [story instantiateViewControllerWithIdentifier:@"AskViewController"];
//            myView.params = @{@"title":self.info[@"title"],@"course_id":self.course_id};
//            [self.viewController pushViewController:myView animated:YES];
//        }];
//        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }else if([[_detailSection objectAtIndex:indexPath.section]isEqual:@"提问题"]){
//        NoneQuestionCell *_cell = (NoneQuestionCell *)cell;
//
//        [_cell setMoreClick:^{
//
//            if ([self.viewController doLogin]) {
//                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
//                AskQuestionViewController *askQuestionVC = [story instantiateViewControllerWithIdentifier:@"AskQuestionViewController"];
//                askQuestionVC.params = @{@"title":self.info[@"title"],@"course_id":self.course_id};
//                [self.viewController pushViewController:askQuestionVC animated:YES];
//
//            }
//        }];
//        _cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    }else{
//        [cell showCourseDetail:object];
//    }
//}
#pragma mark -- tableViewDataSource;

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIColor *back= [UIColor colorWithRed:235/255.f green:235/255.f  blue:235/255.f  alpha:1.0f];;
    UIView *backGround=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    backGround.backgroundColor=back;
    UIView *sectionView=[[UIView alloc]initWithFrame:CGRectMake(0, 10, ScreenWidth, 47)];;
    [backGround addSubview:sectionView];
    sectionView.backgroundColor =[UIColor whiteColor];
    
    UIButton *Idlabel =[UIButton buttonWithType:UIButtonTypeCustom];
    Idlabel.frame=CGRectMake(0, 0, ScreenWidth, 46);
    [Idlabel.titleLabel setFont: [UIFont systemFontOfSize:15]];
    Idlabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [Idlabel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [Idlabel setTitle:[NSString stringWithFormat:@"    %@" ,[self.detailSection objectAtIndex:section]] forState:UIControlStateNormal];
    [sectionView addSubview:Idlabel];
    UIImageView *jiantou =[[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-26, 16, 15, 15)];
    jiantou.image=[UIImage imageNamed:@"gerenqianming-jiantou"];
    jiantou.contentMode=UIViewContentModeScaleAspectFit;
    [sectionView addSubview:jiantou];
    sectionView.hidden=YES;
    if(![[self.detailSection objectAtIndex:section]  isEqual:@""]&&![[self.detailSection objectAtIndex:section]  isEqual:@"时间地点"]&&![[self.detailSection objectAtIndex:section]  isEqual:@"秒杀价格"]&&![[self.detailSection objectAtIndex:section]  isEqual:@"详细"]&&![[self.detailSection objectAtIndex:section]isEqual:@"他们也想学"]&&![[self.detailSection objectAtIndex:section]isEqual:@"课程流程"]&&![[self.detailSection objectAtIndex:section]isEqual:@"masters"]){
        backGround.height=57;
        sectionView.hidden=NO;
        sectionView.height=46;
        if([[_detailSection objectAtIndex:section] rangeOfString:@"玩家评论"].location != NSNotFound){
            [Idlabel addTarget:self action:@selector(showShare)forControlEvents:UIControlEventTouchUpInside];
        }
        if([[_detailSection objectAtIndex:section] isEqual:@"套餐"]&&[[_detailSection objectAtIndex:section] isEqual:@"问大家"]&&[[_detailSection objectAtIndex:section] isEqual:@"提问题"]){
            jiantou.hidden=YES;
        }
        
        if([[_detailSection objectAtIndex:section] isEqual:@"进阶课程"]){
            jiantou.hidden=YES;
            CGRect frame=sectionView.frame;
            frame.origin.y=0;
            frame.size.height=sectionView.height+10;
            sectionView.frame=frame;
            //            backGround.backgroundColor=[UIColor whiteColor];
        }
        if([[_detailSection objectAtIndex:section] isEqual:@"相关推荐"]){
            jiantou.hidden=YES;
            sectionView.backgroundColor=[UIColor whiteColor];
            Idlabel.backgroundColor=[UIColor whiteColor];
        }
        
    }
    return backGround;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([[self.detailSection objectAtIndex:section]  isEqual:@""]||[[self.detailSection objectAtIndex:section]  isEqual:@"详细"]||[[self.detailSection objectAtIndex:section]  isEqual:@"他们也想学"]||[[self.detailSection objectAtIndex:section]isEqual:@"课程流程"]){
        return 10;
    }
    if([[self.detailSection objectAtIndex:section]  isEqual:@"时间地点"] ||[[self.detailSection objectAtIndex:section]  isEqual:@"秒杀价格"]){
        return 0.5;
    }
    if(section==0){
        return 0;
    }
    if ([[self.detailSection objectAtIndex:section]  isEqual:@"masters"]) {
        return 10;
    }
    
    return 57;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"时间地点"]){
        if (indexPath.row==0) {
            if([self.info[@"is_group"] isEqual:@"1"]&& ![self.info[@"is_enterprise"]  isEqual:@"1"]){
                if(![_info[@"course_cfg"] isEqual:@[]]){
                    isfromordernary = YES;
                    tag = @"1";
                    [self gotoSelectView:indexPath];
                }else{
                    [self pushtoCourseDateViewController:nil];
                }
            }else{
                if([self.info[@"is_enterprise"]  isEqual:@"1"]){
                    [self.viewController showPhonesActionSheet:CustomerServicePhone];
                }else{
                    [self phoneMaster];
                }
            }
        }else if(indexPath.row==1){
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
            MapViewController *myView = [story instantiateViewControllerWithIdentifier:@"MapViewController"];
            myView.info=self.info;
            //            myView.orderId=[[self.dataSource objectAtIndex:indexPath.section] objectAtIndex:indexPath.row][@"orderId"];
            [self.viewController.navigationController pushViewController:myView animated:YES];
        }else{
            [self gotoSelectView:indexPath];
        }
    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"秒杀价格"]){
       
        
    }
    else if([[_detailSection objectAtIndex:indexPath.section]isEqual:@"套餐"]){
        isfromordernary= YES;
        [self pushtoCourseDateViewController:self.info[@"course_cfg"][indexPath.row]];
    }else if([[_detailSection objectAtIndex:indexPath.section]isEqual:@"进阶课程"]){
        self.course_id=self.info[@"course_advance"][indexPath.row][@"course_id"];
        [self first];
    }else if([self haveShare:indexPath]){
        [self pushtoUserOrMasterViewController:self.info[@"share"][@"list"][indexPath.row]];
    }else if([[_detailSection objectAtIndex:indexPath.section]isEqual:@"他们也想学"]){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
        UIViewController *vct = [story instantiateViewControllerWithIdentifier:@"MyFansViewController"];
        vct.params=@{@"course_id":self.info [@"course_id"],@"comeIdentity":@"fans",@"title":@"他们也想学"};
        [self.viewController pushViewController:vct animated:YES];
    }else if([[_detailSection objectAtIndex:indexPath.section]isEqual:@"详细"]){
        [self goToStudentDetail:self.info];
        
    }else if([[_detailSection objectAtIndex:indexPath.section]isEqual:@"课程流程"]){
        //        [self goToStudentDetail:self.info];
        
        
    }else if([[_detailSection objectAtIndex:indexPath.section]isEqual:@"masters"]){
     
        
    }else if ([[_detailSection objectAtIndex:indexPath.section]isEqual:@"问大家"]){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
        AskViewController *askVC = [story instantiateViewControllerWithIdentifier:@"AskViewController"];
        askVC.params = @{@"course_id":self.course_id,@"title":self.info[@"title"]};
        [self.viewController pushViewController:askVC animated:YES];
    }
    
    else if(indexPath.section==0){
        
    }else{
        NSArray *cardArr=self.info[@"card"];
        if(indexPath.row <cardArr.count){
            UIViewController *vct = [UIViewController viewControllerWithName:@"CardPayViewController"];
            [vct setValue:self.info[@"card"][indexPath.row][@"card_id"] forKey:@"cardId"];
            [self.viewController pushViewController:vct animated:YES];
        }else{
            [self.viewController pushViewControllerWithUrl:self.info[@"coupon"][indexPath.row-cardArr.count][@"url"]];
        }
    }
    
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
            
            GoodDetailViewController * view=(GoodDetailViewController*)self.viewController;
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
