//
//  GuessLikeCell.h
//  MasterKA
//
//  Created by hyu on 16/5/17.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface GuessLikeCell : BaseTableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *GuessLikeView;
@property (nonatomic,strong)NSMutableArray *dataSource;
- (void)setDataItems:(NSArray*)data;
@property (nonatomic,strong)RACCommand *courseCommand;
@end
