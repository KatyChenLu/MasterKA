//
//  KAMomentDetailViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/12/6.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAMomentDetailViewController.h"
#import "AticleDetailImageCell.h"
#import "KAContentTableViewCell.h"
#import "KAPlaceDetailTitleTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ESPictureBrowser.h"
#import "KADetailEndView.h"
#import "MapViewController.h"
#import "KAMomentHeaderView.h"
#import "KAMomentFooterView.h"
#import "KADetailViewController.h"
@interface KAMomentDetailViewController ()<UITableViewDataSource, UITableViewDelegate,ESPictureBrowserDelegate>

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) UILabel *topLabel;
@property(nonatomic, strong)NSArray *array;
@property (nonatomic, strong) NSString *moment_id;
@property (nonatomic, strong) UIView *beforeView;
//@property (nonatomic, strong) UIView *headView


@property (nonatomic, strong) NSDictionary *imageDic;
@property (nonatomic, assign) NSIndexPath *clickIndex;
@property (nonatomic, assign) KADetailEndView *endView;
@property (nonatomic,strong)NSDictionary *info;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong)NSString *img_Index;
@property (nonatomic, strong) KAMomentHeaderView *headerView;
@property (nonatomic, strong) KAMomentFooterView *footerView;
@property (nonatomic, strong) KAMomentFooterView *placeorlderFooterView;
@property (nonatomic, assign)BOOL isShowFooterView;

@end

@implementation KAMomentDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _array = [[NSArray alloc] init];
    _isShowFooterView = NO;
    
    self.moment_id = self.params[@"moment_id"];
    [self.view addSubview:self.mTableView];
    [self.view addSubview:self.footerView];
    
    [self.navigationController.navigationBar addSubview:self.topLabel];
    UIButton * moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBtn.frame = CGRectMake(0, 0, 30, 30);
    [moreBtn setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fetchItem = [[UIBarButtonItem alloc] initWithCustomView:moreBtn];
    
    self.navigationItem.rightBarButtonItem = fetchItem;
    [self initRemote];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_topLabel removeFromSuperview];
}
- (KAMomentFooterView *)footerView {
    if (!_footerView) {
        _footerView = [[[NSBundle mainBundle] loadNibNamed:@"KAMomentFooterView" owner:nil options:nil] lastObject];
        _footerView.userInteractionEnabled = YES;
        _footerView.frame = CGRectMake(18, ScreenHeight - 111 - 64, ScreenWidth-36, 105+64);
        _footerView.layer.cornerRadius = 6.0f;
        _footerView.layer.masksToBounds = YES;
        _footerView.hidden = YES;
        _footerView.alpha = 0;
        
        UISwipeGestureRecognizer *swipe =[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDownAction:)];
        [swipe setCancelsTouchesInView:NO];
        swipe.direction =UISwipeGestureRecognizerDirectionDown;
        [_footerView addGestureRecognizer:swipe];
        
        UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
        singleRecognizer.numberOfTapsRequired = 1; // 单击
        [self.view addGestureRecognizer:singleRecognizer];
        
        
         @weakify(self);
        [_footerView setColloctBlock:^(NSString *kaCourseid) {
               @strongify(self)
               if ([self doLogin]) {
            [[[HttpManagerCenter sharedHttpManager] addLikeCource:kaCourseid resultClass:nil] subscribeNext:^(BaseModel *model) {
             
                if (model.code==200) {
                    [self toastWithString:model.message error:NO];
                }else{
                    [self toastWithString:model.message error:YES];
                }
            }];
               }
        }];
        [_footerView setCancelColloctBlock:^(NSString *kaCourseid) {
              @strongify(self)
               if ([self doLogin]) {
            [[[HttpManagerCenter sharedHttpManager] cancelLikeCource:kaCourseid resultClass:nil] subscribeNext:^(BaseModel *model) {
              
                if (model.code==200) {
                    [self toastWithString:model.message error:NO];
                }else{
                    [self toastWithString:model.message error:YES];
                }
            }];
               }
        }];
        
    }
    return _footerView;
}
- (UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 24+44,ScreenWidth - 32, 50)];
        _topLabel.backgroundColor = [UIColor redColor];
        _beforeView = [[UIView alloc] initWithFrame:CGRectMake(16, 24+44,ScreenWidth - 32, 50)];
        _topLabel.font = [UIFont systemFontOfSize:26];
        _topLabel.numberOfLines = 0;
        
    }
    return _topLabel;
}
- (KAMomentHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[[NSBundle mainBundle] loadNibNamed:@"KAMomentHeaderView" owner:nil options:nil] lastObject];
    }
    return _headerView;
}

- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - (IsPhoneX?(34 + 88):64)) style:UITableViewStylePlain];
        
        _mTableView.tableHeaderView = self.headerView;
        _endView = [KADetailEndView endView];
        _endView.frame = CGRectMake(0, 0, ScreenWidth, 110+111+64);
        _endView.endLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        _mTableView.tableFooterView = _endView;
        _mTableView.canCancelContentTouches = NO;
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        
        [_mTableView registerClass:[AticleDetailImageCell class]forCellReuseIdentifier:@"AticleDetailImageCell"];
        [_mTableView registerCellWithReuseIdentifier:@"KAContentTableViewCell"];
        [_mTableView registerCellWithReuseIdentifier:@"KAPlaceDetailTitleTableViewCell"];
    }
    return _mTableView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    
    NSString * type = _array[indexPath.row][@"mode_id"];
    if ([type isEqualToString:@"1"]) {
        
        KAPlaceDetailTitleTableViewCell *mycell = [tableView dequeueReusableCellWithIdentifier:@"KAPlaceDetailTitleTableViewCell" forIndexPath:indexPath];
        [mycell configueCellWithModel:_array[indexPath.row]];
        cell = mycell;
    }else if ([type isEqualToString:@"2"]) {
        KAContentTableViewCell *mycell = [tableView dequeueReusableCellWithIdentifier:@"KAContentTableViewCell" forIndexPath:indexPath];
        [mycell configueCellWithModel:_array[indexPath.row]];
        mycell.rightIcon.hidden = YES;
        cell = mycell;
    }else if ([type isEqualToString:@"3"]){
        
        AticleDetailImageCell * imageCell = [tableView dequeueReusableCellWithIdentifier:@"AticleDetailImageCell" forIndexPath:indexPath];
        
        [imageCell configueCellWithModel:_array[indexPath.row]];
        
        cell = imageCell;
    }else if ([type isEqualToString:@"4"]){
        
        KAContentTableViewCell *mycell = [tableView dequeueReusableCellWithIdentifier:@"KAContentTableViewCell" forIndexPath:indexPath];
        [mycell configueCellWithModel:_array[indexPath.row]];
        mycell.rightIcon.hidden = NO;
        cell = mycell;
    }
    
    
    else{
        
        cell = [UITableViewCell new];
        
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * type = _array[indexPath.row][@"mode_id"];
    
    CGFloat height;
    if ([type isEqualToString:@"1"]) {
        height = [tableView fd_heightForCellWithIdentifier:@"KAPlaceDetailTitleTableViewCell" configuration:^(KAPlaceDetailTitleTableViewCell * cell) {
            
            [cell configueCellWithModel:_array[indexPath.row]];
            
        }];
    }else if ([type isEqualToString:@"2"]) {
        
        
        height = [tableView fd_heightForCellWithIdentifier:@"KAContentTableViewCell" configuration:^(KAContentTableViewCell * cell) {
            
            [cell configueCellWithModel:_array[indexPath.row]];
            
        }];
        
        
    }else if ([type isEqualToString:@"3"])
    {
        height = [tableView fd_heightForCellWithIdentifier:@"AticleDetailImageCell" configuration:^(AticleDetailImageCell* cell) {
            [cell configueCellWithModel:_array[indexPath.row]];
            
        }];
    }else if ([type isEqualToString:@"4"])
    {
        height = [tableView fd_heightForCellWithIdentifier:@"KAContentTableViewCell" configuration:^(KAContentTableViewCell* cell) {
            [cell configueCellWithModel:_array[indexPath.row]];
            
        }];
    }else{
        return 0;
    }
    return ceil(height);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _array.count;
}

