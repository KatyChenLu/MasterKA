//
//  MasterVideoCell.h
//  MasterKA
//
//  Created by hyu on 16/5/24.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *MasterVideo;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
- (void)setDataItems:(NSArray*)data;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionToBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionToPage;
@end
