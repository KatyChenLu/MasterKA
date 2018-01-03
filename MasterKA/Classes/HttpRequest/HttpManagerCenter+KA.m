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
- (RACSignal *)getKAOrderListsPage:(NSString *)page pageSize:(NSString *)page_size resultClass:(Class)resultClass {
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:page forKey:@"page"];
    [params setObjectNotNull:page_size forKey:@"page_size"];
    
    return [self doRacPost:@"c=ika&a=order_lists" parameters:params resultClass:resultClass];
}
-(RACSignal *)getKAOrderDetailWithOid:(NSString *)oid orderStatus:(NSString *)order_status resultClass:(Class)resultClass {
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:oid forKey:@"oid"];
    [params setObjectNotNull:order_status forKey:@"order_status"];
    
    return [self doRacPost:@"c=ika&a=order_detail" parameters:params resultClass:resultClass];
}
-(RACSignal *)getActivityInviteWithOid:(NSString *)oid orderStatus:(NSString *)order_status resultClass:(Class)resultClass {
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:oid forKey:@"oid"];
    [params setObjectNotNull:order_status forKey:@"order_status"];
    
    return [self doRacPost:@"c=ika&a=activity_invite" parameters:params resultClass:resultClass];
}
- (RACSignal*)queryKAUserCenterWith:(Class)resultClass {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    return [self doRacPost:@"c=ika&a=user_center" parameters:params resultClass:resultClass];
}
-(RACSignal *)addCustomRequirement:(NSString *)ka_course_id groupStartTime:(NSString *)group_start_time peopleNum:(NSString *)people_num groupType:(NSString *)group_type courseTime:(NSString *)course_time coursePrice:(NSString *)course_price mobile:(NSString *)mobile mark:(NSString *)mark resultClass:(Class)resultClass {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:ka_course_id forKey:@"ka_course_id"];
    [params setObjectNotNull:group_start_time forKey:@"group_start_time"];
    [params setObjectNotNull:people_num forKey:@"people_num"];
    [params setObjectNotNull:group_type forKey:@"group_type"];
    [params setObjectNotNull:course_time forKey:@"course_time"];
    [params setObjectNotNull:course_price forKey:@"course_price"];
    [params setObjectNotNull:mobile forKey:@"mobile"];
    [params setObjectNotNull:mark forKey:@"mark"];
    
    return [self doRacPost:@"c=ika&a=requirement_add" parameters:params resultClass:resultClass];
}
-(RACSignal *)kaCourseDetail:(NSString *)index_article_id resultClass:(Class)resultClass {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:index_article_id forKey:@"ka_course_id"];
    
    return [self doRacPost:@"c=ika&a=course_detail" parameters:params resultClass:resultClass];
}
- (RACSignal *)searchCourseWithKeywords:(NSString *)keywords page:(NSString *)page pageSize:(NSString *)page_size resultClass:(Class)resultClass {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:keywords forKey:@"keywords"];
    [params setObjectNotNull:page forKey:@"page"];
    [params setObjectNotNull:page_size forKey:@"page_size"];
    
    return [self doRacPost:@"c=ika&a=course_search" parameters:params resultClass:resultClass];
}
- (RACSignal *)getCourseScenesListWithID:(NSString *)course_scenes_id peopleMin:(NSString *)people_num_min peopleMax:(NSString *)people_num_max priceMin:(NSString *)course_price_min priceMax:(NSString *)course_price_max timeMin:(NSString *)course_time_min timeMax:(NSString *)course_time_max page:(NSString *)page pageSize:(NSString *)page_size resultClass:(Class)resultClass {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:course_scenes_id forKey:@"course_scenes_id"];
    [params setObjectNotNull:people_num_min forKey:@"people_num_min"];
    [params setObjectNotNull:people_num_max forKey:@"people_num_max"];
    [params setObjectNotNull:course_price_min forKey:@"course_price_min"];
    [params setObjectNotNull:course_price_max forKey:@"course_price_max"];
    [params setObjectNotNull:course_time_min forKey:@"course_time_min"];
    [params setObjectNotNull:course_time_max forKey:@"course_time_max"];
    [params setObjectNotNull:page forKey:@"page"];
    [params setObjectNotNull:page_size forKey:@"page_size"];
    
    return [self doRacPost:@"c=ika&a=course_scenes_list" parameters:params resultClass:resultClass];
}
- (RACSignal *)addLikeCource:(NSString *)ka_course_id resultClass:(Class)resultClass {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:ka_course_id forKey:@"ka_course_id"];
    
    return [self doRacPost:@"c=ika&a=course_like" parameters:params resultClass:resultClass];
}
- (RACSignal *)cancelLikeCource:(NSString *)ka_course_id resultClass:(Class)resultClass {
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:ka_course_id forKey:@"ka_course_id"];
    
    return [self doRacPost:@"c=ika&a=course_cancel_like" parameters:params resultClass:resultClass];
}
- (RACSignal *)getLikeListsPage:(NSString *)page pageSize:(NSString *)page_size resultClass:(Class)resultClass {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:page forKey:@"page"];
    [params setObjectNotNull:page_size forKey:@"page_size"];
    
    return [self doRacPost:@"c=ika&a=get_likes" parameters:params resultClass:resultClass];
}
-(RACSignal *)queryMomentList:(NSString *)page pageSize:(NSString *)page_size resultClass:(Class)resultClass {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:page forKey:@"page"];
    [params setObjectNotNull:page_size forKey:@"page_size"];
    
    return [self doRacPost:@"c=ika&a=moment_list" parameters:params resultClass:resultClass];
}
-(RACSignal *)momentDetail:(NSString *)moment_id resultClass:(Class)resultClass {
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:moment_id forKey:@"moment_id"];
    
    return [self doRacPost:@"c=ika&a=moment_detail" parameters:params resultClass:resultClass];
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
- (RACSignal *)getItemUserListsWithItemId:(NSString *)item_id Page:(NSString *)page pageSize:(NSString *)page_size resultClass:(Class)resultClass {
     NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:item_id forKey:@"item_id"];
    [params setObjectNotNull:page forKey:@"page"];
    [params setObjectNotNull:page_size forKey:@"page_size"];
    
    return [self doRacPost:@"c=ika&a=item_user_lists" parameters:params resultClass:resultClass];
}
@end
