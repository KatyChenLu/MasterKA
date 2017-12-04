//
//  UITextField+RACKeyboardSupport.m
//  MasterKA
//
//  Created by jinghao on 16/6/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "UITextField+RACKeyboardSupport.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/NSObject+RACDescription.h>
#import <ReactiveCocoa/RACDelegateProxy.h>

@implementation UITextField (RACKeyboardSupport)

static void RACUseDelegateProxy(UITextField *self)
{
    if (self.delegate == self.rac_delegateProxy) return;
    
    self.rac_delegateProxy.rac_proxiedDelegate = self.delegate;
    self.delegate = (id)self.rac_delegateProxy;
}

- (RACDelegateProxy *)rac_delegateProxy
{
    RACDelegateProxy *proxy = objc_getAssociatedObject(self, _cmd);
    if (proxy == nil) {
        proxy = [[RACDelegateProxy alloc] initWithProtocol:@protocol(UITextFieldDelegate)];
        objc_setAssociatedObject(self, _cmd, proxy, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return proxy;
}

- (RACSignal *)rac_keyboardReturnSignal
{
    @weakify(self);
    RACSignal *signal = [[[[RACSignal
                            defer:^{
                                @strongify(self);
                                return [RACSignal return:RACTuplePack(self)];
                            }]
                           concat:[self.rac_delegateProxy signalForSelector:@selector(textFieldShouldReturn:)]]
                          takeUntil:self.rac_willDeallocSignal]
                         setNameWithFormat:@"%@ -rac_keyboardReturnSignal", [self rac_description]];
    
    RACUseDelegateProxy(self);
    
    return signal;
}
@end
