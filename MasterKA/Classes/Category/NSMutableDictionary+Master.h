//
//  NSMutableDictionary+Master.h
//  MasterKA
//
//  Created by jinghao on 16/4/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Master)
- (void)setObjectNotNull:(id)anObject forKey:(id<NSCopying>)aKey;
@end
