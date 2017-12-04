//
//  DianzanCollectionView.m
//  MasterKA
//
//  Created by lijiachao on 16/10/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#define URL_MasterCenter @"master://nmuser_master"
#import "DianzanCollectionView.h"
#import "DianzanCellectCell.h"
#import "Masonry.h"
#import "UIImageView+Master.h"

#define DianzanCellectCellIdentifer @"DianzanCellectCell"
@interface DianzanCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    //NSArray* dzArray;
    CGFloat xx;
    CGFloat yy;
    CGFloat radius;
    NSString* masterOruser;
    AppDelegate* appdelegate;
    //NSMutableArray* muArray;
}


@end
@implementation DianzanCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if(self = [super initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout])
    {
        appdelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        //self.muArray = [NSMutableArray new];
        xx = 1;
        yy =1;
        radius = 1;
        self.mineIndex =10;
        //        self.delegate = self;
        //        self.dataSource = self;
        self.dzArray = [[NSMutableArray alloc]init];
        self.backgroundColor = RGBFromHexadecimal(0xF0F0F2);
        self.alwaysBounceHorizontal = YES;
        self.delegate =self;
        self.dataSource = self;
        self.scrollEnabled = NO;
        [self registerClass:[DianzanCellectCell class] forCellWithReuseIdentifier:DianzanCellectCellIdentifer];
    }
    return self;
}

-(void)getDzData:(NSArray*)imageData width:(CGFloat)width shareID:(NSString*)shareId master:(NSString*)master is_like:(NSString*)is_like{
    self.isLike = is_like;
    self.shareId = shareId;
    masterOruser = master;
    [self.dzArray removeAllObjects];
    self.dzArray = [imageData mutableCopy];
    
    if(width>44)
    {
        yy = 4;
        xx = (width-36.0)/2;
        radius = 18;
    }
    else{
        xx = 4;
        yy = (44.0-(width-8))/2;
        radius = (width-8)/2;
    }
    [self reloadData];
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    DianzanCellectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DianzanCellectCellIdentifer forIndexPath:indexPath];
    
    
    [cell.topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView.mas_top).with.offset(yy);
        make.left.equalTo(cell.contentView.mas_left).with.offset(xx);
        make.right.equalTo(cell.contentView.mas_right).with.offset(-xx);
        make.bottom.equalTo(cell.contentView.mas_bottom).with.offset(-yy);
    }];
    cell.topImageView.layer.cornerRadius = radius;
    cell.topImageView.layer.masksToBounds = YES;
    
    if(self.dzArray.count>0)
    {
        NSDictionary* imgDic = self.dzArray[indexPath.row];
        if([self.isLike isEqualToString:@"0"]){
            self.mineIndex = 7;
        }
        else{
            
            if([[imgDic objectForKey:@"is_mine"]isEqualToString:@"1"])
            {
                self.mineIndex = indexPath.row;
            }
            else{
                if(self.mineIndex>6)
                {
                    self.mineIndex =7;
                }
            }
        }
         if(indexPath.row!=6){
                 NSString* imgUrl = [imgDic objectForKey:@"img_top"];
        [cell.topImageView setImageWithURLString:imgUrl placeholderImage:nil];
         }
         else{
             [cell.topImageView setImage:[UIImage imageNamed:@"更多"]];
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
    return self.dzArray.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row!=6){
    
    if(self.dzArray.count>0){
        NSDictionary* imgDic = self.dzArray[indexPath.row];
        NSString* uid = [imgDic objectForKey:@"uid"];
        
        NSString *url = [NSString stringWithFormat:@"%@?uid=%@",URL_MasterCenter,uid];

        [(BaseViewController*)appdelegate.baseVC pushViewControllerWithUrl:url];
    }
    }
    else{
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Mine" bundle:[NSBundle mainBundle]];
        UIViewController *myView = [story instantiateViewControllerWithIdentifier:@"MyFansViewController"];
        myView.params = @{@"share_id":self.shareId,@"title":@"粉丝列表",@"master":masterOruser};

       [appdelegate.baseVC pushViewController:myView animated:YES];
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
