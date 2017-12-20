//
//  HttpManagerCenter+KA.h
//  MasterKA
//
//  Created by ChenLu on 2017/11/30.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "HttpManagerCenter.h"

@interface HttpManagerCenter (KA)

/**
 *  首页
 *
 *  @param page        页数
 *  @param pageSize    数量
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)getHomeDataListsPage:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass;

/**
 *  订单列表
 *
 *  @param page        页数
 *  @param pageSize    数量
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)getKAOrderListsPage:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass;

/**
 *  团建需求提交
 *
 *  @param ka_course_id           团建课程id，可不填
 *  @param group_start_time       团建时间
 *  @param people_num             团建人数
 *  @param group_type             是否上门
 *  @param course_time            团建时长
 *  @param course_price           团建价格
 *  @param mobile                 用户手机号码
 *  @param mark                   备注
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)addCustomRequirement:(NSString *)ka_course_id groupStartTime:(NSString *)group_start_time peopleNum:(NSString *)people_num groupType:(NSString *)group_type courseTime:(NSString *)course_time coursePrice:(NSString *)course_price mobile:(NSString *)mobile mark:(NSString *)mark  resultClass:(Class)resultClass;



/**
 *  个人中心
 *
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)queryKAUserCenterWith:(Class)resultClass;

/**
 *  团建课程详情
 *
 *  @param index_article_id    团建课程id
 *  @param resutlClass         返回数据解析类
 *
 *  @return
 */
- (RACSignal*)kaCourseDetail:(NSString *)index_article_id resultClass:(Class)resultClass;
/**
 *  关键字搜索课程
 *
 *  @param keywords    关键字
 *  @param page                   页数
 *  @param pageSize                 数量
 *  @param resutlClass         返回数据解析类
 *
 *  @return
 */
- (RACSignal*)searchCourseWithKeywords:(NSString *)keywords page:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass;
/**
 *  场景筛选课程列表
 *
 *  @param course_scenes_id    场景id
 *  @param people_num_min      最小人数
 *  @param people_num_max      最大人数
 *  @param course_price_min    最小价格
 *  @param course_price_max    最大价格
 *  @param course_time_min     最小时间
 *  @param course_time_max     最大时间
 *  @param page                   页数
 *  @param pageSize                 数量
 *  @param resutlClass         返回数据解析类
 *
 *  @return
 */
- (RACSignal*)getCourseScenesListWithID:(NSString *)course_scenes_id peopleMin:(NSString *)people_num_min peopleMax:(NSString *)people_num_max priceMin:(NSString *)course_price_min priceMax:(NSString *)course_price_max timeMin:(NSString *)course_time_min timeMax:(NSString *)course_time_max page:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass;
/**
 *  团建课程收藏
 *
 *  @param ka_course_id    团建课程id
 *  @param resutlClass         返回数据解析类
 *
 *  @return
 */
- (RACSignal*)addLikeCource:(NSString *)ka_course_id resultClass:(Class)resultClass;
/**
 *  团建课程取消收藏
 *
 *  @param ka_course_id    团建课程id
 *  @param resutlClass         返回数据解析类
 *
 *  @return
 */
- (RACSignal*)cancelLikeCource:(NSString *)ka_course_id resultClass:(Class)resultClass;
/**
 *  团建课程收藏列表
 *
 *  @param page        页数
 *  @param pageSize    数量
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)getLikeListsPage:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass;


///////////精彩时刻
/**
 *  KA精彩时刻列表
 *
 *  @param page        页数
 *  @param pageSize    数量
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)queryMomentList:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass;
/**
 *  KA精彩时刻详情
 *
 *  @param moment_id             场地id
 *  @param resutlClass         返回数据解析类
 *
 *  @return
 */
- (RACSignal*)momentDetail:(NSString *)moment_id resultClass:(Class)resultClass;






///////////场地
/**
 *  KA场地列表接口
 *
 *  @param page        页数
 *  @param pageSize    数量
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)queryKAFieldListPage:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass;
/**
 *  KA场地详情
 *
 *  @param field_id             场地id
 *  @param resutlClass         返回数据解析类
 *
 *  @return
 */
- (RACSignal*)fieldDetail:(NSString *)field_id resultClass:(Class)resultClass;



///////////投票
/**
 *  我已发起的投票列表
 *
 *  @param page        页数
 *  @param pageSize    数量
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)mineVoteListsPage:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass;

/**
 *  KA待投票列表
 *
 *  @param page        页数
 *  @param pageSize    数量
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)getVoteCartListsPage:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass;

/**
 *  加入待投票列表
 *
 *  @param ka_course_id    团建课程id
 *  @param resutlClass         返回数据解析类
 *
 *  @return
 */
- (RACSignal*)addVoteCart:(NSString *)ka_course_id resultClass:(Class)resultClass;
/**
 *  取消待投票列表
 *
 *  @param ka_course_id    团建课程id
 *  @param resutlClass         返回数据解析类
 *
 *  @return
 */
- (RACSignal*)cancelVoteCart:(NSString *)ka_course_id resultClass:(Class)resultClass;

/**
 *  新增投票
 *
 *  @param ka_course_id    团建课程id
 *  @param resutlClass         返回数据解析类
 *
 *  @return
 */
- (RACSignal*)postVoteWithTitle:(NSString *)vote_title desc:(NSString *)vote_desc endDays:(NSString *)end_days endHours:(NSString *)end_hours courseIds:(NSArray *)ka_course_ids resultClass:(Class)resultClass;

/**
 *  投票详情结果
 *
 *  @param vote_id            团建投票id
 *  @param resutlClass         返回数据解析类
 *
 *  @return
 */
- (RACSignal*)voteItemDetail:(NSString *)vote_id resultClass:(Class)resultClass;
/**
 *  投票用户头像列表
 *
 *  @param page        页数
 *  @param pageSize    数量
 *  @param resutlClass  返回数据解析类
 *
 *  @return
 */
- (RACSignal*)getItemUserListsWithItemId:(NSString *)item_id Page:(NSString *)page pageSize:(NSString*)page_size resultClass:(Class)resultClass;

@end
