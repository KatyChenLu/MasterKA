//
//  SuperscriptModel.h
//  MasterKA
//
//  Created by jinghao on 16/4/20.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DBBaseModel.h"
@interface SuperscriptModel : DBBaseModel
@property (nonatomic,strong)NSString *superscriptId;
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *pic_url;

@end
