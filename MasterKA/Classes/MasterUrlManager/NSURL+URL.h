//
//  NSURL+URL.h
//  MasterKA
//
//  Created by jinghao on 16/1/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (URL)
- (NSURL *)addParams:(NSDictionary*)params;
- (NSDictionary *)params;
- (NSString *)protocol;
@end