//MARK:-滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat str = scrollView.contentOffset.y;
    NSLog(@"+++++++++++++%f",str);
    
    
    
    if (str >= 0 && str <= 100) {
        //        CGAffineTransform transform = CGAffineTransformMakeTranslation((ScreenWidth/2-76)*str/100, -str*78/100);
        //        _topLabel.transform = CGAffineTransformScale(transform, 1-str/300, 1-str/300);
        
        
        
        //        CGAffineTransform transform = CGAffineTransformMakeTranslation(((ScreenWidth/2-8)-99)*str/100, -(24+34)* str/100);
        //        _topLabel.transform = CGAffineTransformScale(transform, 1-str/300, 1-str/300);
        
        
//        CGAffineTransform transform = CGAffineTransformMakeScale(1-0.3*str/100, 1-0.3*str/100);
//
//        _topLabel.transform = CGAffineTransformTranslate(transform, ((ScreenWidth/2-8)-_beforeView.size.width*0.5)*str/100, -(_beforeView.origin.y+24)* str/100);
        
        _topLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
        
        CGAffineTransform transform = CGAffineTransformMakeScale(1-0.3*str/100, 1-0.3*str/100);
        _topLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);

        _topLabel.transform = CGAffineTransformTranslate(transform, (self.navigationController.navigationBar.center.x - _topLabel.centerX+(IsPhoneX?30:40)) *str/100, (self.navigationController.navigationBar.center.y - (IsPhoneX?70:45)-_topLabel.centerY) *str/100);
        
        
        
    } else if (str > 100) {
        
    } else if (str < 0 ) {
        
    }
    if (!_isShowFooterView) {
        if (str >ScreenHeight) {
            _footerView.hidden = NO;
           _isShowFooterView = YES;
            [UIView animateWithDuration:0.5 animations:^{
                _footerView.alpha = 1.0f;
            } completion:^(BOOL finished) {
                
            }];
        }
    }else{
        if (str<ScreenHeight) {
            
                _isShowFooterView = NO;
            [UIView animateWithDuration:0.5 animations:^{
                _footerView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                  _footerView.hidden = YES;
            
            }];
          
            
        }
    }
    
    
}


