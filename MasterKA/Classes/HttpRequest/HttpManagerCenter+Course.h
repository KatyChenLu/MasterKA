//
//  HttpManagerCenter+Course.h
//  MasterKA
//
//  Created by jinghao on 16/4/18.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "HttpManagerCenter.h"

@interface HttpManagerCenter (Course)

/**
 *  根据关键字查询课程列表
 *
 *  @param keywords    关键字
 *  @param page        当前页
 *  @param pageSize    分页数
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)searchCourseByKeywords:(NSString*)keywords page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;


/**
 *  商城分类初始化获取接口
 */
- (RACSignal*)queryCourseIndex:(Class)resultClass;

/**
 *  @param course_id 关联课程id
 *  @param order_type 排序id
 *  @param select_type 筛选id
 *  @param page 
 *  @param page_size
 *
 */
- (RACSignal*)getCategoryList:(NSString*)category_id order_type:(NSString*)order_type select_type:(NSString*)select_type page:(NSString*)page page_size:(NSString*)page_size  resultClass:(Class)resultClass;
/**
 *  课程详情
 *
 *  @param courseId       课程id
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)getCourseDetail:(NSString *)courseId resultClass:(Class)resultClass;
/**
 *  他们也想学
 *
 *  @param courseId       课程id
 *  @param page
 *  @param page_size
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)getCourseShareBycourseId:(NSString *)courseId page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;
/**
 *  他们也想学
 *
 *  @param courseId       课程id
 *  @param page
 *  @param page_size
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)getStudents:(NSString *)courseId page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;
/**
 *  根据课程的组合ID获取日历
 *
 *  @param groupId     组合ID
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)getCourseDateTimeByGroupId:(NSString*)groupId resultClass:(Class)resultClass;

/**
 *  获取将要下单的信息
 *
 *  @param courseId    课程ID
 *  @param groupId     选择的时间段ID
 *  @param groupbuy    是否为团购课
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)getPayInfoForOrder:(NSString*)courseId groupId:(NSString*)groupId  groupbuy:(NSString *)groupbuy resultClass:(Class)resultClass;
/**
 *  获取酱油卡详情
 *
 *  @param card_id    卡ID
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)getCardDetail:(NSString*)cardId resultClass:(Class)resultClass;
/**
 *  收藏课程
 *
 *  @param card_id    课ID
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)collectCourse:(NSString*)courseId resultClass:(Class)resultClass;

/**
 *  取消收藏课程
 *
 *  @param card_id    课ID
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)removeCollectCourse:(NSString*)courseId resultClass:(Class)resultClass;

/**
 *  下单
 *
 *  @param courseId      课程id
 *  @param groupId       套餐id（非日历课程可以不传或传空字符串）
 *  @param timeId        时间段id
 *  @param number        购买数量
 *  @param payType       支付方式，1支付宝app，2银联，4微信app
 *  @param mobile        手机号码
 *  @param conditionType 优惠方式
 *  @param conditionId   优惠id
 *  @param useMoney      使用余额
 *  @param resultClass   返回数据解析类
 *
 *  @return
 */
- (RACSignal*)sendPayInfoForOrder:(NSString*)courseId groupId:(NSString*)groupId timeId:(NSString*)timeId number:(NSInteger)number payType:(NSInteger)payType mobile:(NSString*)mobile conditionType:(NSString*)conditionType conditionId:(NSString*)conditionId useMoney:(NSString*)useMoney receiver_name:(NSString*)receiver_name receiver_address:(NSString*)receiver_address resultClass:(Class)resultClass;

/**
 *  酱油卡下单确认
 *
 *  @param cardId      酱油卡id
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)getPayInfoForCard:(NSString*)cardId resultClass:(Class)resultClass;


/**
 *  酱油卡购买订单
 *
 *  @param cardId        酱油卡id
 *  @param number        购买数量
 *  @param payType       支付方式，1支付宝app，2银联，4微信app
 *  @param conditionType 优惠方式
 *  @param conditionId   优惠id
 *  @param useMoney      使用余额
 *  @param resultClass   返回数据解析类
 *
 *  @return
 */
- (RACSignal*)sendPayInfoForCard:(NSString*)cardId number:(NSInteger)number payType:(NSInteger)payType mobile:(NSString*)mobile conditionType:(NSString*)conditionType conditionId:(NSString*)conditionId useMoney:(NSString*)useMoney resultClass:(Class)resultClass;

/**
 *  酱油卡列表
 *
 *  @param page        页码
 *  @param pageSize    数量
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)queryCardListWithPage:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;

/**
 *  达人非企业课 或 企业课列表
 *
 *  @param uid          用户id
 *  @param page        页码
 *  @param pageSize    数量
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)queryCourseByMasterUid:(NSString*)uid companyId:(NSString*)companyId page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;


- (RACSignal*)getJiangYouCardList:(NSString*)card_id page:(NSString*)page page_size:(NSString*)page_size   resultClass:(Class)resultClass;



/**
 *  课程地图
 *
 *  @param lng          经度
 *  @param lat          纬度
 *  @param categoryId   一级分类id
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)queryCourseWithLng:(NSString *)lng AndLat:(NSString *)lat withCategoryId:(NSString *)categoryId resultClass:(Class)resultClass;

/**
 *  获取提问列表
 *
 *  @param courseid     课程id
 *  @param page          页码
 *  @param pageSize      数量
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)getAskListWithCourseId:(NSString *)courseid Page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;
/**
 *  课程问题列表
 *
 *  @param questionId     问题id
 *  @param page          页码
 *  @param pageSize      数量
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)getAnswerListWithQuestionId:(NSString *)questionId Page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;
/**
 *  课程问题提问
 *
 *  @param courseId     课程编号
 *  @param content      提问内容
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)sendQuestionAddOfCourse:(NSString *)courseId content:(NSString *)content resultClass:(Class)resultClass;
/**
 *  课程回答问题
 *
 *  @param courseId     课程编号
 *  @param content      回答内容
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)sendAnswerAddOfCourse:(NSString *)courseId content:(NSString *)content resultClass:(Class)resultClass;
@end
