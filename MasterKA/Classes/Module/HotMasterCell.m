//
//  HotMasterCell.m
//  MasterKA
//
//  Created by lijiachao on 16/9/26.
//  Copyright © 2016年 jinghao. All rights reserved.
//
#define HotMasterCollectCellIdentifer @"HotMasterCollectCell"
#import "HotMasterCell.h"
#import "HotMasterCollectionViewCell.h"
#import "Masonry.h"
#import "HostManShareModel.h"
#import "KAHomeViewController.h"

#define YYMaxSections 300
@interface HotMasterCell()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>
{
    HostManShareModel* hostmanModel;
    NSArray* lunBOList;
    CGFloat currentX;
    AppDelegate* appdelegate;
}

@property (nonatomic,strong)UICollectionView* colView;
@property (nonatomic,strong)UICollectionViewFlowLayout *layout;
@property (nonatomic,strong)UIView* bbb;
@property (nonatomic,strong)NSArray* gotoCollectArray;
@property (nonatomic,strong)UILabel* hotMasterTitle;
@property (nonatomic,strong)UILabel* englisnTitle;
@property (nonatomic,strong)UIButton* qiyetuanjian;

@end
@implementation HotMasterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.gotoCollectArray = [NSArray new];
        
        lunBOList = [NSArray new];
        
        appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.hotMasterTitle = [[UILabel alloc]init];
        self.hotMasterTitle.backgroundColor = [UIColor whiteColor];
        self.hotMasterTitle.text = @"热门达人";
        self.hotMasterTitle.textColor = [UIColor blackColor];
        self.hotMasterTitle.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.hotMasterTitle];
        
        self.englisnTitle = [[UILabel alloc]init];
        self.englisnTitle.backgroundColor = [UIColor whiteColor];
        self.englisnTitle.text = @"Hot Master";
        self.englisnTitle.textColor = RGBFromHexadecimal(0x999999);
        self.englisnTitle.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:self.englisnTitle];
        
        self.qiyetuanjian = [[UIButton alloc]init];
        [self.qiyetuanjian setTitle:@"企业团建" forState:UIControlStateNormal];
        self.qiyetuanjian.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.qiyetuanjian setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

        [self.qiyetuanjian addTarget:self action:@selector(qiyeClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.qiyetuanjian];
        
        [self.qiyetuanjian mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(14);
            make.right.equalTo(self.contentView.mas_right).with.offset(-13);
            make.height.mas_equalTo(20);
            make.width.mas_equalTo(70);
        }];
        
        UIImageView* xiangyou = [[UIImageView alloc]init];
        [xiangyou setImage:[UIImage imageNamed:@"向右"]];
        [self.contentView addSubview:xiangyou];
        
        [xiangyou mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(17);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(35/2.0-4);
            make.right.equalTo(self.contentView.mas_right).with.offset(-5);
        }];
        
        
        
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //
        self.layout.itemSize = CGSizeMake(250, 150);
        self.layout.minimumInteritemSpacing = 10.0f;
        self.colView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,160, self.contentView.frame.size.width, self.contentView.frame.size.height) collectionViewLayout:self.layout];
        [self.colView registerClass:[HotMasterCollectionViewCell class] forCellWithReuseIdentifier:HotMasterCollectCellIdentifer];
        self.colView.backgroundColor = [UIColor whiteColor];

        self.colView.dataSource = self;
        self.colView.delegate = self;
        self.colView.alwaysBounceHorizontal = YES;
        self.colView.showsHorizontalScrollIndicator = NO;
      
        [self.contentView addSubview:self.colView];
        
        [self.hotMasterTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(18);
            make.top.equalTo(self.contentView.mas_top).with.offset(16);
            make.width.mas_equalTo(@65);
            make.height.mas_equalTo(@18);
        }];
        
        
        [self.englisnTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.hotMasterTitle.mas_right);
            make.top.equalTo(self.hotMasterTitle.mas_top).with.offset(5);
            make.width.mas_equalTo(@65);
            make.height.mas_equalTo(@13);
        }];
        
        [self.colView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.hotMasterTitle.mas_bottom).with.offset(15);
            make.height.mas_equalTo(@150);
            make.right.left.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-6);
        }];
    }
    return  self;
}

-(void)qiyeClicked{
    
    if(![UserClient sharedUserClient].rawLogin){
        
        BaseViewController*vc = (BaseViewController*)appdelegate.baseVC;
        [vc doLogin];
        
    }
    else{
//        NSString *path = [UserClient sharedUserClient].enterprise_course_url ;
//        BaseViewController*vc = (BaseViewController*)appdelegate.baseVC;
//        [vc pushViewControllerWithUrl:path ];
        KAHomeViewController *kaHomeVC = [[KAHomeViewController alloc] init];
                BaseViewController*vc = (BaseViewController*)appdelegate.baseVC;
                [vc pushViewController:kaHomeVC animated:YES];
    }

}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(self.gotoCollectArray.count>0){
    return YYMaxSections;
    }
    else{
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HotMasterCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:HotMasterCollectCellIdentifer forIndexPath:indexPath];
    if(self.gotoCollectArray.count>0){
        lunBOList = nil;
        hostmanModel = self.gotoCollectArray[indexPath.row%self.gotoCollectArray.count];
        lunBOList = [NSArray arrayWithObjects:hostmanModel.first_photo,hostmanModel.second_photo,hostmanModel.third_photo,nil];
        cell.btn1.browserImages = lunBOList;
        cell.btn2.browserImages = lunBOList;
        cell.btn3.browserImages = lunBOList;
        [cell setHotMasterCollCellData:self.gotoCollectArray[indexPath.row%self.gotoCollectArray.count]];
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(self.gotoCollectArray.count>0){
        hostmanModel = self.gotoCollectArray[indexPath.row%self.gotoCollectArray.count];
        if(hostmanModel.uid!=nil){
            
            NSString *url = [NSString stringWithFormat:@"%@?uid=%@",URL_MasterCenter,hostmanModel.uid];
            
         RACSignal * signal = [[HttpManagerCenter sharedHttpManager]totalMaster_id:hostmanModel.uid resultClass:nil];
            __weak typeof (self)weakself = self;
            [signal subscribeNext:^(BaseModel * model) {
                
                
                if (model.code == 200) {
                    
                    NSLog(@"%@" , model.data);
                }
                
            }];
            
            [(BaseViewController*)appdelegate.baseVC pushViewControllerWithUrl:url];
        }
    }
}
-(void) setHotCellData:(NSArray*) list{
    if(list!=nil&&list.count>0){
        self.gotoCollectArray = nil;
        
        self.gotoCollectArray = list;

        [self.colView reloadData];
                [self.colView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:YYMaxSections/self.gotoCollectArray.count/2*self.gotoCollectArray.count inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally  animated:NO];
         currentX  = self.colView.contentOffset.x;
        NSLog(@"11");
    }
}



- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    CGFloat x =targetContentOffset->x - currentX;
    
    if(x<0){
        CGFloat y = -x;
        if(y<130)
        {
            *targetContentOffset = CGPointMake(currentX, 0);
        }
        else{
            CGFloat xx =  y-130;
            int num = xx/260+1;
            *targetContentOffset = CGPointMake(currentX-num*260, 0);
        }
    }
    else{
        if(x<130){
            *targetContentOffset = CGPointMake(currentX, 0);
        }
        else{
            CGFloat xx =  x-130;
            int num = xx/260+1;
            *targetContentOffset = CGPointMake(currentX+num*260, 0);
        }
    }
   // *targetContentOffset = CGPointMake(100, 1);//计算出想要其停止的位置
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