- (void)initRemote{
    
    RACSignal * signal = [[HttpManagerCenter sharedHttpManager] momentDetail:self.moment_id resultClass:nil];
    
    [signal subscribeNext:^(BaseModel * model) {
        
        if (model.code == 200) {
            self.info = model.data;
            self.array = model.data[@"detail_content"];
            self.topLabel.text = model.data[@"title"];
            self.imageDic = model.data[@"img_arr"];
            [self.topLabel sizeToFit];
            _beforeView.frame = self.topLabel.frame;
            NSDictionary *titleDIC=self.array[0];
            
            [_headerView showDetailHeaderView:model.data[@"moment_message"]];
            
            _headerView.topBlankHeight.constant = self.topLabel.height+24+[titleDIC[@"bottom"] floatValue]/2;
            
            [_footerView showDetailFooterView:model.data[@"course"]];
        }
        
    }completed:^{
        [self.mTableView reloadData];
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * type = _array[indexPath.row][@"mode_id"];
    if ([type isEqualToString:@"3"]) {
        AticleDetailImageCell * imgcell = (AticleDetailImageCell *)[_mTableView cellForRowAtIndexPath:indexPath];
        _clickIndex = indexPath;
        
        
        ESPictureBrowser *browser = [[ESPictureBrowser alloc] init];
        [browser setDelegate:self];
        [browser setLongPressBlock:^(NSInteger index) {
            NSLog(@"%zd", index);
        }];
        _img_Index = _array[indexPath.row][@"img_index"];
        _currentIndex = [[_img_Index substringFromIndex:6] integerValue];
        [browser showFromView:imgcell picturesCount:_imageDic.count currentPictureIndex:_currentIndex];
    }else if ([type isEqualToString:@"4"]){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
        MapViewController *myView = [story instantiateViewControllerWithIdentifier:@"MapViewController"];
        
        myView.info=self.info;
        [self.navigationController pushViewController:myView animated:YES];
    }
}


- (void)swipeDownAction:(UISwipeGestureRecognizer *)swipe {
    
    [UIView animateWithDuration:0.3 animations:^{
         _footerView.frame = CGRectMake(18, ScreenHeight, ScreenWidth-36, 200);
    } completion:^(BOOL finished) {
        _footerView.hidden = YES;
        _placeorlderFooterView = [[[NSBundle mainBundle] loadNibNamed:@"KAMomentFooterView" owner:nil options:nil] lastObject];
        
        _placeorlderFooterView.frame = CGRectMake(18, 110, ScreenWidth-36, 200);
        [_endView addSubview:_placeorlderFooterView];
    }];
}
- (void)SingleTap:(UITapGestureRecognizer *)tap {
    KADetailViewController *kaDetailVC = [[KADetailViewController alloc] init];
    
    kaDetailVC.ka_course_id = self.info[@"course"][@"ka_course_id"];
    
    kaDetailVC.headViewUrl = self.info[@"course"][@"course_cover"];
    
    [self.navigationController pushViewController:kaDetailVC animated:YES];
}
#pragma mark - ESPictureBrowserDelegate


/**
 获取对应索引的视图
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 视图
 */
- (UIView *)pictureView:(ESPictureBrowser *)pictureBrowser viewForIndex:(NSInteger)index {
    
    //    NSIndexPath *my = [NSIndexPath indexPathForRow:index inSection:0];
    //
    //    UserShareCollecCell *cell = (UserShareCollecCell *)[_imageCollectView cellForItemAtIndexPath:my];
    //
    //    return cell.contentView;
    
    AticleDetailImageCell *cell = (AticleDetailImageCell *)[_mTableView cellForRowAtIndexPath:_clickIndex];
    return cell.detailImage;
}

/**
 获取对应索引的图片大小
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片大小
 */
- (CGSize)pictureView:(ESPictureBrowser *)pictureBrowser imageSizeForIndex:(NSInteger)index {
    CGFloat w ,h;
    
    NSString * myindex = [NSString stringWithFormat:@"index_%ld",index];
    for (int i = 0; i<_array.count; i++) {
        NSDictionary *myDic = _array[i];
        if ([[myDic allKeys]containsObject:@"img_index"]) {
            if ([myDic[@"img_index"]isEqualToString:myindex]) {
                
                w = [myDic[@"width"] intValue];
                
                h = [myDic[@"height"] intValue];
            }
        }
    }
    
    
    CGSize size = CGSizeMake(w,h);
    
    return size;
}

/**
 获取对应索引默认图片，可以是占位图片，可以是缩略图
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片
 */
- (UIImage *)pictureView:(ESPictureBrowser *)pictureBrowser defaultImageForIndex:(NSInteger)index {
    AticleDetailImageCell * imgcell;
    NSString * myindex = [NSString stringWithFormat:@"index_%ld",index];
    for (int i = 0; i<_array.count; i++) {
        NSDictionary *myDic = _array[i];
        if ([[myDic allKeys]containsObject:@"img_index"]) {
            if ([myDic[@"img_index"]isEqualToString:myindex]) {
                imgcell  = (AticleDetailImageCell *)[_mTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
            }
        }
    }
    
    //    AticleDetailImageCell *cell = (AticleDetailImageCell *)[_mTableView cellForRowAtIndexPath:_clickIndex];
    return imgcell.detailImage.image;
}

/**
 获取对应索引的高质量图片地址字符串
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片的 url 字符串
 */
- (NSString *)pictureView:(ESPictureBrowser *)pictureBrowser highQualityUrlStringForIndex:(NSInteger)index {
    
    NSString * myindex = [NSString stringWithFormat:@"index_%ld",index];
    NSString *urlStr = [_imageDic valueForKey:myindex];
    urlStr = [urlStr masterFullImageUrl];
    
    return urlStr;
}

- (void)pictureView:(ESPictureBrowser *)pictureBrowser scrollToIndex:(NSInteger)index {
    
    
    
    AticleDetailImageCell * imgcell = (AticleDetailImageCell *)[_mTableView cellForRowAtIndexPath:_clickIndex];
    
    
    NSIndexPath *my = [NSIndexPath indexPathForRow:index inSection:0];
    
    
    _img_Index = [NSString stringWithFormat:@"index_%ld",index];
    for (int i = 0; i<_array.count; i++) {
        NSDictionary *myDic = _array[i];
        if ([[myDic allKeys]containsObject:@"img_index"]) {
            if ([myDic[@"img_index"]isEqualToString:_img_Index]) {
                _clickIndex = [NSIndexPath indexPathForRow:i inSection:0];
            }
        }
    }
    
    
    _currentIndex = index;
    
    NSLog(@"%ld", index);
}


- (void)dismissPictureBrowser:(ESPictureBrowser *)pictureBrowser viewForIndex:(NSInteger)index {
    
    NSIndexPath *my = [NSIndexPath indexPathForRow:index inSection:0];
    
    AticleDetailImageCell *cell = (AticleDetailImageCell *)[_mTableView cellForRowAtIndexPath:my];
    
    cell.alpha = 1;
}
- (void)shareAction {
    [self shareContentOfApp:self.info[@"share_data"]];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
