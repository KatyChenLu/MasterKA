//
//  AticleDetailModel.h
//  MasterKA
//
//  Created by 余伟 on 16/10/17.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AticleDetailModel : NSObject

@property(nonatomic , copy)NSString * index_article_id;

@property(nonatomic ,copy)NSString * title;

@property(nonatomic , copy)NSString * share_count;

@property(nonatomic ,copy)NSString * like_count;

@property(nonatomic , copy)NSString * comment_count;

@property(nonatomic ,strong)NSDictionary * share_data;

@property(nonatomic , strong)NSArray * content_list;

@property(nonatomic ,strong)NSArray * like_user_list;

@property(nonatomic , strong)NSArray * comment_list;

@property(nonatomic , copy)NSString * is_like;

@property(nonatomic ,strong)NSArray * course_list;





@end
