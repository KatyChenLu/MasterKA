//
//  HttpManagerCenter+Home.h
//  MasterKA
//
//  Created by 余伟 on 16/10/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "HttpManagerCenter.h"

@interface HttpManagerCenter (Home)


/**
 *  首页文章数据
 *
 *  @param page        页数
 *  @param pageSize    数量
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)queryMasterPage:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass;

/**
 *  人群分类文章数据
 *
 *  @param usercategory_id        人群分类id
 *  @param page        页数
 *  @param pageSize    数量
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)queryArticleUserCategory_list:(NSString *)usercategory_id  page:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass;



/**
 *  Topic文章数据
 *
 *  @param topic_id    topicid
 *  @param page        页数
 *  @param pageSize    数量
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)queryArticleTopic:(NSString *)topic_id  page:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass;

//c=icourse&a=usercategory_list

/**
 *  人群分类课程数据
 *
 *  @param usercategory_id        人群分类id
 *  @param page        页数
 *  @param pageSize    数量
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)queryUserCategory_list:(NSString *)usercategory_id  page:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass;


/**
 *  首页文章点赞
 *
 *  @param index_article_id    文章id
 *  @param resutlClass         返回数据解析类
 *
 *  @return
 */
- (RACSignal*)detemineLike:(NSString *)index_article_id resultClass:(Class)resultClass;


/**
 *  首页文章取消点赞
 *
 *  @param index_article_id    文章id
 *  @param resutlClass         返回数据解析类
 *
 *  @return
 */
- (RACSignal*)cancleLike:(NSString *)index_article_id resultClass:(Class)resultClass;


/**
 *  首页文章转发
 *
 *  @param index_article_id    文章id
 *  @param resutlClass         返回数据解析类
 *
 *  @return
 */
- (RACSignal*)shareArticle:(NSString *)index_article_id resultClass:(Class)resultClass;


/**
 *  话题课程数据
 *
 *  @param topic_id    话题id
 *  @param page        页数
 *  @param pageSize    数量
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)queryTopic_list:(NSString *)topic_id  page:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass;


/**
 *  首页文章详情
 *
 *  @param index_article_id    文章id
 *  @param resutlClass         返回数据解析类
 *
 *  @return
 */
- (RACSignal*)articleDetail:(NSString *)index_article_id resultClass:(Class)resultClass;




/**
 *  评论列表
 *
 *  @param index_article_id    文章id
 *  @param page        页数
 *  @param pageSize    数量
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)getComment:(NSString *)index_article_id  page:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass;



/**
 *  评论回复
 *
 *  @param comment_id   评论id
 *  @param otherUserId  回复用户uid
 *  @param content      回复内容
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */

- (RACSignal*)addCommentsReplyCommentId:(NSString*)comment_id otherUserId:(NSString *)otherUserId content:(NSString*)content resultClass:(Class)resultClass;



/**
 *  添加评论
 *
 *  @param index_article_id   文章id
 *  @param content            回复内容
 *  @param resutlClass      返回数据解析类
 *
 *  @return
 */

- (RACSignal*)addCommentsArticle_id:(NSString *)index_article_id  content:(NSString*)content resultClass:(Class)resultClass;


/**
 *  点赞列表
 *
 *  @param index_article_id    文章id
 *  @param page        页数
 *  @param pageSize    数量
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)getLikeList:(NSString *)index_article_id  page:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass;



/**
 *  首页课程推送
 *
 *  @param hid          课程推送记录id
 *  @param status       课程推送查看状态(0未读，1已读)
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)launchCourseWithHid:(NSString *)hid status:(NSString *)status resultClass:(Class)resultClass;


/**
 *  首页优惠券
 *
 *  @param hid          课程推送记录id
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)bindCourseWithHid:(NSString *)hid resultClass:(Class)resultClass;

/**
 *  添加广告浏览记录
 *
 *  @param ads_data_id  广告id
 *  @param index        广告位置
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)totalAds_data_id:(NSString *)ads_data_id index:(NSString*)index resultClass:(Class)resultClass;


@end
