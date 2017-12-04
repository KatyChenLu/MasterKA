//
//  UIViewController+URL.h
//  MasterKA
//
//  Created by jinghao on 16/1/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (URL)
@property (strong, nonatomic) NSDictionary                              *params;
@property (strong, nonatomic) NSDictionary                              *query;
@property (strong, nonatomic) NSURL                                     *url;

- (id)initWithURL:(NSURL *)aUrl;
- (id)initWithURL:(NSURL *)aUrl query:(NSDictionary *)query;

@end
