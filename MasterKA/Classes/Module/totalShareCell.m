//
//  totalShareCell.m
//  MasterKA
//
//  Created by lijiachao on 16/9/27.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "totalShareCell.h"

#import "UserShareCollecCell.h"
#import "Masonry.h"
#import "MasterShareModel.h"
#import "TTTAttributedLabel.h"
#import "ShareCommentsCell.h"
#import "DianzanCollectionView.h"
#import "HttpManagerCenter.h"
#import "ZanButton.h"
#import "searchTableView.h"
#import "ESPictureBrowser.h"

#define UserShareCollecCellIdentifer @"UserShareCollecCell"
#define ShareCommentsCellIdentifer @"ShareCommentsCell"
#define IMG2_WIDTH (([UIScreen mainScreen].bounds.size.width-57-6)/2)
#define IMG3_WIDTH (([UIScreen mainScreen].bounds.size.width-57-12)/3)
@interface totalShareCell()<UICollectionViewDelegate,UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource,ESPictureBrowserDelegate>
{
    UIView* commentBackView;
//    MasterShareModel* sharelist;
    NSDictionary* collectDic;
    NSArray* imageArray;
    NSString*vv;
    float collectHeight1;
    float collectwidth;
    UILabel* timeLabel;
    int ccc ;
    NSArray* comtDataArray;
    NSMutableArray* comtList;
    CGFloat comtentheight;
    CGFloat dzWidth;
    NSMutableArray* cashArray;
    NSMutableDictionary*mineDic;
    BOOL isdianzClicked;
    NSMutableArray* dataArray;
    NSMutableArray* atArray;
    NSMutableArray* indexArray;
    NSMutableArray* dataArray2;
    NSMutableArray* atArray2;
    NSMutableArray* indexArray2;
    
    NSMutableArray* dataArray3;
    NSMutableArray* atArray3;
    NSMutableArray* indexArray3;
    NSString* reSring;
    NSString* url;
    NSString* contentStr;
    NSIndexPath * _indexPath;
    UIImageView* sanjiao;
    UILabel* welcomeDz;
//    AppDelegate* appdelegate;
    CGFloat  realContentHeight;
}

@property (nonatomic, strong)MasterShareModel* sharelist;
@property(nonatomic,strong)UIImageView* KingImage;
@property(nonatomic,strong)UIImageView* headImageView;
@property(nonatomic,strong)UILabel* headTitle;
@property(nonatomic,strong)TTTAttributedLabel* contentLabel;
@property(nonatomic,strong)UICollectionView* imageCollectView;
@property(nonatomic,strong)UICollectionViewFlowLayout*layout;
@property(nonatomic,strong)UICollectionViewFlowLayout*dianzanlayout;
@property(nonatomic,strong)UITableView* commentTableView;
@property(nonatomic,strong)UIView* dianzanView;
@property(nonatomic,strong)ZanButton* dianzanBtn;
@property(nonatomic,strong)DianzanCollectionView* dianzanCollectView;
@property(nonatomic,copy)NSArray* tempArray;
@property(nonatomic,strong)UIButton* deleteBtn;
@property(nonatomic,strong)UIButton * showAllBtn;
@property (nonatomic, assign)NSIndexPath* clickIndex;
@property (nonatomic, strong)AppDelegate* appdelegate;


@end

