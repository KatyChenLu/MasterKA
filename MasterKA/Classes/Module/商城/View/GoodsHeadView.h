//
//  GoodsHeadView.h
//  MasterKA
//
//  Created by xmy on 16/5/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoopScrollView.h"

@interface GoodsHeadView : UIView

@property (weak, nonatomic) IBOutlet LoopScrollView *imgLoopView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *companyBtn;

@end
