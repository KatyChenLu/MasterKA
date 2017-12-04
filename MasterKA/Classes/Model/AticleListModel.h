//
//  AticleListModel.h
//  MasterKA
//
//  Created by 余伟 on 16/10/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AticleListModel : NSObject


@property(nonatomic ,copy)NSString * comment_count;

@property(nonatomic ,strong)NSArray * cover;

@property(nonatomic ,copy)NSString * index_article_id;

@property(nonatomic ,copy)NSString * intro;

@property(nonatomic ,copy)NSString * is_like;

@property(nonatomic ,copy)NSString * like_count;

@property(nonatomic ,copy)NSString * share_count;

@property(nonatomic ,copy)NSString * title;

@property(nonatomic ,copy)NSString * type;

@property(nonatomic ,copy)NSString * usercategory_id;

@property(nonatomic ,strong)NSArray * topic_list;

@property(nonatomic ,strong)NSDictionary * share_data;

@property(nonatomic ,copy)NSString * is_movie;






@end
