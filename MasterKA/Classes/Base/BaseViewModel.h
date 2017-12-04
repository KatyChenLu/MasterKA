//
//  BaseViewModel.h
//  MasterKA
//
//  Created by jinghao on 15/12/11.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBHelper.h"
#import "HttpManagerCenter.h"
#import "RVMViewModel.h"
@class BaseViewController;

@interface BaseViewModel : RVMViewModel //


@property (nonatomic,strong) NSString *url;

/**
 *  请求参数
 */
@property (nonatomic,strong) NSMutableDictionary *params;
/**
 *  viewControoler 标题
 */
@property (nonatomic, copy) NSString *title;

@property (nonatomic,weak,readonly)DBHelper *dbService;

@property (nonatomic,weak,readonly)HttpManagerCenter *httpService;


@property (nonatomic, strong, readonly) RACSubject *errors;

@property (nonatomic, strong, readonly) RACSubject *willDisappearSignal;

@property (nonatomic,weak,readonly)BaseViewController *viewController;

- (void)initialize;

- (instancetype)initWithViewController:(BaseViewController*)viewController;

- (void)showRequestErrorMessage:(BaseModel*)model;

@end
