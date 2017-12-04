//
//  GoodsSubCell.h
//  MasterKA
//
//  Created by xmy on 16/5/31.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface GoodsSubCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *GuessLikeView;
@property (nonatomic,strong)NSMutableArray *dataSource;
- (void)setDataItems:(NSArray*)data;
@property (nonatomic,strong)RACCommand *courseCommand;

@end
