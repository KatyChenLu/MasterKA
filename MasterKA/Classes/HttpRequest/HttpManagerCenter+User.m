//
//  HttpManagerCenter+User.m
//  MasterKA
//
//  Created by jinghao on 16/4/18.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "HttpManagerCenter+User.h"

@implementation HttpManagerCenter (User)

- (RACSignal*)queryUserCenterWith:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    return [self doRacPost:@"c=iuser&a=user_center" parameters:params resultClass:resultClass];
}

- (RACSignal*)queryMyFansByPage:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=iuser&a=my_fans" parameters:params resultClass:resultClass];

}
- (RACSignal*)queryMyFollowsByPage:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=iuser&a=my_follows" parameters:params resultClass:resultClass];

}

- (RACSignal*)addAttention:(NSString *)userId resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:userId forKey:@"fid"];
    return [self doRacPost:@"c=iuser&a=atten_user" parameters:params resultClass:resultClass];
}

- (RACSignal*)removeAttention:(NSString *)userId resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:userId forKey:@"fid"];
    return [self doRacPost:@"c=iuser&a=cancel_atten_user" parameters:params resultClass:resultClass];
}
- (RACSignal*)addUserLike:(NSString*)userId resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:userId forKey:@"uid_other"];
    return [self doRacPost:@"c=iuser&a=user_like" parameters:params resultClass:resultClass];
}
- (RACSignal*)removeUserLike:(NSString*)userId resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:userId forKey:@"uid_other"];
    return [self doRacPost:@"c=iuser&a=cancel_user_like" parameters:params resultClass:resultClass];
}
- (RACSignal*)modifilrUserInfo:(NSMutableDictionary *)userInfo resultClass:(Class)resultClass
{
    return [self doRacPost:@"c=iuser&a=edit_user_info" parameters:userInfo resultClass:resultClass];
}
- (RACSignal*)getScoreDetialByPage:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=iuser&a=get_score_detail" parameters:params resultClass:resultClass];
    
}
- (RACSignal*)updateHeadIma:(NSString *)imgStr resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:imgStr forKey:@"upload_data"];
    return [self doRacPost:@"c=ipublic&a=upload" parameters:params resultClass:resultClass];
}
- (RACSignal*)getMyCoupon:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=iuser&a=get_coupon" parameters:params resultClass:resultClass];
    
}
- (RACSignal*)getMyCard:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=iuser&a=get_card" parameters:params resultClass:resultClass];
    
}
- (RACSignal*)getMyShare:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=iuser&a=get_share" parameters:params resultClass:resultClass];

}
- (RACSignal*)getMyOrder:(NSString*)status page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    if(![status isEqual:@"all"]){
        [params setObjectNotNull:status forKey:@"orderStatus"];
    }
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=iuser&a=get_order_list" parameters:params resultClass:resultClass];

}
- (RACSignal*)getCourse:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=icourse&a=mpoints_list" parameters:params resultClass:resultClass];
}

- (RACSignal*)getMyCourse:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=iuser&a=get_master_courses" parameters:params resultClass:resultClass];
}

- (RACSignal*)getMyUserCourse:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=iuser&a=get_user_relation_course" parameters:params resultClass:resultClass];
}



- (RACSignal*)getOrderDetail:(NSString *)orderId mainOrderId:(NSString*)mainOrderId resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:orderId forKey:@"orderId"];
    [params setObjectNotNull:mainOrderId forKey:@"main_order_id"];
    return [self doRacPost:@"c=iuser&a=new_get_order_detail" parameters:params resultClass:resultClass];
}
- (RACSignal*)getCollects:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=iuser&a=get_collects" parameters:params resultClass:resultClass];
}
- (RACSignal*)getMasterOrders:(NSString *)status page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    if(status && ![status isEqualToString:@""]){
        [params setObjectNotNull:status forKey:@"orderStatus"];
    }
    
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=iuser&a=get_master_orders" parameters:params resultClass:resultClass];
}

- (RACSignal*)queryIMMessageListWithUserid:(NSString*)userId currentTime:(NSString*)currentTime tag:(NSString*)tag pageSize:(NSInteger)pageSize resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:userId forKey:@"other_uid"];
    [params setObjectNotNull:currentTime forKey:@"currentTime"];
    [params setObjectNotNull:tag forKey:@"tag"];
    [params setObjectNotNull:[NSNumber numberWithInteger:pageSize]  forKey:@"page_size"];
    return [self doRacPost:@"c=iuser&a=get_private_news_detail" parameters:params resultClass:resultClass];
}

