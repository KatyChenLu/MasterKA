//
//  AnswerListViewModel.h
//  MasterKA
//
//  Created by ChenLu on 2017/8/11.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "TableViewModel.h"

@interface AnswerListViewModel : TableViewModel

@property (nonatomic, strong)NSDictionary *info;
@property(nonatomic, strong) NSString *questionId;
@end
