//
//  ShareRootModel.h
//  MasterKA
//
//  Created by xmy on 16/5/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareRootModel : NSObject
@property (nonatomic,strong)NSArray *banner_list;
@property (nonatomic,strong)NSArray *category_list;
@property(nonatomic ,strong)NSArray *all_category_list;

@property(nonatomic ,strong)NSDictionary *enterprise_course_img_url;
@end
