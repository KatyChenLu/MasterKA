//
//  HttpManagerCenter+User.h
//  MasterKA
//
//  Created by jinghao on 16/4/18.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "HttpManagerCenter.h"

@interface HttpManagerCenter (User)

/**
 *  查询用户中心数据
 *
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)queryUserCenterWith:(Class)resultClass;


/**
 *  获取用户关注列表
 *
 *  @param page        当前页码
 *  @param pageSize    每页数据量
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)queryMyFansByPage:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;

- (RACSignal*)getMyUserCourse:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;

/**
 *  获取用户粉丝列表
 *
 *  @param page        当前页码
 *  @param pageSize    每页数据量
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)queryMyFollowsByPage:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;

/**
 *  添加关注
 *
 *  @param userId      被关注人id
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)addAttention:(NSString*)userId resultClass:(Class)resultClass;

/**
 *  取消关注
 *
 *  @param userId           取消关注人Id
 *  @param resultClass   返回数据解析类
 *
 *  @return  返回数据解析类
 */
- (RACSignal*)removeAttention:(NSString*)userId resultClass:(Class)resultClass;
/**
 *  修改个人信息
 *
 *  @param userInfo      个人信息
 *  @param resultClass   返回数据解析类
 *
 *  @return  返回数据解析类
 */
- (RACSignal*)modifilrUserInfo:(NSDictionary *)userInfo resultClass:(Class)resultClass;
/**
 *  获取M点详细
 *
 *  @param page        当前页码
 *  @param pageSize    每页数据量
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)getScoreDetialByPage:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;
/**
 *  上传个人信息头像
 *
 *  @param imgStr       头像数据
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)updateHeadIma:(NSString *)imgStr resultClass:(Class)resultClass;//上传头像
/**
 *  获取我的代金券
 *
 *  @param page        当前页码
 *  @param pageSize    每页数据量
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)getMyCoupon:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;//获取优惠券
/**
 *  获取我的酱油卡
 *
 *  @param page        当前页码
 *  @param pageSize    每页数据量
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)getMyCard:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;//获取酱油卡
/**
 *  获取我的分享
 *
 *  @param page        当前页码
 *  @param pageSize    每页数据量
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)getMyShare:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;//获取分享
/**
 *  获取购课订单
 *
 *  @param status      订单状态
 *  @param page        当前页码
 *  @param pageSize    每页数据量
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)getMyOrder:(NSString *)status page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;//获取订单
/**
 *  获取m点体验课列表
 *
 *  @param page        当前页码
 *  @param pageSize    每页数据量
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)getCourse:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;

/**
 *  获得达人课程列表
 *
 *  @param page        页码
 *  @param pageSize    请求数据量
 *  @param resultClass 数据解析类
 *
 *  @return 
 */
- (RACSignal*)getMyCourse:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;
/**
 *  订单详情
 *
 *  @param orderId       订单id
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)getOrderDetail:(NSString *)orderId mainOrderId:(NSString*)mainOrderId resultClass:(Class)resultClass;

/**
 *  心愿单列表
 *
 *  @param page        当前页码
 *  @param pageSize    每页数据量
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)getCollects:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;
/**
 *  获取订单管理
 *
 *  @param status      订单状态
 *  @param page        当前页码
 *  @param pageSize    每页数据量
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)getMasterOrders:(NSString *)status page:(NSInteger)page pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;

/**
 *  获得私信内容详情
 *
 *  @param userId      对方用户ID
 *  @param currentTime 时间戳，当tag为2，或3时必填
 *  @param tag          1：当前页2：新数据 3：旧数据
 *  @param pageSize    页面大小
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)queryIMMessageListWithUserid:(NSString*)userId currentTime:(NSString*)currentTime tag:(NSString*)tag pageSize:(NSInteger)pageSize resultClass:(Class)resultClass;
/**
 *  发送私信
 *
 *  @param message     消息内容
 *  @param otUserid    接收方uid
 *  @param type        信息类型1为文字，2为图片
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)sendIMMessage:(NSString*)message toUserid:(NSString*)otUserid type:(NSString*)type resultClass:(Class)resultClass;
/**
 *  获取个人主页
 *
 *  @param uid          id
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)getMyDetail:(NSString *)uid resultClass:(Class)resultClass;
/**
 *  删除订单
 *
 *  @param uid          id
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)deleteOrder:(NSString *)orderId resultClass:(Class)resultClass;
/**
 *  意见反馈
 *
 *  @param content          内容
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)submitSuggest:(NSString *)content resultClass:(Class)resultClass;
/**
 *  兑换码
 *
 *  @param code          兑换码
 *  @param mobile        电话
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)exChangeCode:(NSString *)code Bymobile:(NSString *)mobile resultClass:(Class)resultClass;
/**
 *  个人主页点赞
 *
 *  @param userId      id
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)addUserLike:(NSString*)userId resultClass:(Class)resultClass;
/**
 *  个人主页取消点赞
 *
 *  @param userId      id
 *  @param resultClass 返回数据解析类
 *
 *  @return
 */