- (RACSignal*)sendIMMessage:(NSString*)message toUserid:(NSString*)otUserid type:(NSString*)type resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:otUserid forKey:@"other_uid"];
    [params setObjectNotNull:message forKey:@"content"];
    [params setObjectNotNull:type forKey:@"type"];
    return [self doRacPost:@"c=iuser&a=send_private_news" parameters:params resultClass:resultClass];
}
- (RACSignal*)getMyDetail:(NSString *)uid resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:uid forKey:@"uid_other"];
    return [self doRacPost:@"c=iuser&a=user_pages" parameters:params resultClass:resultClass];
}
- (RACSignal*)deleteOrder:(NSString *)orderId resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:orderId forKey:@"orderId"];
    return [self doRacPost:@"c=iuser&a=delete_order" parameters:params resultClass:resultClass];
}
- (RACSignal*)submitSuggest:(NSString *)content resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:content forKey:@"content"];
    return [self doRacPost:@"c=iuser&a=add_suggest" parameters:params resultClass:resultClass];
}
- (RACSignal*)exChangeCode:(NSString *)code Bymobile:(NSString *)mobile resultClass:(Class)resultClass{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:code forKey:@"code"];
       [params setObjectNotNull:mobile forKey:@"mobile"];
    return [self doRacPost:@"c=iuser&a=code_exchange" parameters:params resultClass:resultClass];
    
}









- (RACSignal*)getSystemMessage:(NSInteger)page page_size:(NSInteger)page_size resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[NSNumber numberWithInteger:page]  forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:page_size]  forKey:@"page_size"];
    return [self doRacPost:@"c=iuser&a=get_system_inform" parameters:params resultClass:resultClass];
}

- (RACSignal*)getCommentList:(NSInteger)page page_size:(NSInteger)page_size resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:page_size] forKey:@"page_size"];
    return [self doRacPost:@"c=iuser&a=get_comment_list" parameters:params resultClass:resultClass];
}

- (RACSignal*)getPrivateNews:(NSInteger)page page_size:(NSInteger)page_size resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:page_size] forKey:@"page_size"];
    return [self doRacPost:@"c=iuser&a=get_private_news_list" parameters:params resultClass:resultClass];
}

- (RACSignal*)getCourseShare:(NSInteger)page page_size:(NSInteger)page_size resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:page_size] forKey:@"page_size"];
    return [self doRacPost:@"c=iuser&a=get_course_share" parameters:params resultClass:resultClass];
}

- (RACSignal*)getPrivateNewsDetail:(NSString*)other_uid page_size:(NSInteger)page_size tag:(NSString*)tag currentTime:(NSString*)currentTime resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:other_uid forKey:@"other_uid"];
    [params setObjectNotNull:[NSNumber numberWithInteger:page_size] forKey:@"page_size"];
    [params setObjectNotNull:tag forKey:@"tag"];
    [params setObjectNotNull:currentTime forKey:@"currentTime"];
    return [self doRacPost:@"c=iuser&a=get_private_news_detail" parameters:params resultClass:resultClass];
}

- (RACSignal*)getCommentDetail:(NSInteger)page page_size:(NSInteger)page_size commentId:(NSString*)commentId resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setObjectNotNull:[NSNumber numberWithInteger:page] forKey:@"page"];
    [params setObjectNotNull:[NSNumber numberWithInteger:page_size] forKey:@"page_size"];
    [params setObjectNotNull:commentId forKey:@"commentId"];
    return [self doRacPost:@"c=iuser&a=get_comment_detail" parameters:params resultClass:resultClass];
}

- (RACSignal*)updateOrderStatus:(NSString*)oid orderStatus:(NSString*)orderStatus reason:(NSString*)reason resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];

    [params setObjectNotNull:oid forKey:@"oid"];
    [params setObjectNotNull:orderStatus forKey:@"orderStatus"];
    [params setObjectNotNull:reason forKey:@"reason"];
    return [self doRacPost:@"c=iuser&a=update_order_status" parameters:params resultClass:resultClass];
}


- (RACSignal*)orderVerification:(NSString*)oid uid:(NSString*)uid code:(NSString*)code resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:oid forKey:@"oid"];
    [params setObjectNotNull:uid forKey:@"uid"];
    [params setObjectNotNull:code forKey:@"code"];
    return [self doRacPost:@"c=iuser&a=order_verification" parameters:params resultClass:resultClass];
}



- (RACSignal*)bindUserPhone:(NSString*)phone code:(NSString*)code resultClass:(Class)resultClass
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:phone forKey:@"mobile"];
   
    [params setObjectNotNull:code forKey:@"code"];
    
    return [self doRacPost:@"c=iuser&a=bind_mobile" parameters:params resultClass:resultClass];

}


-(RACSignal*)clickLike:(NSString *)page pageSize:(NSString *)pageSize resultClass:(Class)resultClass
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:page forKey:@"page"];
    
    [params setObjectNotNull:pageSize forKey:@"page_size"];
    
    return [self doRacPost:@"c=iuser&a=share_like_list" parameters:params resultClass:resultClass];
    
    
}

- (RACSignal*)totalShare_id:(NSString*)share_id type:(NSString *)type resultClass:(Class)resultClass;
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    [params setObjectNotNull:share_id forKey:@"share_id"];
    
    [params setObjectNotNull:type forKey:@"type"];
    
    return [self doRacPost:@"c=ishare&a=discover_redirect_list_update" parameters:params resultClass:resultClass];
}


@end
