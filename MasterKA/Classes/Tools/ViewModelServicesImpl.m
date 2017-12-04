//
//  ViewModelServicesImpl.m
//  MasterKA
//
//  Created by jinghao on 16/3/3.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "ViewModelServicesImpl.h"

@implementation ViewModelServicesImpl
@synthesize dbService = _dbService;
@synthesize networkService = _networkService;
@synthesize urlService = _urlService;
- (instancetype)init {
    self = [super init];
    if (self) {
        _dbService = [DBHelper sharedDBHelper];
        _networkService = [HttpManagerCenter sharedHttpManager];
        _urlService = [MasterUrlManager shareMasterUrlManager];
    }
    return self;
}
- (void)pushViewModel:(BaseViewModel *)viewModel animated:(BOOL)animated {}

- (void)popViewModelAnimated:(BOOL)animated {}

- (void)popToRootViewModelAnimated:(BOOL)animated {}

- (void)presentViewModel:(BaseViewModel *)viewModel animated:(BOOL)animated completion:(void (^)())completion {}

- (void)dismissViewModelAnimated:(BOOL)animated completion:(void (^)())completion {}

- (void)resetRootViewModel:(BaseViewModel *)viewModel {}
@end