@implementation totalShareCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        comtList = [NSMutableArray new];
        mineDic =  [NSMutableDictionary new];
        dataArray = [NSMutableArray new];
        atArray = [NSMutableArray new];
        indexArray = [NSMutableArray new];
        dataArray2 = [NSMutableArray new];
        atArray2 = [NSMutableArray new];
        indexArray2 = [NSMutableArray new];
        
        dataArray3 = [NSMutableArray new];
        atArray3 = [NSMutableArray new];
        indexArray3 = [NSMutableArray new];
        
        self.appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        CGRect frame = self.contentView.frame;
        frame.size.width = [UIScreen mainScreen].bounds.size.width;
        self.contentView.frame = frame;
        self.contentView.backgroundColor = [UIColor whiteColor];
        // sharelist = [[MasterShareModel alloc]init];
        imageArray = [NSArray new];
        cashArray = [NSMutableArray new];
        self.headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 14,36, 36)];
        self.headImageView.backgroundColor = [UIColor whiteColor];
        self.headImageView.layer.cornerRadius = 2.0;
        self.headImageView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:self.headImageView];
        
        self.KingImage = [[UIImageView alloc]initWithFrame:CGRectMake(37, 11, 18, 18)];
        [self.KingImage setImage:[UIImage imageNamed:@"达人"]];
        self.KingImage.centerX = self.headImageView.right;
        self.KingImage.centerY = self.headImageView.top;
        self.KingImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.KingImage];
        
        self.headTitle = [[UILabel alloc] init];
        self.headTitle.text= @"headTitle";
        self.headTitle.textColor = RGBFromHexadecimal(0x465682);
        self.headTitle.font = [UIFont boldSystemFontOfSize:15];
        [self.contentView addSubview:self.headTitle];
        
      
        
        self.contentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(1, 1, 1, 1)];
        
        self.contentLabel.font = [UIFont systemFontOfSize:14];
        self.contentLabel.numberOfLines =0;
        self.contentLabel.textColor = RGBFromHexadecimal(0x474747);
        //RGBFromHexadecimal(0x464646);
        self.contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;;
        
        self.contentLabel.lineSpacing = 5;
        self.contentLabel.delegate = self;
        self.contentLabel.enabledTextCheckingTypes = NSTextCheckingTypeLink;
        NSMutableDictionary *linkAttributes = [NSMutableDictionary dictionary];
        [linkAttributes setValue:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
        [linkAttributes setValue:RGBFromHexadecimal(0x507daf) forKey:(NSString *)kCTForegroundColorAttributeName];
        self.contentLabel.linkAttributes = linkAttributes;
        
        NSMutableDictionary* attributes = [NSMutableDictionary dictionaryWithDictionary:self.contentLabel.activeLinkAttributes];
        [attributes setObject:(__bridge id)[UIColor blueColor].CGColor forKey:(NSString*)kCTForegroundColorAttributeName];
        self.contentLabel.activeLinkAttributes = attributes;
        
        [self.contentView addSubview:self.contentLabel];
        
        timeLabel = [[UILabel alloc]init];
        timeLabel.backgroundColor= [UIColor whiteColor];
        timeLabel.textColor = RGBFromHexadecimal(0x999999);
        timeLabel.font = [UIFont systemFontOfSize:10];
        timeLabel.text = @"santianqian";
        [self.contentView addSubview:timeLabel];
        
        self.deleteBtn = [[UIButton alloc]init];
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.deleteBtn setTitleColor:RGBFromHexadecimal(0x307ab3) forState:UIControlStateNormal];
        self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [self.deleteBtn addTarget:self action:@selector(cancelClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.deleteBtn];
        
        [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(14);
            make.height.width.mas_equalTo(@36);
            make.left.equalTo(self.contentView.mas_left).with.offset(8);
        }];
        
        [self.headTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headImageView.mas_top).with.offset(2);
            make.height.mas_equalTo(@16);
            make.left.equalTo(self.headImageView.mas_right).with.offset(5);
            make.width.mas_equalTo(300);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headTitle.mas_bottom).with.offset(0.01);
            make.height.mas_equalTo(@15);
            make.left.equalTo(self.headImageView.mas_right).with.offset(5);
            make.right.equalTo(self.contentView.mas_right).with.offset(-8);
        }];
        
        
        self.showAllBtn = [[UIButton alloc]init];
        [self.showAllBtn setTitle:@"全文" forState:UIControlStateNormal];
        [self.showAllBtn setTitleColor:RGBFromHexadecimal(0x465682) forState:UIControlStateNormal];
        self.showAllBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.showAllBtn addTarget:self action:@selector(showAllAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.showAllBtn];
        
        [self.showAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentLabel.mas_bottom).with.offset(5);
            make.height.mas_equalTo(@14);
            make.left.equalTo(self.headImageView.mas_right).with.offset(5);
            make.width.mas_equalTo(@35);
        }];
        
        
        
        commentBackView = [[UIView alloc]init];
        commentBackView.backgroundColor = [UIColor lightGrayColor];
        
        [self.contentView addSubview:commentBackView];
        
        sanjiao = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"多边形-1"]];
        [self.contentView addSubview:sanjiao];
        
        self.dianzanView = [[UIView alloc]init];
        self.dianzanView.backgroundColor = RGBFromHexadecimal(0xF0F0F2);
        [self.contentView addSubview:self.dianzanView];
        
        UITapGestureRecognizer* dianzanViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap)];
        [self.dianzanView addGestureRecognizer:dianzanViewTap];
        
        
        self.dianzanBtn = [ZanButton buttonWithType:UIButtonTypeCustom];
        self.dianzanBtn.backgroundColor = [UIColor clearColor];
        [self.dianzanBtn setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
        [self.dianzanBtn addTarget:self action:@selector(showDianZanClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.dianzanView addSubview:self.dianzanBtn];
        
        self.layout = [[UICollectionViewFlowLayout alloc] init];
        
        self.layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.layout.minimumInteritemSpacing = 6.0f;
        self.layout.minimumLineSpacing = 6.0f;
        self.imageCollectView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,0,0) collectionViewLayout:self.layout];
        self.imageCollectView.backgroundColor = [UIColor whiteColor];
        //self.imageCollectView.contentInset =UIEdgeInsetsMake(0, 13, 0, 13);
        [self.imageCollectView registerClass:[UserShareCollecCell class] forCellWithReuseIdentifier:UserShareCollecCellIdentifer];
        
        self.imageCollectView.dataSource = self;
        self.imageCollectView.delegate = self;
        self.imageCollectView.alwaysBounceHorizontal = YES;
        self.imageCollectView.scrollEnabled = NO;
        [self.contentView addSubview:self.imageCollectView];
        
        [self.imageCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.showAllBtn.mas_bottom).with.offset(4);
            make.height.mas_equalTo(200);
            make.left.equalTo(self.headImageView.mas_right).with.offset(4);
            // make.right.equalTo(self.contentView.mas_right).with.offset(-6);
            make.width.mas_equalTo(200);
        }];
        
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageCollectView.mas_bottom).with.offset(8);
            make.height.mas_equalTo(15);
            make.left.equalTo(self.headImageView.mas_right).with.offset(4);
            make.right.equalTo(self.contentView.mas_right).with.offset(-6);
        }];
        
        [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageCollectView.mas_bottom).with.offset(5);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(35);
            
            make.right.equalTo(self.contentView.mas_right).with.offset(-6);
        }];
        
        [self.dianzanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(timeLabel.mas_bottom).with.offset(15);
            make.height.mas_equalTo(@44);
            make.width.mas_equalTo(@38);
            make.left.equalTo(self.headImageView.mas_right).with.offset(5);
        }];
        
        [sanjiao mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.dianzanView.mas_top);
            make.height.mas_equalTo(@9);
            make.width.mas_equalTo(@15);
            make.right.equalTo(self.dianzanView.mas_right).with.offset(-5);
        }];
        
        [self.dianzanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.equalTo(self.dianzanView.mas_top).with.offset(13);
            //            make.height.width.mas_equalTo(@18);
            //            make.left.equalTo(self.headImageView.mas_right).with.offset(15);
            make.top.bottom.right.left.equalTo(self.dianzanView);
        }];
        
        dzWidth = (self.contentView.frame.size.width-57-38.0)/7;
        
        self.dianzanlayout = [[UICollectionViewFlowLayout alloc] init];
        
        self.dianzanlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.dianzanlayout.itemSize = CGSizeMake(dzWidth, 44);
        
        self.dianzanlayout.minimumLineSpacing = 0;
        
        self.dianzanCollectView = [[DianzanCollectionView alloc]initWithFrame:CGRectMake(1, 1, 1, 1) collectionViewLayout:self.dianzanlayout];
        [self.contentView addSubview:self.dianzanCollectView];
        
        [self.dianzanCollectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(timeLabel.mas_bottom).with.offset(15);
            make.height.mas_equalTo(@44);
            make.left.equalTo(self.dianzanView.mas_right);
            make.right.equalTo(self.contentView.mas_right).with.offset(-8);
            
        }];
        
        welcomeDz = [[UILabel alloc]init];
        welcomeDz.text = @"赞一下";
        welcomeDz.textColor = RGBFromHexadecimal(0x465682);
        welcomeDz.font = [UIFont boldSystemFontOfSize:14];
        welcomeDz.backgroundColor = [UIColor clearColor];
        [self.dianzanCollectView addSubview:welcomeDz];
        welcomeDz.hidden = YES;
        
        [welcomeDz mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dianzanCollectView.mas_bottom).with.offset(12);
            make.height.mas_equalTo(@20);
            make.left.equalTo(self.dianzanCollectView.mas_left).with.offset(2);
            make.width.mas_equalTo(100);
        }];
        
        UIView* line = [[UIView alloc]init];
        line.backgroundColor = RGBFromHexadecimal(0xe0e0e0);
        //RGBFromHexadecimal(0xE1E1E2);
        [self.contentView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.dianzanCollectView);
            make.left.equalTo(self.dianzanView);
            make.height.mas_equalTo(@0.4);
            make.bottom.equalTo(self.dianzanCollectView.mas_bottom);
        }];
        
        self.commentTableView = [[UITableView alloc]init];
        self.commentTableView.backgroundColor= RGBFromHexadecimal(0xF0F0F2);
        self.commentTableView.delegate = self;
        self.commentTableView.dataSource = self;
        self.commentTableView.separatorColor = RGBFromHexadecimal(0xe0e0e0);
        [self.commentTableView registerClass:[ShareCommentsCell class] forCellReuseIdentifier:ShareCommentsCellIdentifer];
        self.commentTableView.scrollEnabled =NO;
        [self.contentView addSubview:self.commentTableView];
        
        [self.commentTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dianzanCollectView.mas_bottom);
            make.height.mas_equalTo(@1);
            make.left.equalTo(self.headImageView.mas_right).with.offset(5);
            make.right.equalTo(self.contentView.mas_right).with.offset(-8);
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-6).with.priorityLow();
        }];
    }
    return self;
}


