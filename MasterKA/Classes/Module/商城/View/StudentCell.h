//
//  StudentCell.h
//  MasterKA
//
//  Created by hyu on 16/5/19.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UICollectionView *studentCollection;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (nonatomic,strong)RACCommand *goToDetail;
- (void)setDataItems:(NSArray*)data;
@end
