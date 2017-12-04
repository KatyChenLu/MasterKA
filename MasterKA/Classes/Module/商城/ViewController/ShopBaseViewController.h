//
//  ShopBaseViewController.h
//  MasterKA
//
//  Created by 余伟 on 16/8/15.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewController.h"

@protocol ShopBaseViewControllerDlegate <NSObject>

@optional

-(void)pageViewController:(UIPageViewController *)pageViewVc didChangeControllerWithIndex:(NSInteger)index;



@end


@interface ShopBaseViewController : BaseViewController


@property(nonatomic ,weak)id delegate;

@property(nonatomic,strong)UIButton *fetchBtn;

@property (nonatomic,strong)UIViewController *selectOrderVCT;

@property(nonatomic,strong)NSString* orderID;
@property(nonatomic,strong)NSString* selectID;
@property(nonatomic,strong)NSString* categoryId;
-(void)ischangeRefreshData;
- (void)first;


@end
