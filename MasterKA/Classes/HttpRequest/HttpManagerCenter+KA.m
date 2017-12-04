//
//  HttpManagerCenter+KA.m
//  MasterKA
//
//  Created by ChenLu on 2017/11/30.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "HttpManagerCenter+KA.h"

@implementation HttpManagerCenter (KA)
- (RACSignal *)getHomeDataListsPage:(NSString *)page pageSize:(NSString *)page_size resultClass:(Class)resultClass {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:page forKey:@"page"];
    [params setObjectNotNull:page_size forKey:@"page_size"];
    
    return [self doRacPost:@"c=ika&a=app_index" parameters:params resultClass:resultClass];
}




- (RACSignal *)queryKAFieldListPage:(NSString *)page pageSize:(NSString *)page_size resultClass:(Class)resultClass {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:page forKey:@"page"];
    [params setObjectNotNull:page_size forKey:@"page_size"];
    
    return [self doRacPost:@"c=ika&a=field_list" parameters:params resultClass:resultClass];
}
- (RACSignal *)fieldDetail:(NSString *)field_id resultClass:(Class)resultClass {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:field_id forKey:@"field_id"];
    
    return [self doRacPost:@"c=ika&a=field_detail" parameters:params resultClass:resultClass];
}
- (RACSignal *)getVoteCartListsPage:(NSString *)page pageSize:(NSString *)page_size resultClass:(Class)resultClass {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:page forKey:@"page"];
    [params setObjectNotNull:page_size forKey:@"page_size"];
    
    return [self doRacPost:@"c=ika&a=vote_cart_lists" parameters:params resultClass:resultClass];
}
- (RACSignal *)mineVoteListsPage:(NSString *)page pageSize:(NSString *)page_size resultClass:(Class)resultClass {
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:page forKey:@"page"];
    [params setObjectNotNull:page_size forKey:@"page_size"];
    
    return [self doRacPost:@"c=ika&a=vote_mine_lists" parameters:params resultClass:resultClass];
}
- (RACSignal *)addVoteCart:(NSString *)ka_course_id resultClass:(Class)resultClass {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:ka_course_id forKey:@"ka_course_id"];
    
    return [self doRacPost:@"c=ika&a=vote_cart_add" parameters:params resultClass:resultClass];
}
- (RACSignal *)cancelVoteCart:(NSString *)ka_course_id resultClass:(Class)resultClass {
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:ka_course_id forKey:@"ka_course_id"];
    
    return [self doRacPost:@"c=ika&a=vote_cart_cancel" parameters:params resultClass:resultClass];
}
- (RACSignal *)postVoteWithTitle:(NSString *)vote_title desc:(NSString *)vote_desc endDays:(NSString *)end_days endHours:(NSString *)end_hours courseIds:(NSArray *)ka_course_ids resultClass:(Class)resultClass {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:vote_title forKey:@"vote_title"];
    [params setObjectNotNull:vote_desc forKey:@"vote_desc"];
    [params setObjectNotNull:end_days forKey:@"end_days"];
    [params setObjectNotNull:end_hours forKey:@"end_hours"];
    [params setObjectNotNull:ka_course_ids forKey:@"ka_course_ids"];

    return [self doRacPost:@"c=ika&a=vote_add" parameters:params resultClass:resultClass];
}
-(RACSignal *)voteItemDetail:(NSString *)vote_id resultClass:(Class)resultClass {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:vote_id forKey:@"vote_id"];
    
    return [self doRacPost:@"c=ika&a=vote_item_detail" parameters:params resultClass:resultClass];
}
@end
