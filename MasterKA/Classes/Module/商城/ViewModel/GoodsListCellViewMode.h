//
//  GoodsListCellViewMode.h
//  MasterKA
//
//  Created by xmy on 16/5/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseTableViewCell.h"
#import "CourseModel.h"

@interface GoodsListCellViewMode : NSObject

@property (nonatomic, strong) RACCommand *didClickLinkCommand;
//@property (nonatomic, strong) RACCommand *didClickTagButtonCommand;

@property (nonatomic, strong, readonly) CourseModel *model;


- (instancetype)initWithModel:(CourseModel*)model;
- (void)bindGoodsTableViewCell:(CourseTableViewCell *)cell;

@end
