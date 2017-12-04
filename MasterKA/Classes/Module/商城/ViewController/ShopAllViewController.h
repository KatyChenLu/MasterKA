//
//  ShopAllViewController.h
//  MasterKA
//
//  Created by 余伟 on 16/9/26.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewController.h"

@interface ShopAllViewController : BaseViewController
@property(nonatomic,strong)NSString* orderID;
@property(nonatomic,strong)NSString* selectID;
@property(nonatomic,strong)NSString* categoryId;
-(void)ischangeRefreshData;
- (void)first;



@end
