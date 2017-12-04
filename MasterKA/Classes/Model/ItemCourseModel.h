//
//  ItemCourseModel.h
//  MasterKA
//
//  Created by 余伟 on 16/9/26.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemCourseModel : NSObject

//名称
@property(nonatomic ,copy)NSString *name;

//跳转地址
@property(nonatomic ,copy)NSString *pfurl;


//图片地址
@property(nonatomic ,copy)NSString *pic_url;

@end
