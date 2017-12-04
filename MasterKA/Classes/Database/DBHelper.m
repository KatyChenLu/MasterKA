//
//  DBHelper.m
//  shidiankeji
//
//  Created by jinghao on 15/11/26.
//  Copyright © 2015年 jinghao. All rights reserved.
//

#import "DBHelper.h"
#import "MJExtension.h"
#import <Realm/Realm.h>

static NSString* APP_DATABASE_NAME = @"masterDB";
static NSInteger APP_DATABASE_VERSION = 3;//升级数据库时修改此处

@implementation DBHelper

+ (instancetype)sharedDBHelper{
    static DBHelper *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[DBHelper alloc] init];
    });
    
    return _sharedClient;
}

- (id)init{
    if (self=[super init]) {
        [self configRealm];
    }
    return self;
}

- (void)configRealm{
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    
    // Use the default directory, but replace the filename with the username
    config.path = [[[config.path stringByDeletingLastPathComponent]
                    stringByAppendingPathComponent:APP_DATABASE_NAME]
                   stringByAppendingPathExtension:@"realm"];
    NSLog(@"db path %@",config.path);
    config.schemaVersion = APP_DATABASE_VERSION;
    config.migrationBlock = [self checkDataBaseVersion];
    // Set this as the configuration used for the default Realm
    [RLMRealmConfiguration setDefaultConfiguration:config];
}

- (RLMMigrationBlock)checkDataBaseVersion{
    RLMMigrationBlock migrationBlock  = ^(RLMMigration *migration, uint64_t oldSchemaVersion) {
        if (oldSchemaVersion<2) {
            
           
        }
        
        if (oldSchemaVersion < 3) {
            
        }
        
    };
 
     return migrationBlock;
}

#pragma mark -- public 

- (void)insertModel:(DBBaseModel*)model
{
    RLMRealm *realm = RLMRealm.defaultRealm;
    if([model observationInfo]){
        DBBaseModel *model1 = [[model class] objectWithKeyValues:model.keyValues];
        [realm transactionWithBlock:^{
            [realm addObject:model1];
        }];
    }else{
        [realm transactionWithBlock:^{
            [realm addObject:model];
        }];
    }
   
}

- (void)insertModelArray:(NSArray*)modelArray
{
    RLMRealm *realm = RLMRealm.defaultRealm;
    [realm transactionWithBlock:^{
        [realm addObjects:modelArray];
    }];
}

- (void)deleteClass:(Class)className
{
    RLMRealm *realm = RLMRealm.defaultRealm;
    [realm transactionWithBlock:^{
        [realm deleteObjects:[className allObjects]];
    }];
}

+ (void)saveModel:(DBBaseModel*)model
{
    [[DBHelper sharedDBHelper] insertModel:model];
}

@end