-(void)handleSingleTap
{
    NSLog(@"1");
}
//点击点赞
-(void)showDianZanClicked{
    if(![(BaseViewController*)_appdelegate.baseVC doLogin]){
        
        return;
    }
    else{
        
        if(isdianzClicked ==NO){
            self.dianzanBtn.enabled = NO;
            if([self.sharelist.master isEqualToString:@"user"]){
                @weakify(self)
                [[[HttpManagerCenter sharedHttpManager] userShareLike:self.sharelist.share_id resultClass:nil] subscribeNext:^(BaseModel *model) {
                    @strongify(self)
                    if (model.code==200) {
                        [mineDic removeAllObjects];
                        [self.dianzanBtn likeAnimation];
                        [self.dianzanBtn setImage:[UIImage imageNamed:@"已点赞"] forState:UIControlStateNormal];
                        [mineDic setObject:[UserClient sharedUserClient].userInfo[@"nikename"] forKey:@"nikename"];
                        [mineDic setObject:[UserClient sharedUserClient].userInfo[@"img_top"] forKey:@"img_top"];
                        [mineDic setObject:[UserClient sharedUserClient].userInfo[@"uid"] forKey:@"uid"];
                        
                        [mineDic setObject:@"1" forKey:@"is_mine"];
                        self.sharelist.is_like = @"1";
                        self.dianzanCollectView.isLike = @"1";
                        [self.dianzanCollectView.dzArray insertObject:mineDic atIndex:0];
                        self.tempArray = self.dianzanCollectView.dzArray;
                        self.sharelist.like_list =self.tempArray;
                        self.dianzanCollectView.mineIndex =0;
                        [self.dianzanCollectView reloadData];
                        welcomeDz.hidden = YES;
                        isdianzClicked = YES;
                    }else{
                        
                    }
                    self.dianzanBtn.enabled = YES;
                }];
            }
            else{
                @weakify(self)
                [[[HttpManagerCenter sharedHttpManager] masterShareLike:self.sharelist.share_id resultClass:nil] subscribeNext:^(BaseModel *model) {
                    @strongify(self)
                    if (model.code==200) {
                        [mineDic removeAllObjects];
                        [self.dianzanBtn likeAnimation];
                        [self.dianzanBtn setImage:[UIImage imageNamed:@"已点赞"] forState:UIControlStateNormal];
                        [mineDic setObject:[UserClient sharedUserClient].userInfo[@"nikename"] forKey:@"nikename"];
                        [mineDic setObject:[UserClient sharedUserClient].userInfo[@"img_top"] forKey:@"img_top"];
                        [mineDic setObject:[UserClient sharedUserClient].userInfo[@"uid"] forKey:@"uid"];
                        [mineDic setObject:@"1" forKey:@"is_mine"];
                        self.sharelist.is_like = @"1";
                        self.dianzanCollectView.isLike = @"1";
                        [self.dianzanCollectView.dzArray insertObject:mineDic atIndex:0];
                        self.tempArray = self.dianzanCollectView.dzArray;
                        self.sharelist.like_list =self.tempArray;
                        self.dianzanCollectView.mineIndex =0;
                        [self.dianzanCollectView reloadData];
                        welcomeDz.hidden = YES;
                        isdianzClicked = YES;
                    }else{
                        
                    }
                    self.dianzanBtn.enabled = YES;
                }];
                
                
            }
            
        }else{
            self.dianzanBtn.enabled = NO;
            @weakify(self)
            if([self.sharelist.master isEqualToString:@"user"]){
                [[[HttpManagerCenter sharedHttpManager] userShareCancelLike:self.sharelist.share_id resultClass:nil] subscribeNext:^(BaseModel *model) {
                    @strongify(self)
                    if (model.code==200) {
                        [self.dianzanBtn setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
                        if(self.dianzanCollectView.mineIndex >6){}else{
                            
                            [self.dianzanCollectView.dzArray removeObjectAtIndex:self.dianzanCollectView.mineIndex];
                            self.tempArray = self.dianzanCollectView.dzArray;
                            self.sharelist.like_list =self.tempArray;
                            [self.dianzanCollectView reloadData];
                        }
                        self.sharelist.is_like = @"0";
                        self.dianzanCollectView.isLike = @"0";
                        self.dianzanCollectView.mineIndex = 10;
                        if(self.dianzanCollectView.dzArray.count<1){
                            welcomeDz.hidden = NO;
                        }
                        else{
                            welcomeDz.hidden = YES;
                        }
                        isdianzClicked = NO;
                        
                    }else{
                        
                    }
                    self.dianzanBtn.enabled = YES;
                }];
            }
            else{
                
                @weakify(self)
                [[[HttpManagerCenter sharedHttpManager] userShareCancelLike:self.sharelist.share_id resultClass:nil] subscribeNext:^(BaseModel *model) {
                    @strongify(self)
                    if (model.code==200) {
                        [self.dianzanBtn setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
                        if(self.dianzanCollectView.mineIndex >6){}else{
                            
                            [self.dianzanCollectView.dzArray removeObjectAtIndex:self.dianzanCollectView.mineIndex];
                            self.tempArray = self.dianzanCollectView.dzArray;
                            self.sharelist.like_list =self.tempArray;
                            [self.dianzanCollectView reloadData];
                        }
                        self.sharelist.is_like = @"0";
                        self.dianzanCollectView.isLike = @"0";
                        self.dianzanCollectView.mineIndex = 10;
                        if(self.dianzanCollectView.dzArray.count<1){
                            welcomeDz.hidden = NO;
                        }
                        else{
                            welcomeDz.hidden = YES;
                        }
                        isdianzClicked = NO;
                        
                    }else{
                        
                    }
                    self.dianzanBtn.enabled = YES;
                }];
            }
        }
        NSLog(@"1");
    }
}


//cell导入数据
-(void) setShareList:(MasterShareModel*)list isfromHeight:(BOOL)isfromHeight deleteIndex:(NSIndexPath*)deleteIndex isAll:(BOOL)isall{
    _indexPath = deleteIndex;
    
    if(list!=nil)
    {
        self.sharelist = nil;
        self.sharelist = list;
        
        
        
        if([self.sharelist.is_mine isEqualToString:@"0"]||![UserClient sharedUserClient].rawLogin){
            self.deleteBtn.hidden = YES;
        }
        else{
            self.deleteBtn.hidden = NO;
        }
        
        if(self.sharelist.like_list.count>0){
            welcomeDz.hidden = YES;
        }
        else{
            welcomeDz.hidden = NO;
        }
        
        
        self.KingImage.hidden =[self.sharelist.identity isEqualToString:@"1"]?YES:NO;
        
        if([self.sharelist.is_like isEqualToString:@"1"]){
            
            [self.dianzanBtn setImage:[UIImage imageNamed:@"已点赞"] forState:UIControlStateNormal];
        }
        
        if(self.sharelist.detail!=nil&&self.sharelist.detail.count>0){
            imageArray =nil;
            imageArray = self.sharelist.detail;
            if(imageArray.count>0){
                [cashArray removeAllObjects];
                //NSInteger num = imageArray.count;
                
                
                for(NSDictionary*dic in imageArray){
                    NSString* img = [dic objectForKey:@"img_url"];
                    
                    [cashArray addObject:img];
                }
            }
            
            [self.headImageView setImageWithURLString:self.sharelist.img_top placeholderImage:nil];
            self.headTitle.text = self.sharelist.nikename;
            
            @weakify(self)
            
            
            
            [self.headImageView setTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                @strongify(self)
                NSString *pushUrl = [NSString stringWithFormat:@"%@?uid=%@",URL_MasterCenter,self.sharelist.uid];
                [(BaseViewController*)self.appdelegate.baseVC pushViewControllerWithUrl:pushUrl];
            }];
            
            [self.headTitle setTapActionWithBlock:^(UIGestureRecognizer *gestureRecoginzer) {
                @strongify(self)
                NSString *pushUrl = [NSString stringWithFormat:@"%@?uid=%@",URL_MasterCenter,self.sharelist.uid];
                [(BaseViewController*)self.appdelegate.baseVC pushViewControllerWithUrl:pushUrl];
            }];
            
            if(self.sharelist.address!=nil)
            {
                timeLabel.text = [NSString stringWithFormat:@"%@  %@",self.sharelist.time,self.sharelist.address];
            }
            else{
                timeLabel.text = self.sharelist.time;
            }
            
            comtDataArray = self.sharelist.comment_list;
            
            comtentheight =0.1;
            [comtList removeAllObjects];
            if(comtDataArray!=nil&&comtDataArray.count>0)
            {
                for(int i=0;i<comtDataArray.count;i++){
                    NSDictionary* comtDic = comtDataArray[i];
                    NSString* text = [comtDic objectForKey:@"content"];
                    
                    CGSize textSize = [text sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:12]}];
                    
                    CGFloat singleWth = textSize.width;
                    CGFloat singleht = textSize.height;
                    CGFloat contentwidth = [UIScreen mainScreen].bounds.size.width-145;
                    int lines = singleWth/contentwidth;
                    if(lines ==0)
                    {
                        comtentheight+=44.0;
                        NSNumber * tempnum = [NSNumber numberWithFloat:44.0];
                        [comtList addObject:tempnum];
                    }
                    else{
                        CGFloat hh = singleht*lines;
                        CGFloat anotherH = 44+hh;
                        NSNumber * tempnum = [NSNumber numberWithFloat:anotherH];
                        [comtList addObject:tempnum];
                        comtentheight +=anotherH;
                    }
                }
            }
            [self.commentTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.dianzanCollectView.mas_bottom);
                make.height.mas_equalTo(comtentheight);
                make.left.equalTo(self.headImageView.mas_right).with.offset(5);
                make.right.equalTo(self.contentView.mas_right).with.offset(-8);
                make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-8).with.priorityLow();
            }];
            
            [dataArray removeAllObjects];
            [atArray removeAllObjects];
            [indexArray removeAllObjects];
            
            [dataArray2 removeAllObjects];
            [atArray2 removeAllObjects];
            [indexArray2 removeAllObjects];
            
            [dataArray3 removeAllObjects];
            [atArray3 removeAllObjects];
            [indexArray3 removeAllObjects];
            
            reSring = nil;
            reSring = [NSString new];
            CGFloat contentsHeight;
            
            if(![self.sharelist.content isEqualToString:@""]){
                [self detailString:self.sharelist.content];
                
                CGSize textSize = [self.contentLabel.text sizeWithAttributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14] }];
                
                CGFloat singleWth = textSize.width;
                
                CGFloat singleht = 16.707;
                
                CGFloat contentwidth = self.contentView.frame.size.width-57;
                
                int lines = singleWth/contentwidth;
                
                NSArray *array = [self.sharelist.content componentsSeparatedByString:@"\r\n"];
                
                NSArray* marray =[self.sharelist.content componentsSeparatedByString:@"\n"];
                
                realContentHeight = singleht * (lines + array.count+marray.count +1);
                
                
                lines = lines + (int)array.count + (int)marray.count;
                
                if (lines > 3) {
                    contentsHeight = singleht*3;
                    self.showAllBtn.hidden = NO;
                }else if (lines == 3){
                    
                    contentsHeight = singleht*3;
                    self.showAllBtn.hidden = YES;
                }
                else {
                    contentsHeight = singleht*2;
                    
                    self.showAllBtn.hidden = YES;
                }
            }
            else{
                contentsHeight = 10;
                self.contentLabel.text = @"";
                self.showAllBtn.hidden = YES;
                //[self detailString:sharelist.content];
            }
            //行间距
            self.contentLabel.lineSpacing = 5;
            
            
            
            if (!isall) {
                
                [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headTitle.mas_bottom).with.offset(5);
                    make.height.mas_equalTo(contentsHeight);
                    make.left.equalTo(self.headImageView.mas_right).with.offset(5);
                    make.right.equalTo(self.contentView.mas_right).with.offset(-8);
                }];
                
                [self.showAllBtn setTitle:@"全文" forState:UIControlStateNormal];
                
            }else{
                [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.headTitle.mas_bottom).with.offset(5);
                    make.height.mas_equalTo(realContentHeight);
                    make.left.equalTo(self.headImageView.mas_right).with.offset(5);
                    make.right.equalTo(self.contentView.mas_right).with.offset(-8);
                }];
                
                [self.showAllBtn setTitle:@"收起" forState:UIControlStateNormal];
            }
            
            [self setImgs];
            
            
            
            if(isfromHeight ==NO){
                [self.imageCollectView reloadData];
                
                
                if([self.sharelist.is_like isEqualToString:@"0"])
                {
                    isdianzClicked = NO;
                    [self.dianzanBtn setImage:[UIImage imageNamed:@"点赞"] forState:UIControlStateNormal];
                    
                }
                else{
                    isdianzClicked = YES;
                    [self.dianzanBtn setImage:[UIImage imageNamed:@"已点赞"] forState:UIControlStateNormal];
                    
                }
                [self.dianzanCollectView getDzData:self.sharelist.like_list width:dzWidth shareID:self.sharelist.share_id master:self.sharelist.master is_like:self.sharelist.is_like];
                if(self.sharelist.like_list!=nil&&self.sharelist.like_list.count>0)
                {
                    
                }
                [self.commentTableView reloadData];
            }
        }
    }
    
    NSLog(@"%@",list);
}