- (RACSignal*)removeUserLike:(NSString*)userId resultClass:(Class)resultClass;



/**
 *  获取系统消息
 *
 *  @param page
 *  @param page_size
 *  @param resultClass
 *
 *  @return
 */
- (RACSignal*)getSystemMessage:(NSInteger)page page_size:(NSInteger)page_size resultClass:(Class)resultClass;

/**
 *  获取评论回复
 *
 *  @param page
 *  @param page_size
 *  @param resultClass
 *
 *  @return
 */
- (RACSignal*)getCommentList:(NSInteger)page page_size:(NSInteger)page_size resultClass:(Class)resultClass;

/**
 *  获取私信列表
 *
 *  @param page
 *  @param page_size
 *  @param resultClass
 *
 *  @return
 */
- (RACSignal*)getPrivateNews:(NSInteger)page page_size:(NSInteger)page_size resultClass:(Class)resultClass;

/**
 *  获取课程分享
 *
 *  @param page
 *  @param page_size
 *  @param resultClass
 *
 *  @return
 */
- (RACSignal*)getCourseShare:(NSInteger)page page_size:(NSInteger)page_size resultClass:(Class)resultClass;

/**
 *  获取私信详情
 *
 *  @param other_uid   对方uid
 *  @param page_size
 *  @param tag         1：当前页2：新数据 3：旧数据
 *  @param currentTime 时间戳，当tag为2，或3时必填
 *  @param resultClass
 *
 *  @return
 */
- (RACSignal*)getPrivateNewsDetail:(NSString*)other_uid page_size:(NSInteger)page_size tag:(NSString*)tag currentTime:(NSString*)currentTime resultClass:(Class)resultClass;

/**
 *  获取评论详情
 *
 *  @param page
 *  @param page_size
 *  @param commentId   评论ID
 *  @param resultClass
 *
 *  @return 
 */
- (RACSignal*)getCommentDetail:(NSInteger)page page_size:(NSInteger)page_size commentId:(NSString*)commentId resultClass:(Class)resultClass;

/**
 *  更新订单状态
 *
 *  @param oid         订单ID
 *  @param orderStatus 订单状态
 *  @param reason      拒单原因
 *  @param resultClass
 *
 *  @return
 */
- (RACSignal*)updateOrderStatus:(NSString*)oid orderStatus:(NSString*)orderStatus reason:(NSString*)reason resultClass:(Class)resultClass;

/**
 *  开始验单
 *
 *  @param oid          订单ID
 *  @param uid          用户id
 *  @param code         验证码
 *  @param resultClass
 *
 *  @return
 */
- (RACSignal*)orderVerification:(NSString*)oid uid:(NSString*)uid code:(NSString*)code resultClass:(Class)resultClass;



/**
 *  开始验单
 *

 *  @param phone        用户id
 *  @param code         验证码
 *  @param resultClass
 *
 *  @return
 */
- (RACSignal*)bindUserPhone:(NSString*)phone code:(NSString*)code resultClass:(Class)resultClass;

/**
 *  点赞列表
 *
 *  @param page          页数
 *  @param pageSize      返回数据条数
 *  @param resultClass 返回数据解析类
 */
-(RACSignal*)clickLike:(NSString *)page pageSize:(NSString *)pageSize resultClass:(Class)resultClass;

/**
 *  分享数据统计
 *
 *  @param share_id    share_id
 *  @param type        分享类型:1长图文分享,2视频,短分享
 *  @param resultClass 返回数据解析类
 */
- (RACSignal*)totalShare_id:(NSString*)share_id type:(NSString *)type resultClass:(Class)resultClass;

@end
