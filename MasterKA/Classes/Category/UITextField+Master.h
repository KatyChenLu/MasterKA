//
//  UITextField+Master.h
//  MasterKA
//
//  Created by jinghao on 16/5/19.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Master)
@property (nonatomic)NSInteger maxLenght;//字符最大长度
@property (nonatomic,strong)NSArray* digitsChars;//字符最大长度


- (void)setLeftPadding:(NSInteger)padding;

@end
