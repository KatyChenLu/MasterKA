//
//  KAPlaceDetailViewController.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/27.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "KAPlaceDetailViewController.h"
#import "AticleDetailImageCell.h"
#import "KAContentTableViewCell.h"
#import "KAPlaceDetailTitleTableViewCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ESPictureBrowser.h"
//#import "KAEndView.h"
#import "KADetailEndView.h"
#import "MapViewController.h"

@interface KAPlaceDetailViewController ()<UITableViewDataSource, UITableViewDelegate,ESPictureBrowserDelegate>

@property (nonatomic, strong) UITableView *mTableView;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, assign) BOOL isTitleShow;
@property(nonatomic, strong)NSArray *array;
@property (nonatomic, strong) NSString *field_id;
@property (nonatomic, strong) UIView *headView;

@property (nonatomic, strong) NSDictionary *imageDic;
@property (nonatomic, assign) NSIndexPath *clickIndex;
@property (nonatomic, assign) KADetailEndView *endView;
@property (nonatomic,strong)NSDictionary *info;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong)NSString *img_Index;
@end

@implementation KAPlaceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _array = [[NSArray alloc] init];
    self.isTitleShow = NO;
    self.field_id = self.params[@"field_id"];
    
    [self.view addSubview:self.mTableView];
//    [self.navigationController.navigationBar addSubview:self.topLabel];
    
    
    UIView *titleV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth-60, 30)];
    
    [titleV addSubview:self.titleLabel];
    
    self.navigationItem.titleView = titleV;

    
    
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
//    [_topLabel removeFromSuperview];
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40,ScreenWidth - 100, 30)];
//        _titleLabel.backgroundColor = [UIColor redColor];
        _titleLabel.alpha = 0;
        _titleLabel.font = [UIFont systemFontOfSize:17];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _titleLabel;
}
- (UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 24,ScreenWidth - 32, 50)];
//        _topLabel.backgroundColor = [UIColor redColor];
        _topLabel.font = [UIFont systemFontOfSize:26];
        _topLabel.numberOfLines = 0;
        
    }
    return _topLabel;
}

- (UITableView *)mTableView {
    if (!_mTableView) {
        _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - (IsPhoneX?(34 + 88):64)) style:UITableViewStylePlain];
        _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
        [_headView addSubview:self.topLabel];
        _mTableView.tableHeaderView = _headView;
        _endView = [KADetailEndView endView];
        _endView.frame = CGRectMake(0, 0, ScreenWidth, 94);
        _mTableView.tableFooterView = _endView;
//        _headView.backgroundColor = [UIColor blueColor];
        _mTableView.delegate = self;
        _mTableView.dataSource = self;
        _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    
    
    if (str >= 0 && str <= 50) {
        
//        _topLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
//
//        CGAffineTransform transform = CGAffineTransformMakeScale(1-0.3*str/100, 1-0.3*str/100);
//        _topLabel.layer.anchorPoint = CGPointMake(0.5, 0.5);
//
//        _topLabel.transform = CGAffineTransformTranslate(transform, (self.navigationController.navigationBar.center.x - _topLabel.centerX+(IsPhoneX?30:40)) *str/100, (self.navigationController.navigationBar.center.y - (IsPhoneX?70:45)-_topLabel.centerY) *str/100);
        if (self.isTitleShow) {
            [UIView animateWithDuration:0.2 animations:^{
                self.titleLabel.frame =CGRectMake(0, 40, ScreenWidth - 100, 30);
                self.titleLabel.alpha = 0.0;
            } completion:^(BOOL finished) {
                
            }];
            self.isTitleShow = NO;
        }
       
        
    } else if (str > 50) {
        if (!self.isTitleShow) {
            [UIView animateWithDuration:0.2 animations:^{
                self.titleLabel.frame =CGRectMake(0, 0, ScreenWidth - 100, 30);
                self.titleLabel.alpha = 1.0;
            } completion:^(BOOL finished) {
                
            }];
            self.isTitleShow = YES;
        }
        
    } else if (str < 0 ) {
      
    }
    
}
- (void) setAnchorPoint:(CGPoint)anchorpoint forView:(UIView *)view{
    CGRect oldFrame = view.frame;
    view.layer.anchorPoint = anchorpoint;
    view.frame = oldFrame;
}


- (void)initRemote{
    
    RACSignal * signal = [[HttpManagerCenter sharedHttpManager] fieldDetail:self.field_id resultClass:nil];
    
    [signal subscribeNext:^(BaseModel * model) {
        
        if (model.code == 200) {
            self.info = model.data;
            self.array = model.data[@"detail_content"];
            self.topLabel.text = model.data[@"title"];
            self.titleLabel.text = model.data[@"title"];
            self.imageDic = model.data[@"img_arr"];
            [self.topLabel sizeToFit];
            [self.titleLabel sizeToFit];
            
            NSDictionary *titleDIC=self.array[0];
            _headView.frame = CGRectMake(0, 0, ScreenWidth, self.topLabel.height+24+[titleDIC[@"bottom"] floatValue]/2);
       
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
        
        
       
        
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        
        CGRect rect1 = [imgcell.detailImage convertRect:imgcell.detailImage.frame fromView:imgcell.contentView];//获取button在contentView的位置
          CGRect rect2 = [imgcell.detailImage convertRect:rect1 toView:window];
        
        UIView *brV = [[UIView alloc] init];
        
        brV.bounds = CGRectMake(rect2.origin.x, rect2.origin.y -100, rect2.size.width, rect2.size.height);
        
        [browser showFromView:brV picturesCount:_imageDic.count currentPictureIndex:_currentIndex];
    }else if ([type isEqualToString:@"4"]){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Goods" bundle:[NSBundle mainBundle]];
        MapViewController *myView = [story instantiateViewControllerWithIdentifier:@"MapViewController"];
        
        myView.info=self.info;
        
        [self.navigationController pushViewController:myView animated:YES];
    }
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
    
//    AticleDetailImageCell *cell = (AticleDetailImageCell *)[_mTableView cellForRowAtIndexPath:_clickIndex];
    
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
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    CGRect rect1 = [imgcell.detailImage convertRect:imgcell.detailImage.frame fromView:imgcell.contentView];//获取button在contentView的位置
    CGRect rect2 = [imgcell.detailImage convertRect:rect1 toView:window];
    
    UIView *brV = [[UIView alloc] init];
    
    brV.bounds = CGRectMake(rect2.origin.x, rect2.origin.y -100, rect2.size.width, rect2.size.height);
    
    return brV;
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
