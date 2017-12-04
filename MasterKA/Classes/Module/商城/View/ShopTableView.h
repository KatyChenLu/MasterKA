//
//  ShopTableView.h
//  shop
//
//  Created by 余伟 on 16/8/10.
//  Copyright © 2016年 余伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopTableView : UITableView

@property(nonatomic ,strong)id model;


@property(nonatomic , copy)void(^jumpH5)(NSString *h5Url);


@property(nonatomic ,assign)BOOL isChange;

@property(nonatomic ,strong)NSMutableArray * sourceArr;

-(void)first;


@end
