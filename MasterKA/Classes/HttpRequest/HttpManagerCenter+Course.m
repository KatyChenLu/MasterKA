//
//  HttpManagerCenter+Course.m
//  MasterKA
//
//  Created by jinghao on 16/4/18.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "HttpManagerCenter+Course.h"

@implementation HttpManagerCenter (Course)

- (RACSignal*)searchCourseByKeywords:(NSString*)keywords page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:keywords forKey:@"keywords"];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=icourse&a=search_by_keywords" parameters:params resultClass:resultClass];
}

- (RACSignal*)queryCourseIndex:(Class)resultClass{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    return [self doRacPost:@"c=icourse&a=course_start" parameters:params resultClass:resultClass];
}

- (RACSignal*)getCategoryList:(NSString*)category_id order_type:(NSString*)order_type select_type:(NSString*)select_type page:(NSString*)page page_size:(NSString*)page_size  resultClass:(Class)resultClass{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:category_id forKey:@"category_id"];
    [params setObjectNotNull:order_type forKey:@"order_type"];
    [params setObjectNotNull:select_type forKey:@"select_type"];
    [params setObjectNotNull:page forKey:@"page"];
    [params setObjectNotNull:page_size forKey:@"page_size"];
    
    return [self doRacPost:@"c=icourse&a=category_list" parameters:params resultClass:resultClass];
    
}

//*酱油卡课程列表
- (RACSignal*)getJiangYouCardList:(NSString*)card_id page:(NSString*)page page_size:(NSString*)page_size    resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:card_id forKey:@"course_id"];
    [params setObjectNotNull:page forKey:@"page"];
    [params setObjectNotNull:page_size forKey:@"page_size"];
    return [self doRacPost:@"c=icard&a=course_list" parameters:params resultClass:resultClass];

}
- (RACSignal*)getCourseDetail:(NSString *)courseId resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:courseId forKey:@"course_id"];
    return [self doRacPost:@"c=icourse&a=detail" parameters:params resultClass:resultClass];
}
- (RACSignal*)getCourseShareBycourseId:(NSString *)courseId page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:courseId forKey:@"course_id"];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=ishare&a=course_list" parameters:params resultClass:resultClass];
}
- (RACSignal*)getStudents:(NSString *)courseId page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:courseId forKey:@"course_id"];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=icourse&a=student_list" parameters:params resultClass:resultClass];

}
- (RACSignal*)getCourseDateTimeByGroupId:(NSString*)groupId resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:groupId forKey:@"course_cfg_id"];
    return [self doRacPost:@"c=icourse&a=time_info" parameters:params resultClass:resultClass];
}

- (RACSignal*)getPayInfoForOrder:(NSString*)courseId groupId:(NSString*)groupId  groupbuy:(NSString *)groupbuy resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:courseId forKey:@"course_id"];
    [params setObjectNotNull:groupId forKey:@"course_cfg_id"];
    [params setObjectNotNull:groupbuy forKey:@"groupbuy"];
    return [self doRacPost:@"c=icourse&a=pay_info" parameters:params resultClass:resultClass];
}
- (RACSignal*)getCardDetail:(NSString*)cardId resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:cardId forKey:@"card_id"];
    return [self doRacPost:@"c=icard&a=detail" parameters:params resultClass:resultClass];
}

- (RACSignal*)sendPayInfoForOrder:(NSString*)courseId groupId:(NSString*)groupId timeId:(NSString*)timeId number:(NSInteger)number payType:(NSInteger)payType mobile:(NSString*)mobile conditionType:(NSString*)conditionType conditionId:(NSString*)conditionId useMoney:(NSString*)useMoney receiver_name:(NSString*)receiver_name receiver_address:(NSString*)receiver_address resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:courseId forKey:@"course_id"];
    [params setObjectNotNull:groupId forKey:@"course_cfg_id"];
    [params setObjectNotNull:timeId forKey:@"time_id"];
    [params setObjectNotNull:mobile forKey:@"mobile"];
    [params setObjectNotNull:receiver_name forKey:@"receiver_name"];
    [params setObjectNotNull:receiver_address forKey:@"receiver_address"];
    [params setObjectNotNull:[NSNumber numberWithInteger:number] forKey:@"num"];
    [params setObjectNotNull:[NSNumber numberWithInteger:payType] forKey:@"zf_type"];
    [params setObjectNotNull:conditionType forKey:@"condition_type"];
    [params setObjectNotNull:conditionId forKey:@"condition_id"];
    [params setObjectNotNull:useMoney forKey:@"use_money"];
    return [self doRacPost:@"c=icourse&a=buy_course" parameters:params resultClass:resultClass];
}
- (RACSignal*)collectCourse:(NSString*)courseId resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:courseId forKey:@"course_id"];
    return [self doRacPost:@"c=icourse&a=collect" parameters:params resultClass:resultClass];
}
- (RACSignal*)removeCollectCourse:(NSString*)courseId resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:courseId forKey:@"course_id"];
    return [self doRacPost:@"c=icourse&a=cancel_collect" parameters:params resultClass:resultClass];
}

