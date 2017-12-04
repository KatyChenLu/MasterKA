//
//  HttpManagerCenter+Share.m
//  MasterKA
//
//  Created by jinghao on 16/4/18.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "HttpManagerCenter+Share.h"

@implementation HttpManagerCenter (Share)

//------------------达人模块接口-----------------------

- (RACSignal*)queryMasterIndex:(Class)resultClass{
 
    NSMutableDictionary *params = [NSMutableDictionary new];
    return [self doRacPost:@"c=ishare&a=master_start" parameters:params resultClass:resultClass];
}

- (RACSignal*)ReportType:(NSString *)type shareId:(NSString *)shareId resultClass:(Class)resultClass
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:type  forKey:@"type"];
    [params setObjectNotNull:shareId forKey:@"share_id"];
    
    return [self doRacPost:@"c=ishare&a=report" parameters:params resultClass:resultClass];
    
}


- (RACSignal*)queryMasterShareByTypeId:(NSString *)typeId page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:typeId forKey:@"category_id"];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=ishare&a=master_list" parameters:params resultClass:resultClass];
}

- (RACSignal*)queryMasterShareByTag:(NSString *)tagId page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:tagId forKey:@"tag_id"];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=ishare&a=master_list_tag" parameters:params resultClass:resultClass];
}
//find
-(RACSignal*)RequestForSearchData:(NSString*)type page:(NSString*)page page_size:(NSString*)page_size resultClass:(Class)resultClass{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:type forKey:@"type"];
    [params setObjectNotNull:page forKey:@"page"];
    [params setObjectNotNull:page_size forKey:@"page_size"];
    return [self doRacPost:@"c=ishare&a=discover" parameters:params resultClass:resultClass];
}


- (RACSignal*)queryMasterSHareDetailById:(NSString*)shareId resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:shareId forKey:@"share_id"];
    return [self doRacPost:@"c=ishare&a=master_detail" parameters:params resultClass:resultClass];
}


- (RACSignal*)queryMasterComments:(NSString*)share_id page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:share_id forKey:@"share_id"];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=ishare&a=master_comment_list" parameters:params resultClass:resultClass];
    
}

- (RACSignal*)addMasterComments:(NSString*)share_id content:(NSString*)content resultClass:(Class)resultClass{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:share_id forKey:@"share_id"];
    [params setObjectNotNull:content forKey:@"content"];
    return [self doRacPost:@"c=ishare&a=master_comment_add" parameters:params resultClass:resultClass];
    
}

- (RACSignal*)addMasterCommentsReply:(NSString*)comment_id otherUserId:(NSString *)otherUserId content:(NSString*)content resultClass:(Class)resultClass{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:comment_id forKey:@"comment_id"];
    [params setObjectNotNull:content forKey:@"content"];
    [params setObjectNotNull:otherUserId forKey:@"other_uid"];
    return [self doRacPost:@"c=ishare&a=master_comment_reply" parameters:params resultClass:resultClass];
    
}

- (RACSignal*)masterShareLike:(NSString*)share_id resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:share_id forKey:@"share_id"];
    return [self doRacPost:@"c=ishare&a=master_like" parameters:params resultClass:resultClass];
    
}


- (RACSignal*)masterShareCancelLike:(NSString*)share_id resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:share_id forKey:@"share_id"];
    return [self doRacPost:@"c=ishare&a=cancel_master_like" parameters:params resultClass:resultClass];
}


- (RACSignal*)queryCommentList:(BOOL)isMaster shareId:(NSString *)share_id page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass
{
    if(isMaster){
        return [self queryMasterComments:share_id page:page pageSize:pageSize resultClass:resultClass];
    }else{
        return [self queryUserComments:share_id page:page pageSize:pageSize resultClass:resultClass];
    }
}


- (RACSignal*)addComments:(BOOL)isMaster shareId:(NSString*)share_id content:(NSString*)content resultClass:(Class)resultClass
{
    if(isMaster){
        return [self addMasterComments:share_id content:content resultClass:resultClass];
    }else{
        return [self addUserComments:share_id content:content resultClass:resultClass];
    }
}

- (RACSignal*)addCommentsReply:(BOOL)isMaster commentId:(NSString*)comment_id otherUserId:(NSString *)otherUserId content:(NSString*)content resultClass:(Class)resultClass
{
    if(isMaster){
        return [self addMasterCommentsReply:comment_id otherUserId:otherUserId  content:content resultClass:resultClass];
    }else{
        return [self addUserCommentsReply:comment_id otherUserId:otherUserId content:content resultClass:resultClass];
    }
}

- (RACSignal*)addMasterShare:(NSString*)media_type category_id:(NSString*)category_id tag_name:(NSString*)tag_name course_id:(NSString*)course_id title:(NSString*)title content:(NSString*)content cover:(NSString*)cover media_list:(NSArray*)media_list resultClass:(Class)resultClass{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:media_type forKey:@"media_type"];
    [params setObjectNotNull:category_id forKey:@"category_id"];
    [params setObjectNotNull:tag_name forKey:@"tag_name"];
    [params setObjectNotNull:course_id forKey:@"course_id"];
    [params setObjectNotNull:title forKey:@"title"];
    [params setObjectNotNull:content forKey:@"content"];
    [params setObjectNotNull:cover forKey:@"cover"];
    [params setObjectNotNull:media_list forKey:@"media_list"];
    return [self doRacPost:@"c=ishare&a=master_add" parameters:params resultClass:resultClass];
    
}