//@字符串处理
- (void) detailString:(NSString*)con{
    
    //    NSString *con = @"<a href='https://www.baidu.com'>#Master达人2周年#</a>😄哈哈1-<a href='master://nmuser_master?uid=950'>@Summer</a>aiaiaii<a href='master://nmarticle_detail?index_article_id=467'>#6.1趣玩#</a>特斯拉<a href='http://www.baidu.com'>#Master达人2周年#</a>😄哈哈1 <a href='master://nmuser_master?uid=950'>@Summer</a><a href='master://nmarticle_detail?index_article_id=467'>#6.1趣玩#</a>特斯拉";
    
    if ([con rangeOfString:@"<a href"].location == NSNotFound)
    {
        self.contentLabel.text = con;
        
    }
    else{
        
        //匹配master:的地址
        NSString *regex = @"master:[^<]+>@";
        NSString *str = con;
        NSError *error;
        NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regex
                                                                                 options:NSRegularExpressionCaseInsensitive
                                                                                   error:&error];
        NSArray *matches = [regular matchesInString:str
                                            options:0
                                              range:NSMakeRange(0, str.length)];
        // 遍历匹配后的每一条记录
        for (NSTextCheckingResult *match in matches) {
            NSRange range = [match range];
            NSString *mStr = [str substringWithRange:range];
            NSString* intoStr = [mStr substringToIndex:[mStr length]-3];
            [dataArray addObject:intoStr];
        }
        
        //匹配@人名
        NSString *regex2 = @">@[^>]+</a";
        NSError *error2;
        NSRegularExpression *regular2 = [NSRegularExpression regularExpressionWithPattern:regex2
                                                                                  options:NSRegularExpressionCaseInsensitive
                                                                                    error:&error2];
        NSArray *matches2 = [regular2 matchesInString:str
                                              options:0
                                                range:NSMakeRange(0, str.length)];
        // 遍历匹配后的每一条记录
        for (NSTextCheckingResult *match in matches2) {
            NSRange range = [match range];
            NSString *mStr = [str substringWithRange:range];
            NSString* intoStr1 = [mStr substringToIndex:[mStr length]-3];
            NSString* intoStr2 = [intoStr1 substringFromIndex:1];
            [atArray addObject:intoStr2];
        }
        
        //匹配http
        NSString *regex3 = @"https?:[^<]+>";
        NSError *error3;
        NSRegularExpression *regular3 = [NSRegularExpression regularExpressionWithPattern:regex3
                                                                                  options:NSRegularExpressionCaseInsensitive
                                                                                    error:&error3];
        NSArray *matches3 = [regular3 matchesInString:str
                                              options:0
                                                range:NSMakeRange(0, str.length)];
        // 遍历匹配后的每一条记录
        for (NSTextCheckingResult *match in matches3) {
            NSRange range = [match range];
            NSString *mStr = [str substringWithRange:range];
            NSString* intoStr3 = [mStr substringToIndex:[mStr length]-2];
            [dataArray2 addObject:intoStr3];
        }
        
        //匹配link#话题#
        NSString *regex4 = @"https?:[^<]+>#[^#]+#<";
        NSError *error4;
        NSRegularExpression *regular4 = [NSRegularExpression regularExpressionWithPattern:regex4
                                                                                  options:NSRegularExpressionCaseInsensitive
                                                                                    error:&error4];
        NSArray *matches4 = [regular4 matchesInString:str
                                              options:0
                                                range:NSMakeRange(0, str.length)];
        // 遍历匹配后的每一条记录
        for (NSTextCheckingResult *match in matches4) {
            NSRange range = [match range];
            NSString *mStr = [str substringWithRange:range];
            NSString* intoStr1 = [mStr substringToIndex:[mStr length]-1];
            NSString* intoStr2 = [intoStr1 substringFromIndex:[mStr componentsSeparatedByString:@">"].firstObject.length + 1];
            [atArray2 addObject:intoStr2];
        }
        
        
        
        //匹配master:话题的地址
        NSString *regex7 = @"master:[^<]+>#";
        NSError *error7;
        NSRegularExpression *regular7 = [NSRegularExpression regularExpressionWithPattern:regex7
                                                                                  options:NSRegularExpressionCaseInsensitive
                                                                                    error:&error7];
        NSArray *matches7 = [regular7 matchesInString:str
                                              options:0
                                                range:NSMakeRange(0, str.length)];
        // 遍历匹配后的每一条记录
        for (NSTextCheckingResult *match in matches7) {
            NSRange range = [match range];
            NSString *mStr = [str substringWithRange:range];
            NSString* intoStr = [mStr substringToIndex:[mStr length]-3];
            [dataArray3 addObject:intoStr];
        }
        
        
        
        //匹配master#话题#
        NSString *regex6 = @"master:[^<]+>#[^#]+#<";
        NSError *error6;
        NSRegularExpression *regular6 = [NSRegularExpression regularExpressionWithPattern:regex6
                                                                                  options:NSRegularExpressionCaseInsensitive
                                                                                    error:&error6];
        NSArray *matches6 = [regular6 matchesInString:str
                                              options:0
                                                range:NSMakeRange(0, str.length)];
        // 遍历匹配后的每一条记录
        for (NSTextCheckingResult *match in matches6) {
            NSRange range = [match range];
            NSString *mStr = [str substringWithRange:range];
            NSString* intoStr1 = [mStr substringToIndex:[mStr length]-1];
            NSString* intoStr2 = [intoStr1 substringFromIndex:[mStr componentsSeparatedByString:@">"].firstObject.length + 1];
            [atArray3 addObject:intoStr2];
        }
        
        
        
        
        
        
        BOOL isinblock =NO;
        
        BOOL isHuaTiFirst = NO;
        
        BOOL isLink = NO;
        
        NSNumber *isFirstIndex = 0;
        
        for (int i = 0; i<str.length; i++) {
            
            if ([[NSString stringWithFormat:@"%c",[str characterAtIndex:i]]isEqualToString:@"<"]) {
                isinblock = YES;
                
                if ([[NSString stringWithFormat:@"%c",[str characterAtIndex:i-1]]isEqualToString:@"#"]&&isHuaTiFirst) {
                    isHuaTiFirst = NO;
                    if (isLink) {
                        
                        [indexArray2 addObject:isFirstIndex];
                    }else{
                        [indexArray3 addObject:isFirstIndex];
                    }
                }
                if ((i + 9)<[str length]) {
                    if ([[NSString stringWithFormat:@"%c",[str characterAtIndex:i+9]]isEqualToString:@"h"]) {
                        isLink = YES;
                    }else{
                        isLink = NO;
                    }
                }
                
                continue;
            }
            else if([[NSString stringWithFormat:@"%c",[str characterAtIndex:i]]isEqualToString:@">"])
            {
                
                isinblock= NO;
                if((i+1)<[str length]){
                    if ([[NSString stringWithFormat:@"%c",[str characterAtIndex:i+1]]isEqualToString:@"@"]) {
                        long index = reSring.length;
                        NSNumber *aNumber = [NSNumber numberWithInteger:index];
                        [indexArray addObject:aNumber];
                    }
                    if ([[NSString stringWithFormat:@"%c",[str characterAtIndex:i+1]]isEqualToString:@"#"]) {
                        
                        isHuaTiFirst = YES;
                        
                        long index = reSring.length;
                        NSNumber *aNumber = [NSNumber numberWithInteger:index];
                        
                        isFirstIndex = aNumber;
                    }
                }
                continue;
            }
            if (isinblock == NO) {
                NSString* temp = [str substringWithRange:NSMakeRange(i, 1)];
                reSring = [reSring stringByAppendingString:temp];
            }
            
        }
        
        
        self.contentLabel.text = reSring;
        for(int i = 0;i<indexArray.count;i++){
            NSLog(@"rrr%d",[[indexArray objectAtIndex:i]intValue]);
            url = [dataArray objectAtIndex:i];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:url] withRange:NSMakeRange([[indexArray objectAtIndex:i]intValue],[[atArray objectAtIndex:i] length])];
        }
        for(int i = 0;i<indexArray2.count;i++){
            NSLog(@"rrr%d",[[indexArray2 objectAtIndex:i]intValue]);
            url = [dataArray2 objectAtIndex:i];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:url] withRange:NSMakeRange([[indexArray2 objectAtIndex:i]intValue],[[atArray2 objectAtIndex:i] length])];
        }
        for(int i = 0;i<indexArray3.count;i++){
            NSLog(@"rrr%d",[[indexArray3 objectAtIndex:i]intValue]);
            url = [dataArray3 objectAtIndex:i];
            [self.contentLabel addLinkToURL:[NSURL URLWithString:url] withRange:NSMakeRange([[indexArray3 objectAtIndex:i]intValue],[[atArray3 objectAtIndex:i] length])];
        }
        
    }
    //<a href='http://www.baidu.com/'>#Master达人2周年#</a>😄哈哈1 <a href='master://nmuser_master?uid=950'>@Summer</a>lala<a href='https://www.baidu.com/'>#Master达人#</a>
}