- (RACSignal*)getPayInfoForCard:(NSString*)cardId resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:cardId forKey:@"card_id"];
    return [self doRacPost:@"c=icard&a=pay_info" parameters:params resultClass:resultClass];
}

- (RACSignal*)sendPayInfoForCard:(NSString*)cardId number:(NSInteger)number payType:(NSInteger)payType mobile:(NSString*)mobile conditionType:(NSString*)conditionType conditionId:(NSString*)conditionId useMoney:(NSString*)useMoney resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:cardId forKey:@"card_id"];
    [params setObjectNotNull:mobile forKey:@"mobile"];
    [params setObjectNotNull:[NSNumber numberWithInteger:number] forKey:@"num"];
    [params setObjectNotNull:[NSNumber numberWithInteger:payType] forKey:@"zf_type"];
    [params setObjectNotNull:conditionType forKey:@"condition_type"];
    [params setObjectNotNull:conditionId forKey:@"condition_id"];
    [params setObjectNotNull:useMoney forKey:@"use_money"];
    return [self doRacPost:@"c=icard&a=buy_card" parameters:params resultClass:resultClass];
}

- (RACSignal*)queryCardListWithPage:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize] forKey:@"page_size"];
    return [self doRacPost:@"c=icard&a=lists" parameters:params resultClass:resultClass];
}

- (RACSignal*)queryCourseByMasterUid:(NSString*)uid companyId:(NSString*)companyId page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:uid forKey:@"uid"];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize] forKey:@"page_size"];
    NSString *url =@"c=icourse&a=master_list";
    if (companyId && ![companyId isEmpty] && companyId.integerValue>1) {
        url =@"c=icourse&a=master_enterprise_list";
    }
    return [self doRacPost:url parameters:params resultClass:resultClass];
}


- (RACSignal*)queryCourseWithLng:(NSString *)lng AndLat:(NSString *)lat withCategoryId:(NSString *)categoryId resultClass:(Class)resultClass;
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:lng forKey:@"lng"];
    [params setObjectNotNull:lat forKey:@"lat"];
    [params setObjectNotNull:categoryId forKey:@"category_id"];
    return [self doRacPost:@"c=icourse&a=map_list" parameters:params resultClass:resultClass];

    
}
- (RACSignal*)getAskListWithCourseId:(NSString *)courseid Page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:courseid forKey:@"course_id"];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize] forKey:@"page_size"];
    return [self doRacPost:@"c=icourse&a=question_list" parameters:params resultClass:resultClass];
}
- (RACSignal *)getAnswerListWithQuestionId:(NSString *)questionId Page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:questionId forKey:@"question_id"];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize] forKey:@"page_size"];
    return [self doRacPost:@"c=icourse&a=answer_list" parameters:params resultClass:resultClass];
}
- (RACSignal *)sendQuestionAddOfCourse:(NSString *)courseId content:(NSString *)content resultClass:(Class)resultClass {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:courseId forKey:@"course_id"];
    [params setObjectNotNull:content forKey:@"content"];
    return [self doRacPost:@"c=icourse&a=question_add" parameters:params resultClass:resultClass];
}
- (RACSignal *)sendAnswerAddOfCourse:(NSString *)courseId content:(NSString *)content resultClass:(Class)resultClass {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:courseId forKey:@"question_id"];
    [params setObjectNotNull:content forKey:@"content"];
    return [self doRacPost:@"c=icourse&a=answer_add" parameters:params resultClass:resultClass];
}
@end
