//
//  HttpManagerCenter+Home.m
//  MasterKA
//
//  Created by 余伟 on 16/10/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "HttpManagerCenter+Home.h"

@implementation HttpManagerCenter (Home)



- (RACSignal*)queryMasterPage:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:page forKey:@"page"];
    [params setObjectNotNull:page_size forKey:@"page_size"];
    
    return [self doRacPost:@"c=iarticle&a=home_list" parameters:params resultClass:resultClass];
}


- (RACSignal*)queryArticleUserCategory_list:(NSString *)usercategory_id  page:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:usercategory_id forKey:@"usercategory_id"];
    [params setObjectNotNull:page forKey:@"page"];
    [params setObjectNotNull:page_size forKey:@"page_size"];
    
    return [self doRacPost:@"c=iarticle&a=usercategory_list" parameters:params resultClass:resultClass];
}

- (RACSignal*)queryArticleTopic:(NSString *)topic_id  page:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:topic_id forKey:@"topic_id"];
    [params setObjectNotNull:page forKey:@"page"];
    [params setObjectNotNull:page_size forKey:@"page_size"];
    
    return [self doRacPost:@"c=iarticle&a=topic_list" parameters:params resultClass:resultClass];

}


- (RACSignal*)queryUserCategory_list:(NSString *)usercategory_id  page:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:usercategory_id forKey:@"usercategory_id"];
    [params setObjectNotNull:page forKey:@"page"];
    [params setObjectNotNull:page_size forKey:@"page_size"];
    
    return [self doRacPost:@"c=icourse&a=usercategory_list" parameters:params resultClass:resultClass];
}

- (RACSignal*)detemineLike:(NSString *)index_article_id resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:index_article_id forKey:@"index_article_id"];
  
    return [self doRacPost:@"c=iarticle&a=like" parameters:params resultClass:resultClass];
}


- (RACSignal*)cancleLike:(NSString *)index_article_id resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:index_article_id forKey:@"index_article_id"];
    
    return [self doRacPost:@"c=iarticle&a=cancel_like" parameters:params resultClass:resultClass];
}

- (RACSignal*)shareArticle:(NSString *)index_article_id resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:index_article_id forKey:@"index_article_id"];
    
    return [self doRacPost:@"c=iarticle&a=share" parameters:params resultClass:resultClass];
    
}

- (RACSignal*)queryTopic_list:(NSString *)topic_id  page:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass

{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:topic_id forKey:@"topic_id"];
    [params setObjectNotNull:page forKey:@"page"];
    [params setObjectNotNull:page_size forKey:@"page_size"];
    
    return [self doRacPost:@"c=iarticle&a=topic_list" parameters:params resultClass:resultClass];

}

- (RACSignal*)articleDetail:(NSString *)index_article_id resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:index_article_id forKey:@"index_article_id"];
    
    return [self doRacPost:@"c=iarticle&a=detail" parameters:params resultClass:resultClass];
    
}


- (RACSignal*)getComment:(NSString *)index_article_id  page:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:index_article_id forKey:@"index_article_id"];
    [params setObjectNotNull:page forKey:@"page"];
    [params setObjectNotNull:page_size forKey:@"page_size"];
    
    return [self doRacPost:@"c=iarticle&a=comment_list" parameters:params resultClass:resultClass];

    
}

- (RACSignal*)addCommentsReplyCommentId:(NSString*)comment_id otherUserId:(NSString *)otherUserId content:(NSString*)content resultClass:(Class)resultClass
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:comment_id forKey:@"comment_id"];
    [params setObjectNotNull:otherUserId forKey:@"other_uid"];
    [params setObjectNotNull:content forKey:@"content"];
    
    return [self doRacPost:@"c=iarticle&a=comment_reply" parameters:params resultClass:resultClass];
    
}


- (RACSignal*)addCommentsArticle_id:(NSString *)index_article_id  content:(NSString*)content resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:index_article_id forKey:@"index_article_id"];
    [params setObjectNotNull:content forKey:@"content"];
    
    return [self doRacPost:@"c=iarticle&a=comment_add" parameters:params resultClass:resultClass];
    
}



- (RACSignal*)getLikeList:(NSString *)index_article_id  page:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:index_article_id forKey:@"index_article_id"];
    [params setObjectNotNull:page forKey:@"page"];
    [params setObjectNotNull:page_size forKey:@"page_size"];
    
    return [self doRacPost:@"c=iarticle&a=like_list" parameters:params resultClass:resultClass];
    
}


- (RACSignal*)launchCourseWithHid:(NSString *)hid status:(NSString *)status resultClass:(Class)resultClass;
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:hid forKey:@"hid"];
    [params setObjectNotNull:status forKey:@"status"];

    
    return [self doRacPost:@"c=iarticle&a=set_recommand_record_status" parameters:params resultClass:resultClass];
    
}

- (RACSignal*)bindCourseWithHid:(NSString *)hid resultClass:(Class)resultClass;
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:hid forKey:@"hid"];
    
     return [self doRacPost:@"c=iarticle&a=get_user_coupon" parameters:params resultClass:resultClass];
}

- (RACSignal*)totalAds_data_id:(NSString *)ads_data_id index:(NSString*)index resultClass:(Class)resultClass;
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:ads_data_id forKey:@"ads_data_id"];

    [params setObjectNotNull:index forKey:@"index"];

    return [self doRacPost:@"c=ipublic&a=add_ads_view" parameters:params resultClass:resultClass];
    
}

@end
