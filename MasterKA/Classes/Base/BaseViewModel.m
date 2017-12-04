//
//  BaseViewModel.m
//  MasterKA
//
//  Created by jinghao on 15/12/11.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "BaseViewModel.h"


@interface BaseViewModel ()

@end

@implementation BaseViewModel

@synthesize dbService = _dbService;
@synthesize httpService = _httpService;
@synthesize viewController = _viewController;


+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    BaseViewModel *viewModel = [super allocWithZone:zone];
    
    @weakify(viewModel)
    [[viewModel
      rac_signalForSelector:@selector(init)]
    	subscribeNext:^(id x) {
            @strongify(viewModel)
            [viewModel initialize];
        }];
    
    return viewModel;
}

- (instancetype)initWithViewController:(BaseViewController*)viewController
{
    self = [self init];
    if (self) {
        _viewController = viewController;
    }
    return self;
}

- (NSMutableDictionary*)params
{
    if (!_params) {
        _params = [NSMutableDictionary dictionary];
    }
    return _params;
}


- (DBHelper*)dbService{
    if (!_dbService) {
        _dbService = [DBHelper sharedDBHelper];
    }
    return _dbService;
}

- (HttpManagerCenter *)httpService
{
    if (!_httpService) {
        _httpService = [HttpManagerCenter sharedHttpManager];
    }
    return _httpService;
}

- (void)initialize {
    
}

- (void)showRequestErrorMessage:(BaseModel*)model
{
    [self.viewController showRequestErrorMessage:model];
}

- (void)dealloc
{
    NSLog(@"===============viewModel dealloc============%@",self);
}
@end
