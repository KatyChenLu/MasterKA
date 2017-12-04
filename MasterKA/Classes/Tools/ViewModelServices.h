//
//  ViewModelServices.h
//  MasterKA
//
//  Created by jinghao on 16/3/3.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHelper.h"
#import "HttpManagerCenter.h"
#import "MasterUrlManager.h"
#import "NavigationProtocol.h"
@protocol ViewModelServices <NSObject,NavigationProtocol>
@required

@property (nonatomic,strong)DBHelper *dbService;
@property (nonatomic,strong)HttpManagerCenter *networkService;
@property (nonatomic,strong)MasterUrlManager *urlService;

@end
