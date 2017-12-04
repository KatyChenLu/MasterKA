//
//  MyDetailCell.h
//  MasterKA
//
//  Created by hyu on 16/5/23.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cover;
@property (weak, nonatomic) IBOutlet UIImageView *img_top;
@property (weak, nonatomic) IBOutlet UILabel *nikename;
@property (weak, nonatomic) IBOutlet UIImageView *identifier;
@property (weak, nonatomic) IBOutlet UILabel *zanNum;
@property (weak, nonatomic) IBOutlet UILabel *by_browse_num;
@property (weak, nonatomic) IBOutlet UICollectionView *MasterVideo;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIView *segmentedControl;
@property (weak, nonatomic) IBOutlet UIImageView *blurImageView;

@end
