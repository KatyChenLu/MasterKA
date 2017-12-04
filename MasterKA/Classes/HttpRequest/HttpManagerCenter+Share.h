//
//  HttpManagerCenter+Share.h
//  MasterKA
//
//  Created by jinghao on 16/4/18.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "HttpManagerCenter.h"

@interface HttpManagerCenter (Share)


//------------------达人模块接口-----------------------
/**
 *  达人分享首页数据
 *
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)queryMasterIndex:(Class)resultClass;


/**
 *  达人分享首页数据
 *  @param type         type
 *  @param shareId       shareId
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)ReportType:(NSString *)type shareId:(NSString *)shareId resultClass:(Class)resultClass;


/**
 *  根据分类ID查询达人分享内容
 *
 *  @param TypeId      分类ID
 *  @param page        页码
 *  @param pageSize    数量
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)queryMasterShareByTypeId:(NSString*)TypeId page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;

/**
 *  达人标签筛选分享列表接口
 *
 *  @param tagId       标签ID
 *  @param page        页码
 *  @param pageSize    数量
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)queryMasterShareByTag:(NSString *)tagId page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;

/**
 *  达人分享详情接口
 *
 *  @param shareId      分享id
 *  @param resultClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)queryMasterSHareDetailById:(NSString*)shareId resultClass:(Class)resultClass;

/**
 *  获取达人分享评论列表
 *
 *  @param share_id        分享ID
 *  @param page        当前页码
 *  @param pageSize    每页数据量
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)queryMasterComments:(NSString*)share_id page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;

/**
 *  达人分享提交评论
 *
 *  @param share_id        分享ID
 *  @param content        回复内容
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)addMasterComments:(NSString*)share_id content:(NSString*)content resultClass:(Class)resultClass;

/**
 *  达人分享回复评论
 *
 *  @param comment_id        评论ID
 *  @param content        回复内容
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)addMasterCommentsReply:(NSString*)comment_id otherUserId:(NSString *)otherUserId content:(NSString*)content resultClass:(Class)resultClass;

/**
 *  达人分享点赞
 *
 *  @param share_id        分享ID
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)masterShareLike:(NSString*)share_id resultClass:(Class)resultClass;

/**
 *  达人分享取消点赞
 *
 *  @param share_id        分享ID
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)masterShareCancelLike:(NSString*)share_id resultClass:(Class)resultClass;




- (RACSignal*)queryCommentList:(BOOL)isMaster shareId:(NSString *)share_id page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;


- (RACSignal*)addComments:(BOOL)isMaster shareId:(NSString*)share_id content:(NSString*)content resultClass:(Class)resultClass;

- (RACSignal*)addCommentsReply:(BOOL)isMaster commentId:(NSString*)comment_id otherUserId:(NSString *)otherUserId content:(NSString*)content resultClass:(Class)resultClass;


/**
 *  达人分享发布
 *  @param media_type 媒体类型：1、图片，2、视频
 *  @param category_id 兴趣标签id
 *  @param tag_name 标签名字
 *  @param course_id 关联课程id
 *  @param title 分享标题
 *  @param content 分享内容
 *  @param cover 分享封面图
 *  @param media_list  资源列表 List
 *
 *
 */
- (RACSignal*)addMasterShare:(NSString*)media_type category_id:(NSString*)category_id tag_name:(NSString*)tag_name course_id:(NSString*)course_id title:(NSString*)title content:(NSString*)content cover:(NSString*)cover media_list:(NSArray*)media_list resultClass:(Class)resultClass;

/**
 *  达人分享搜索接口
 *
 *  @param keywords    关键字
 *  @param page        页数
 *  @param pageSize    数量
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)searchMasterShareByKeywords:(NSString*)keywords page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;

/**
 *  用户搜索接口
 *
 *  @param keywords    关键字
 *  @param page        页数
 *  @param pageSize    数量
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)searchUserByKeywords:(NSString*)keywords page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;










//------------------牛人模块接口-----------------------


/**
 *  获取牛人分享列表
 *
 *  @param page        当前页码
 *  @param pageSize    每页数据量
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)queryUserShare:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;

/**
 *  获取牛人分享详情
 *
 *  @param share_id        分享ID
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)queryUserShareDetail:(NSString*)share_id resultClass:(Class)resultClass;

/**
 *  获取牛人分享评论列表
 *
 *  @param share_id        分享ID
 *  @param page        当前页码
 *  @param pageSize    每页数据量
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)queryUserComments:(NSString*)share_id page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;

/**
 *  牛人分享提交评论
 *
 *  @param share_id        分享ID
 *  @param content        回复内容
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)addUserComments:(NSString*)share_id content:(NSString*)content resultClass:(Class)resultClass;

/**
 *  牛人分享回复评论
 *
 *  @param comment_id        评论ID
 *  @param content        回复内容
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)addUserCommentsReply:(NSString*)comment_id otherUserId:(NSString *)otherUserId content:(NSString*)content resultClass:(Class)resultClass;

/**
 *  牛人分享点赞
 *
 *  @param share_id        分享ID
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)userShareLike:(NSString*)share_id resultClass:(Class)resultClass;

/**
 *  牛人分享取消点赞
 *
 *  @param share_id        分享ID
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)userShareCancelLike:(NSString*)share_id resultClass:(Class)resultClass;

/**
 *  @param media_type 媒体类型：1、图片，2、视频
 *  @param content 发布内容
 *  @param url 媒体资源url，用“,”(英文半角)拼接
 *  @param course_id 关联课程id
 *  @param province
 *  @param city
 *  @param address
 *  @param longitude
 *  @param latitude
 *  @param is_show_position 是否显示位置信息(0:不显示; 1:显示)
 *
 */
- (RACSignal*)addUserShare:(NSString*)media_type content:(NSString*)content url:(NSString*)url course_id:(NSString*)course_id orderId:(NSString*)orderId province:(NSString*)province city:(NSString*)city address:(NSString*)address longitude:(NSString*)longitude latitude:(NSString*)latitude is_show_position:(NSString*)is_show_position thumb:(NSString*)thumb resultClass:(Class)resultClass;

/**
 *  牛人分享删除
 *
 *  @param share_id        分享ID
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)removeUserShare:(NSString*)share_id resultClass:(Class)resultClass;

/**
 *  达人分享删除
 *
 *  @param share_id        分享ID
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)removeMasterShare:(NSString*)share_id resultClass:(Class)resultClass;
//find
-(RACSignal*)RequestForSearchData:(NSString*)type page:(NSString*)page page_size:(NSString*)page_size resultClass:(Class)resultClass;
- (RACSignal*)getMasterFans:(NSString *)shareId page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;
- (RACSignal*)getUsersFans:(NSString *)shareId page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;


/**
 *  热门达人统计
 *  @param master_id     master_id
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)totalMaster_id:(NSString *)master_id  resultClass:(Class)resultClass;

@end
