//
//  UICollectionView+Master.m
//  MasterKA
//
//  Created by jinghao on 16/3/18.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "UICollectionView+Master.h"

@implementation UICollectionView (Master)
- (void)registerCellWithReuseIdentifier:(NSString *)identifier{
    UINib* nib = [UINib nibWithNibName:identifier bundle:nil];
    [self registerNib:nib forCellWithReuseIdentifier:identifier];
}
@end
