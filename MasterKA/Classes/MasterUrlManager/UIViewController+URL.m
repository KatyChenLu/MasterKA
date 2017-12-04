//
//  UIViewController+URL.m
//  MasterKA
//
//  Created by jinghao on 16/1/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "UIViewController+URL.h"
#import "MasterUrlManager.h"

@implementation UIViewController (URL)

- (void)setUrl:(NSURL *)url{
    self.params = [url params];
    objc_setAssociatedObject(self, @selector(url), url, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSURL*)url
{
    return objc_getAssociatedObject(self, @selector(url));
}

- (void)setParams:(NSDictionary *)params
{
    objc_setAssociatedObject(self, @selector(params), params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary*)params
{
    return objc_getAssociatedObject(self, @selector(params));
}

- (void)setQuery:(NSDictionary *)query
{
    objc_setAssociatedObject(self, @selector(query), query, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (NSDictionary*)query
{
    return objc_getAssociatedObject(self, @selector(query));
}

- (id)initWithURL:(NSURL *)aUrl
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.url = aUrl;
    }
    return self;
}

- (id)initWithURL:(NSURL *)aUrl query:(NSDictionary *)aQuery {
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        self.url = aUrl;
        self.query = aQuery;
    }
    return self;
}

- (void)newViewDidAppear:(BOOL)animated
{
    if ([self isKindOfClass:[UINavigationController class]]) {
        [MasterUrlManager shareMasterUrlManager].currentNav = (UINavigationController *)self;
    }
    else if ([self isKindOfClass:[UITabBarController class]]) {
        [MasterUrlManager shareMasterUrlManager].currentTab = (UITabBarController *)self;
    }
    else if ([self isKindOfClass:[UIViewController class]]) {
        [MasterUrlManager shareMasterUrlManager].currentVC = self;
    }
    [self originViewDidAppear:animated];
}

- (void)originViewDidAppear:(BOOL)animated
{
    
}

+ (void)load
{
    Method oriDidAppear = class_getInstanceMethod([UIViewController class],
                                                  @selector(viewDidAppear:));
    IMP oriDidAppearImp = method_getImplementation(oriDidAppear);
    Method newDidAppear = class_getInstanceMethod([UIViewController class],
                                                  @selector(newViewDidAppear:));
    IMP newDidAppearImp = method_getImplementation(newDidAppear);
    class_replaceMethod([UIViewController class], @selector(originViewDidAppear:),
                        oriDidAppearImp, method_getTypeEncoding(oriDidAppear));
    class_replaceMethod([UIViewController class], @selector(viewDidAppear:),
                        newDidAppearImp, method_getTypeEncoding(oriDidAppear));
}

@end
