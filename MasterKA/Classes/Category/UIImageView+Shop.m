//
//  UIImageView+Shop.m
//  MasterKA
//
//  Created by 余伟 on 16/8/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#define ImageStrKey  @"imageStr"

#import "UIImageView+Shop.h"
#import <objc/runtime.h>

@implementation UIImageView (Shop)




-(void)setImageStr:(NSString *)imageStr
{
    
    objc_setAssociatedObject(self, ImageStrKey, imageStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}


-(NSString *)imageStr
{
    
    return  objc_getAssociatedObject(self, ImageStrKey);
    
}





@end
