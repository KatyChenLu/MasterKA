//
//  NewSearchViewController.h
//  MasterKA
//
//  Created by lijiachao on 16/10/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//
#import "BaseViewController.h"
#import "HttpManagerCenter.h"
#import "MasterShareListModel.h"
#import "MasterSearchListModel.h"
#import "AppDelegate.h"
@interface NewSearchViewController : BaseViewController
@property (nonatomic,weak,readonly)HttpManagerCenter *httpService1;
@property(nonatomic,strong)MasterSearchListModel* masterShareList;
@end