-(void)setImgs{
    if(imageArray.count==1){
        
        NSDictionary *img = imageArray[0];
        int w = [img[@"width"] intValue];
        int h = [img[@"height"] intValue];
        
        float ww = w;
        float hh = h;
        if([self.sharelist.master isEqualToString:@"user"]){
            
            float maxchang = ScreenWidth * 0.5 ;
            float maxkuan = ScreenWidth * 0.5*0.618;
            
            if(w>h)
            {
                ww = maxkuan*w/h;
                if(ww>maxchang)
                {
                    ww = maxchang;
                }
                hh = maxkuan;
            }
            else{
                hh = maxkuan*h/w;
                if(hh>maxchang)
                {
                    hh = maxchang;
                }
                ww = maxkuan;
            }
            
            self.layout.itemSize = CGSizeMake(ww, hh);
            collectHeight1 =hh;
            collectwidth = ww;
        }
        else{
            
            collectwidth =IMG3_WIDTH*3+10;
            collectHeight1 = collectwidth*hh/ww;
            self.layout.itemSize = CGSizeMake(collectwidth, collectHeight1);
        }
        
    }else if(imageArray.count == 2 ){
        self.layout.itemSize = CGSizeMake(IMG2_WIDTH, IMG2_WIDTH);
        collectHeight1 = IMG2_WIDTH;
        collectwidth = IMG2_WIDTH*2+6;
        
    }else if(imageArray.count == 4){
        self.layout.itemSize = CGSizeMake(IMG2_WIDTH, IMG2_WIDTH);
        collectHeight1 = IMG2_WIDTH*2+6;
        collectwidth =IMG2_WIDTH*2+6;
    }else if(imageArray.count == 3 ){
        self.layout.itemSize = CGSizeMake(IMG3_WIDTH, IMG3_WIDTH);
        collectHeight1 = IMG3_WIDTH;
        collectwidth = IMG3_WIDTH*3+13;
        
    }else if(imageArray.count <= 6 ){
        self.layout.itemSize = CGSizeMake(IMG3_WIDTH, IMG3_WIDTH);
        
        collectHeight1 = IMG3_WIDTH*2+6;
        collectwidth =IMG3_WIDTH*3+13;
        
    }else{
        self.layout.itemSize = CGSizeMake(IMG3_WIDTH, IMG3_WIDTH);
        collectHeight1 = IMG3_WIDTH*3+12;
        collectwidth = IMG3_WIDTH*3+13;
    }
    
    if(collectHeight1>0)
    {
        if (!self.showAllBtn.hidden) {
            
            [self.imageCollectView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.showAllBtn.mas_bottom).with.offset(2);
                make.height.mas_equalTo(collectHeight1);
                make.left.equalTo(self.headImageView.mas_right).with.offset(5);
                make.width.mas_equalTo(collectwidth);
            }];
            
        }else{
            
            [self.imageCollectView mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                make.top.equalTo(self.contentLabel.mas_bottom).with.offset(5);
                make.height.mas_equalTo(collectHeight1);
                make.left.equalTo(self.headImageView.mas_right).with.offset(5);
                make.width.mas_equalTo(collectwidth);
            }];
        }
    }
    
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UserShareCollecCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UserShareCollecCellIdentifer forIndexPath:indexPath];
    
    if(imageArray!=nil&&imageArray.count>0){
        
        NSDictionary* imgdic = imageArray[indexPath.row];
        
        [cell.imgView setImageFadeInWithURLString:[imgdic objectForKey:@"img_url"] placeholderImage:nil];
        
        cell.tag = indexPath.row;
        
        if([[self.sharelist.detail[0] objectForKey:@"media_type"]isEqualToString:@"2"]){
            
            cell.playview.hidden =NO;
            
        }else{
            
            cell.playview.hidden = YES;
            
        }
        
    }
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(imageArray.count>0){
        return imageArray.count;
    }
    else{
        return 0;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //    if([sharelist.master isEqualToString:@"user"]){
    //
    //        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserShare" bundle:[NSBundle mainBundle]];
    //        UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"UserShareDetailViewController"];
    //
    NSDictionary * dic =self.sharelist.detail[0];
    //
    //        myView.params = @{@"shareId":sharelist.share_id,@"media_type":[dic objectForKey:@"media_type"],@"movieurl":[dic objectForKey:@"intro"]} ;
    //
    //
    //        [appdelegate.baseVC.navigationController pushViewController:myView animated:YES];
    //    }
    //    else{
    //        NSString * shareurl = [NSString stringWithFormat:@"%@?shareId=%@",URL_MasterShareDetail,sharelist.share_id];
    //        [(BaseViewController*)appdelegate.baseVC pushViewControllerWithUrl:shareurl];
    //    }
    //微信朋友圈效果
    
    if([self.sharelist.master isEqualToString:@"user"] &&[[dic objectForKey:@"media_type"] isEqualToString:@"1"]){
        UserShareCollecCell * imgcell = (UserShareCollecCell *)[_imageCollectView cellForItemAtIndexPath:indexPath];
        _clickIndex = indexPath;
        imgcell.alpha = 0;
        
        ESPictureBrowser *browser = [[ESPictureBrowser alloc] init];
        [browser setDelegate:self];
        [browser setLongPressBlock:^(NSInteger index) {
            NSLog(@"%zd", index);
        }];
        [browser showFromView:imgcell picturesCount:imageArray.count currentPictureIndex:(int)indexPath.row];
    }
    else if([self.sharelist.master isEqualToString:@"user"] &&[[dic objectForKey:@"media_type"] isEqualToString:@"2"]){
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"UserShare" bundle:[NSBundle mainBundle]];
        UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"UserShareDetailViewController"];
        
        NSDictionary * dic =self.sharelist.detail[0];
        
        myView.params = @{@"shareId":self.sharelist.share_id,@"media_type":[dic objectForKey:@"media_type"],@"movieurl":[dic objectForKey:@"intro"]} ;
        
        
        [self.appdelegate.baseVC.navigationController pushViewController:myView animated:YES];
    }

    else{
        NSString * shareurl = [NSString stringWithFormat:@"%@?shareId=%@",URL_MasterShareDetail,self.sharelist.share_id];
        [(BaseViewController*)self.appdelegate.baseVC pushViewControllerWithUrl:shareurl];
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if ([view isKindOfClass:[UICollectionView class]]) {
        return self;
    }
    return [super hitTest:point withEvent:event];
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
    
    UserShareCollecCell *cell = (UserShareCollecCell *)[_imageCollectView cellForItemAtIndexPath:_clickIndex];
    return cell.contentView;
}

