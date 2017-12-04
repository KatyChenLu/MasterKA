//
//  HobyView.h
//  MasterKA
//
//  Created by 余伟 on 16/12/8.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HobyView : UICollectionView

@property(nonatomic , copy)void(^selectbtnEnable)(id hoby);

@property(nonatomic ,strong)NSArray * model;

@end
