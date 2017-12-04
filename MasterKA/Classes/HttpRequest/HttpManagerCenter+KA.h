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
@end