/**
 获取对应索引的图片大小
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片大小
 */
- (CGSize)pictureView:(ESPictureBrowser *)pictureBrowser imageSizeForIndex:(NSInteger)index {
    
    NSDictionary *dic = imageArray[index];
    
    CGFloat w = [dic[@"width"] intValue];
    
    CGFloat h = [dic[@"height"] intValue];
    
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
    
    
    UserShareCollecCell *cell = (UserShareCollecCell *)[_imageCollectView cellForItemAtIndexPath:_clickIndex];
    return cell.imgView.image;
}

/**
 获取对应索引的高质量图片地址字符串
 
 @param pictureBrowser 图片浏览器
 @param index          索引
 
 @return 图片的 url 字符串
 */
- (NSString *)pictureView:(ESPictureBrowser *)pictureBrowser highQualityUrlStringForIndex:(NSInteger)index {
    NSString *urlStr = [imageArray[index] objectForKey:@"img_url"];
    
    
    urlStr = [urlStr masterFullImageUrl];
    
    return urlStr;
}

- (void)pictureView:(ESPictureBrowser *)pictureBrowser scrollToIndex:(NSInteger)index {
    
    
    
    UserShareCollecCell * imgcell = (UserShareCollecCell *)[_imageCollectView cellForItemAtIndexPath:_clickIndex];
    
    imgcell.alpha = 1;
    
    NSIndexPath *my = [NSIndexPath indexPathForRow:index inSection:0];
    
    UserShareCollecCell *cell = (UserShareCollecCell *)[_imageCollectView cellForItemAtIndexPath:my];
    
    cell.alpha = 0;
    
    _clickIndex = my;
    
    NSLog(@"%ld", index);
}


