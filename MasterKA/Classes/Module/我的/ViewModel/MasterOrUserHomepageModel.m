//
//  MydetailModel.m
//  MasterKA
//
//  Created by hyu on 16/5/23.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "MasterOrUserHomepageModel.h"
#import "MasterOrUserHomepageViewController.h"
//#import "UserShareListCell.h"
//#import "MasterShareTableViewCell.h"
#import "HMSegmentedControl.h"
#import "MasterVideoCell.h"
#import "CourseTableViewCell.h"
#import "GoodDetailViewController.h"
#import "MasterWebcell.h"
@interface MasterOrUserHomepageModel()
@property (nonatomic,strong) HMSegmentedControl *segmented;
@property(nonatomic,strong) UIWebView *detailWebView;
@property(nonatomic,assign) float detailWebViewHeight;
@property(nonatomic,strong) UIView *masterHeaderView;
@property(nonatomic,strong) UIView *headerView;
@end
@implementation MasterOrUserHomepageModel
- (void)initialize
{
    [super initialize];
    self.fresh=YES;
    @weakify(self)
    
    //点赞
    self.dianZan = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *dianzan) {
        @strongify(self)
        if ([self.viewController doLogin]) {
            MasterOrUserHomepageViewController * view=(MasterOrUserHomepageViewController*)self.viewController;
            if ([self.info[@"is_like"] isEqual:@"0"]) {
                [[self.httpService addUserLike:self.uid resultClass:nil] subscribeNext:^(BaseModel *model) {
                    @strongify(self)
                    if (model.code==200) {
                        [dianzan setImage:[UIImage imageNamed:@"dianzan-hong"] forState:UIControlStateNormal];
                        [self.info setValue:@"1" forKey:@"is_like"];
                        [dianzan setTitle:@"已赞" forState:UIControlStateNormal];
                        view.mineHeadView.zanNum.text=[NSString stringWithFormat:@"%d",[self.info[@"by_like_num"] intValue]+1];
                        [self.info setValue:view.mineHeadView.zanNum.text forKey:@"by_like_num"];
                        [self.viewController toastWithString:model.message error:NO];
                    }else{
                        [self.viewController toastWithString:model.message error:NO];
                    }
                }];
            }else{
                [[self.httpService removeUserLike:self.uid resultClass:nil] subscribeNext:^(BaseModel *model) {
                    @strongify(self)
                    if (model.code==200) {
                        [dianzan setImage:[UIImage imageNamed:@"dianzan"] forState:UIControlStateNormal];
                        [self.info setValue:@"0" forKey:@"is_like"];
                        [dianzan setTitle:@"点赞" forState:UIControlStateNormal];
                        view.mineHeadView.zanNum.text=[NSString stringWithFormat:@"%d",[self.info[@"by_like_num"] intValue]-1];
                        [self.info setValue:view.mineHeadView.zanNum.text forKey:@"by_like_num"];
                        [self.viewController toastWithString:model.message error:NO];
                    }else{
                        [self.viewController toastWithString:model.message error:NO];
                    }
                }];
            }
        }
        return [RACSignal empty];
    }];
    //关注
    self.attention = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *attention) {
        @strongify(self)
        if ([self.viewController doLogin]) {
            if ([self.info[@"is_follow"] isEqual:@"0"]) {
                [[self.httpService addAttention:self.uid resultClass:nil] subscribeNext:^(BaseModel *model) {
                    @strongify(self)
                    if (model.code==200) {
                        [attention setTitle:@"已关注" forState:UIControlStateNormal];
                        [attention setImage:[UIImage imageNamed:@"yiguanzhu"] forState:UIControlStateNormal];
                        [self.info setValue:@"1" forKey:@"is_follow"];
                        [self.viewController toastWithString:model.message error:NO];
                    }else{
                        [self.viewController toastWithString:model.message error:YES];
                    }
                }];
            }else{
                [[self.httpService removeAttention:self.uid resultClass:nil] subscribeNext:^(BaseModel *model) {
                    @strongify(self)
                    if (model.code==200) {
                        [attention setTitle:@"关注" forState:UIControlStateNormal];
                        [attention setImage:[UIImage imageNamed:@"attention"] forState:UIControlStateNormal];
                        [self.info setValue:@"0" forKey:@"is_follow"];
                        [self.viewController toastWithString:model.message error:NO];
                    }else{
                        [self showRequestErrorMessage:model];
                    }
                }];
            }
        }
        return [RACSignal empty];
    }];
    
    //分享
    self.share = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *share) {
        @strongify(self)
        [self.viewController shareContentOfApp:self.info[@"share_data"]];
        return [RACSignal empty];
    }];
    
    //提问！！！！！！！！！！！！！
    self.question = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *question) {
        @strongify(self)
        NSString * url = [NSString stringWithFormat:@"%@?userId=%@",URL_IMChating,self.uid];
        [self.viewController pushViewControllerWithUrl:url];
        return [RACSignal empty];
    }];
    
    
    RAC(self,info) = [self.requestRemoteDataCommand.executionSignals.switchToLatest  map:^id(BaseModel *model) {
        @strongify(self)
        if (model.code==200) {
            return model.data;
        }else{
            [self showRequestErrorMessage:model];
        }
        return nil;
    }];
    
    [[[RACObserve(self, info) filter:^BOOL(NSDictionary* info) {
        return  info != nil;
    }] deliverOnMainThread] subscribeNext:^(NSDictionary* info) {
        @strongify(self)
        if([info[@"identity"]  isEqual:@"1"]){
            if(![info[@"share_lists"]  isEqual:@[]]){
                self.dataSource=@[info[@"share_lists"]];
            }
            self.segmented_index=1;
        }else{
            self.segmented_index=0;
            if(self.info[@"video"] && ![self.info[@"video"] isEqual:@[]]){
                NSMutableArray *videoArr =[NSMutableArray array];
                [videoArr addObject:self.info[@"video"]];
                self.dataSource=@[videoArr,@[self.info[@"detail_link"]]];
            }else{
                self.dataSource=@[@[self.info[@"detail_link"]]];
            }
            [self setDetailWevViewUrlString:self.info[@"detail_link"]];
        }
        [self.mTableView reloadData];
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
- (UIView*)masterHeaderView
{
    if (!_masterHeaderView) {
        _masterHeaderView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 49)];
        _masterHeaderView.backgroundColor=[UIColor colorWithHex:0xF3F3F3];
        UILabel * line=[UILabel new];
        [_masterHeaderView addSubview: line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_masterHeaderView).with.offset(0);
            make.left.equalTo(_masterHeaderView).with.offset(0);
            make.height.mas_equalTo(@10);
            make.width.equalTo(_masterHeaderView);
        }];
        //            if (self.segmented.superview) {
        //                [self.segmented removeFromSuperview];
        //            }
        self.segmented.selectedSegmentIndex=self.segmented_index;
        [_masterHeaderView addSubview:self.segmented];
        [self.segmented mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).with.offset(0);
            make.left.equalTo(_masterHeaderView).with.offset(0);
            make.height.mas_equalTo(@39);
            make.width.equalTo(_masterHeaderView);
        }];
        @weakify(self);
        [self.segmented setIndexChangeBlock:^(NSInteger index) {
            @strongify(self);
            NSInteger section;
            if(index ==0){
                NSArray *detail_link =@[self.info[@"detail_link"]];
                //                    [videoArr addObject:self.info[@"video"]];
                //                    self.dataSource=@[videoArr,@[self.info[@"detail_link"]]];
                section=[self checkDatasource:self.info[@"video"] andSecond:detail_link];
            }else if (index==1){
                //                    NSMutableArray *videoArr =[NSMutableArray array];
                //                    [videoArr addObject:self.info[@"video"]];
                //                    self.dataSource=@[videoArr,self.info[@"share_lists"]];
                section=[self checkDatasource:self.info[@"video"] andSecond:self.info[@"share_lists"]];
            }else{
                //                    NSMutableArray *videoArr =[NSMutableArray array];
                //                    [videoArr addObject:self.info[@"video"]];
                //                    self.dataSource=@[videoArr,self.info[@"course_lists"]];
                section=[self checkDatasource:self.info[@"video"] andSecond:self.info[@"course_lists"]];
            }
            self.segmented_index=index;
            [self.mTableView reloadSections:[[NSIndexSet alloc] initWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
            self.segmented.selectedSegmentIndex=index;
            
        }];
    }
    return _masterHeaderView;
}
- (UIView*)headerView
{
    if (!_headerView) {
        _headerView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 49)];
        _headerView.backgroundColor=[UIColor colorWithHex:0xF3F3F3];
        UILabel * title=[UILabel new];
        UILabel * line=[UILabel new];
        [_headerView addSubview:title];
        [_headerView addSubview:line];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_headerView.mas_centerX);
            make.top.equalTo(_headerView).with.offset(13);
        }];
        title.text=[self.info[@"identity"]  isEqual:@"2"]?@"达人视频":@"我的分享";
        title.textColor=[UIColor colorWithHex:0x808080];
        [title setFont:[UIFont systemFontOfSize:15.f]];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_headerView.mas_centerX);
            make.bottom.equalTo(_headerView.mas_bottom).with.offset(-13);
            make.height.mas_equalTo(@0.5);
            make.width.equalTo(title);
        }];
        line.backgroundColor=[UIColor colorWithHex:0xf9ac17];
    }
    return _headerView;
}
- (void)setDetailWevViewUrlString:(NSString*)webUrlString{
    //    self.detailWebViewHeight = 180;
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:webUrlString]];
    [requestObj addMasterHeadInfo];
    [self.detailWebView loadRequest:requestObj];
    self.detailWebView.delegate = self;
}
- (void)bindTableView:(UITableView *)tableView
{
    [super bindTableView:tableView];
    self.cellReuseIdentifier = @"UserShareListCell";
    [self.mTableView registerCellWithReuseIdentifier:@"UserShareListCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"MasterShareTableViewCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"MasterVideoCell"];
    [self.mTableView registerCellWithReuseIdentifier:@"MasterWebcell"];
    [self.mTableView registerCellWithReuseIdentifier:@"CourseTableViewCell"];
}
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object{}
//{
//    if([cell isKindOfClass:[MasterVideoCell class]]){
//        MasterVideoCell *shareCell = (MasterVideoCell*)cell;
//        [shareCell setDataItems:object];
//    }
//    else{
//        if([cell isKindOfClass:[MasterWebcell class]]){
//            MasterWebcell *_cell=(MasterWebcell *)cell;
//            //            NSURL *url=[NSURL URLWithString:object];
//            //            [_cell.masterWeb loadRequest:[NSURLRequest requestWithURL:url]];
//            //            _cell.masterWeb.scrollView.scrollEnabled = NO;
//            //            _cell.masterWeb.delegate=self;
//            _cell.webUrlString =object;
//            if(self.detailWebViewHeight>0){
//                _cell.webViewHeightLayout.constant = self.detailWebViewHeight;
//                if((_cell.webView !=self.detailWebView)){
//                    _cell.webView = self.detailWebView;
//                }
//            }
//        }else if([cell isKindOfClass:[CourseTableViewCell class]]){
//            CourseTableViewCell *_cell=(CourseTableViewCell *)cell;
//            CourseModel *model =[[CourseModel alloc]init];
//            model.course_id=object[@"course_id"];
//            model.cover=object[@"cover"];
//            model.view_count=object[@"view_count"];
//            model.title=object[@"title"];
//            model.is_mpay=object[@"is_mpay"];//1是M点课程 0是现金课程
//            model.m_price=object[@"m_price"];
//            model.price=object[@"price"];
//            model.market_price=object[@"market_price"];
//            model.show_market_price=object[@"show_market_price"];
//            model.store=object[@"store"];
//            model.nikename=object[@"nikename"];
//            model.uid=object[@"uid"];
//            model.distance=object[@"distance"];
//            model.tags=object[@"tags"];
//            _cell.model = model;
//        }else{
//            if ([cell isKindOfClass:[UserShareListCell class]]) {
//                UserShareListCell *shareCell = (UserShareListCell*)cell;
//                [shareCell showMyShare:object WithIndex:nil];
//            }else{
//                MasterShareTableViewCell *masterShareCell = (MasterShareTableViewCell*)cell;
//                masterShareCell.contentLabel.text = object[@"content"];
//                masterShareCell.nikeNameLabel.text = object[@"nikename"];
//                masterShareCell.titleLabel.text = object[@"title"];
//                if (object [@"tag_name"] && ![object[@"tag_name"] isEqual:@""]) {
//                    [masterShareCell.tagButton setTitle:object[@"tag_name"] forState:UIControlStateNormal];
//                }else{
//                    masterShareCell.tagButton.hidden = YES;
//                }
//                [masterShareCell.likeButton setTitle:object[@"like_count"] forState:UIControlStateNormal];
//                [masterShareCell.browseButton setTitle:object[@"browse_count"] forState:UIControlStateNormal];
//
//                [masterShareCell.userHeadView setImageWithURLString:object[@"img_top"]];
//                [masterShareCell.coverView setImageWithURLString:object[@"cover"]];
//                //        [shareCell.tagButton addTarget:self action:@selector(tagButtonOnClick:) forControlEvents:UIControlEventTouchUpInside];
//            }
//        }
//    }
//}

