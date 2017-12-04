//
//  MyFansModel.h
//  MasterKA
//
//  Created by hyu on 16/4/28.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "TableViewModel.h"

@interface MyFansModel : TableViewModel
@property(nonatomic, strong) NSMutableArray *info;
@property(nonatomic, strong) NSString *course_id;
@property(nonatomic, strong) NSString *comeIdentity;
@property(nonatomic,strong)NSString*share_id;
@property(nonatomic,strong)NSString* master;
@property(nonatomic, strong) NSIndexPath *removeIndex;

@property(nonatomic ,copy)NSString * index_article_id;

@end
