//
//  UITextField+RACKeyboardSupport.h
//  MasterKA
//
//  Created by jinghao on 16/6/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (RACKeyboardSupport)
- (RACSignal *)rac_keyboardReturnSignal;
@end