- (void)dismissPictureBrowser:(ESPictureBrowser *)pictureBrowser viewForIndex:(NSInteger)index {
    
    NSIndexPath *my = [NSIndexPath indexPathForRow:index inSection:0];
    
    UserShareCollecCell *cell = (UserShareCollecCell *)[_imageCollectView cellForItemAtIndexPath:my];
    
    cell.alpha = 1;
}











- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(comtDataArray!=nil&&comtDataArray.count>0){
        return comtDataArray.count;
    }
    else{
        return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ShareCommentsCell*cella;
    cella =[tableView dequeueReusableCellWithIdentifier:ShareCommentsCellIdentifer forIndexPath:indexPath];
    cella.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(comtDataArray!=nil&&comtDataArray.count>0)
    {
        [cella getCommentData:comtDataArray[indexPath.row]];
        
        if(indexPath.row>0){
            cella.commtImageView.hidden = YES;
        }
        else{
            cella.commtImageView.hidden = NO;
        }
    }
    return cella;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(comtList.count>0)
    {
        CGFloat h = [comtList[indexPath.row]floatValue];
        return h;
    }
    else{
        return 0.1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *cmturl= nil;
    if([self.sharelist.master isEqualToString:@"user"]){
        
        cmturl = [NSString stringWithFormat:@"%@?title=%@&shareId=%@&master=0&row=%@",URL_ShareCommentList,@"",self.sharelist.share_id,[NSString stringWithFormat:@"%ld",_indexPath.row]];
        
       
    }
    else{
        cmturl = [NSString stringWithFormat:@"%@?title=%@&shareId=%@&master=1&row=%@",URL_ShareCommentList,@"",self.sharelist.share_id,[NSString stringWithFormat:@"%ld",_indexPath.row]];
    }
    
    
    [(BaseViewController*)self.appdelegate.baseVC pushViewControllerWithUrl:cmturl];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url{
    NSString *str = [url absoluteString];
    [(BaseViewController*)self.appdelegate.baseVC pushViewControllerWithUrl:str];
}

-(void)cancelClicked{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"删除发布" message:@"你确定删除发布吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert show];
    
}
- (void)showAllAction{
    _isShowAll = !_isShowAll;
    
    
    NSArray* cancelArr = @[_indexPath,[NSString stringWithFormat:@"%f",realContentHeight]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showAll" object:cancelArr];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"%ld" , buttonIndex);
    if(buttonIndex==1){
        NSArray* cancelArr = @[self.sharelist.share_id,_indexPath,self.sharelist.master];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DeleteSearchView" object:cancelArr];
    }
}




@end
