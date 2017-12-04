//
//  JiangyouModel.h
//  MasterKA
//
//  Created by lijiachao on 16/7/26.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "TableViewModel.h"

@interface JiangyouModel : TableViewModel
@property (nonatomic,strong)NSString *cardId;

@property BOOL isCategory;

@property (nonatomic,strong) UIButton *shuaiXuanBtn;
@end