- (RACSignal*)requestRemoteDataSignalWithPage:(NSUInteger)page
{
    return [self.httpService getMyDetail:self.uid resultClass:nil];
}

#pragma mark -- tableViewDataSource;

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if([self.info[@"identity"] isEqual:@"1"]){
        return self.headerView;
    }else{
        if(self.dataSource.count>1){
            if(section ==0){
                return self.headerView;
            }
            return self.masterHeaderView;
        }
        return self.masterHeaderView;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(([self.info[@"identity"] isEqual:@"2"]&&section==0 &&self.dataSource.count>1)||[self.info[@"identity"] isEqual:@"1"]){
        return 49.f;
    }
    return 58.f;
}
- (NSString*)getReuseIdentifierWithIndexPath:(NSIndexPath *)indexPath
{
    if([self.info[@"identity"] isEqual:@"2"]&& indexPath.section==0 &&self.dataSource.count>1){
        return @"MasterVideoCell";
    }else{
        if(self.segmented_index ==0){
            return @"MasterWebcell";
        }else if(self.segmented_index ==2){
            return @"CourseTableViewCell";
        }else{
            if ([[[self.info[@"share_lists"]  objectAtIndex:indexPath.row] objectForKey:@"master"] isEqual:@"user"]) {
                return self.cellReuseIdentifier;
            }else{
                return @"MasterShareTableViewCell";
            }
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self.info[@"identity"] isEqual:@"2"]&& indexPath.section==0 &&self.dataSource.count>1){
        
    }else{
        if(self.segmented_index ==0){
            
        }else if(self.segmented_index ==2){
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
            UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"GoodDetailViewController"];
            NSString *course_id = self.dataSource[indexPath.section][indexPath.row][@"course_id"];
            myView.params = @{@"courseId":course_id,@"coverStr":self.dataSource[indexPath.section][indexPath.row][@"cover"]} ;
            [self.viewController.navigationController pushViewController:myView animated:YES];
        }else{
            if ([[[self.info[@"share_lists"]  objectAtIndex:indexPath.row] objectForKey:@"master"] isEqual:@"user"]) {
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserShare" bundle:[NSBundle mainBundle]];
                UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"UserShareDetailViewController"];
                NSDictionary *mode = self.dataSource[indexPath.section][indexPath.row];
                myView.params = @{@"shareId":mode[@"share_id"] } ;
                [self.viewController.navigationController pushViewController:myView animated:YES];
            }else{
                NSDictionary *mode = self.dataSource[indexPath.section][indexPath.row];
                NSString * url = [NSString stringWithFormat:@"%@?shareId=%@",URL_MasterShareDetail,mode[@"share_id"]];
                [self.viewController pushViewControllerWithUrl:url];
            }
        }
    }
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //    UIColor *color = self.navigationController.navigationBar.barTintColor;
    
    
    NSInteger height = IsPhoneX?88:64;
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0) {
        CGFloat alpha = 1 - ((height - offsetY) / height);
        if (alpha>1.0f) {
            alpha =1.0f;
        }
        self.alphaNavigationBar = alpha;
    }else{
        self.alphaNavigationBar = 0.0f;
    }
    //    NSLog(@"%f",scrollView.contentSize.height);
    if(scrollView.contentSize.height >ScreenHeight+(110+height)){
        CGFloat header = height;//这个header其实是section1 的header到顶部的距离
        if (scrollView.contentOffset.y<=header&&scrollView.contentOffset.y>0) {
            //当视图滑动的距离小于header时
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }else if(scrollView.contentOffset.y>header)
        {
            //当视图滑动的距离大于header时，这里就可以设置section1的header的位置啦，设置的时候要考虑到导航栏的透明对滚动视图的影响
            scrollView.contentInset = UIEdgeInsetsMake(header, 0, 0, 0);
        }
        
    }else{
        scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}
