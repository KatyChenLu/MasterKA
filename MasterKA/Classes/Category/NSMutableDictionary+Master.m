//
//  NSMutableDictionary+Master.m
//  MasterKA
//
//  Created by jinghao on 16/4/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "NSMutableDictionary+Master.h"

@implementation NSMutableDictionary (Master)
- (void)setObjectNotNull:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject && aKey) {
        [self setObject:anObject forKey:aKey];
    }
}
@end