- (RACSignal*)searchMasterShareByKeywords:(NSString*)keywords page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:keywords forKey:@"keywords"];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=ishare&a=search_by_keywords" parameters:params resultClass:resultClass];
}


- (RACSignal*)searchUserByKeywords:(NSString*)keywords page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:keywords forKey:@"keywords"];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=iuser&a=search_by_keywords" parameters:params resultClass:resultClass];
}





//------------------牛人模块接口-----------------------



- (RACSignal*)queryUserShare:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=ishare&a=user_list" parameters:params resultClass:resultClass];

}

- (RACSignal*)queryUserShareDetail:(NSString*)share_id resultClass:(Class)resultClass{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:share_id forKey:@"share_id"];
    return [self doRacPost:@"c=ishare&a=user_detail" parameters:params resultClass:resultClass];
    
}

- (RACSignal*)queryUserComments:(NSString*)share_id page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:share_id forKey:@"share_id"];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=ishare&a=user_comment_list" parameters:params resultClass:resultClass];
    
}

- (RACSignal*)addUserComments:(NSString*)share_id content:(NSString*)content resultClass:(Class)resultClass{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:share_id forKey:@"share_id"];
    [params setObjectNotNull:content forKey:@"content"];
    return [self doRacPost:@"c=ishare&a=user_comment_add" parameters:params resultClass:resultClass];
    
}

- (RACSignal*)addUserCommentsReply:(NSString*)comment_id otherUserId:(NSString *)otherUserId content:(NSString*)content resultClass:(Class)resultClass{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:comment_id forKey:@"comment_id"];
    [params setObjectNotNull:content forKey:@"content"];
    [params setObjectNotNull:otherUserId forKey:@"other_uid"];
    return [self doRacPost:@"c=ishare&a=user_comment_reply" parameters:params resultClass:resultClass];
    
}

- (RACSignal*)userShareLike:(NSString*)share_id resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:share_id forKey:@"share_id"];
    return [self doRacPost:@"c=ishare&a=user_like" parameters:params resultClass:resultClass];

}


- (RACSignal*)userShareCancelLike:(NSString*)share_id resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:share_id forKey:@"share_id"];
    return [self doRacPost:@"c=ishare&a=cancel_user_like" parameters:params resultClass:resultClass];
}


- (RACSignal*)addUserShare:(NSString*)media_type content:(NSString*)content url:(NSString*)url course_id:(NSString*)course_id  orderId:(NSString*)order_Id province:(NSString*)province city:(NSString*)city address:(NSString*)address longitude:(NSString*)longitude latitude:(NSString*)latitude is_show_position:(NSString*)is_show_position thumb:(NSString*)thumb resultClass:(Class)resultClass{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:media_type forKey:@"media_type"];
    [params setObjectNotNull:content forKey:@"content"];
    [params setObjectNotNull:url forKey:@"url"];
    [params setObjectNotNull:course_id forKey:@"course_id"];
    [params setObjectNotNull:order_Id forKey:@"order_id"];
    [params setObjectNotNull:province forKey:@"province"];
    [params setObjectNotNull:city forKey:@"city"];
    [params setObjectNotNull:address forKey:@"address"];
    [params setObjectNotNull:longitude forKey:@"longitude"];
    [params setObjectNotNull:latitude forKey:@"latitude"];
    [params setObjectNotNull:is_show_position forKey:@"is_show_position"];
    [params setObjectNotNull:thumb forKey:@"thumb"];
    return [self doRacPost:@"c=ishare&a=user_add" parameters:params resultClass:resultClass];
    
}

- (RACSignal*)removeUserShare:(NSString*)share_id resultClass:(Class)resultClass{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:share_id forKey:@"share_id"];
    return [self doRacPost:@"c=ishare&a=user_del" parameters:params resultClass:resultClass];

    
}



- (RACSignal*)removeMasterShare:(NSString*)share_id resultClass:(Class)resultClass{
   
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:share_id forKey:@"share_id"];
    return [self doRacPost:@"c=ishare&a=master_del" parameters:params resultClass:resultClass];
    
}
////////
/////粉丝列表
////////
- (RACSignal*)getMasterFans:(NSString *)shareId page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:shareId forKey:@"share_id"];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=ishare&a=master_like_list" parameters:params resultClass:resultClass];
}

- (RACSignal*)getUsersFans:(NSString *)shareId page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:shareId forKey:@"share_id"];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=ishare&a=user_like_list" parameters:params resultClass:resultClass];
}

- (RACSignal*)totalMaster_id:(NSString *)master_id  resultClass:(Class)resultClass;
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:master_id forKey:@"master_id"];
  
    return [self doRacPost:@"c=ishare&a=recommend_master_count_update" parameters:params resultClass:resultClass];

    
}


@end