#pragma mark -- webViewDelegate;
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    float webViewHeight = [[webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"] floatValue];
    self.detailWebViewHeight = webViewHeight;
    webView.height = webViewHeight;
    webView.delegate = nil;
    for (UITableViewCell *view in [self.mTableView visibleCells]) {/*visibleCells 界面上可见的cell ....用于适配plus*/
        NSLog(@"%@",NSStringFromClass(view.class));
        if ([NSStringFromClass(view.class) isEqualToString:@"MasterWebcell"]) {
            NSIndexPath *indexPath = [self.mTableView indexPathForCell:view];
            [self.mTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            //            [self.mTableView reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
    
}


- (HMSegmentedControl*)segmented{
    if (!_segmented) {
        _segmented = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"达人经历",@"分享",@"课程"]];
        _segmented.backgroundColor = [UIColor whiteColor];
        _segmented.selectionIndicatorHeight = 2.0f;
        _segmented.selectedTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHex:0xf9ac17],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18.f],NSFontAttributeName,nil];
        _segmented.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithHex:0x808080],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18.f],NSFontAttributeName,nil];
        _segmented.selectionIndicatorColor = [UIColor colorWithHex:0xf9ac17];
        _segmented.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmented.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
        //        _segmented.verticalDividerEnabled = YES;
        //        _segmented.verticalDividerColor = [UIColor colorWithHex:0x9d9d9d];
        //        _segmented.verticalDividerWidth = 0.25f;
    }
    return _segmented;
}
-(NSInteger )checkDatasource:(NSArray *)video andSecond:(NSArray *) array{
    if(video!=nil && ![video isEqual:@[]]){
        NSMutableArray *videoArr =[NSMutableArray array];
        [videoArr addObject:self.info[@"video"]];
        self.dataSource=@[videoArr,array];
        return 1;
    }else{
        self.dataSource=@[array];
        return 0;
    }
}

@end
