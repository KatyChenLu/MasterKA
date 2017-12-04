//
//  DBHelper.h
//  shidiankeji
//
//  Created by jinghao on 15/11/26.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBBaseModel.h"
@interface DBHelper : NSObject
+ (instancetype)sharedDBHelper;
+ (void)saveModel:(DBBaseModel*)model;

- (void)insertModel:(DBBaseModel*)model;
- (void)insertModelArray:(NSArray*)modelArray;
- (void)deleteClass:(Class)className;

@end
