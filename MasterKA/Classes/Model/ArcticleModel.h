//
//  ArcticleModel.h
//  MasterKA
//
//  Created by 余伟 on 16/10/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArcticleModel : NSObject

@property(nonatomic ,strong)NSArray * article_list;

@property(nonatomic ,strong)NSArray * banner_list;

@property(nonatomic ,strong)NSArray * category_user_list;
@property(nonatomic ,strong)NSDictionary * home_list_course;


@property(nonatomic ,strong)NSDictionary * search_ad;

@property(nonatomic ,strong)NSDictionary * title_ad;



@end
