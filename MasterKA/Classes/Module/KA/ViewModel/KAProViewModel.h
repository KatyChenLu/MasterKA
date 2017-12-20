//
//  KAProViewModel.h
//  MasterKA
//
//  Created by ChenLu on 2017/11/21.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "TableViewModel.h"

@interface KAProViewModel : TableViewModel

@property (nonatomic, copy) NSString *KAimgUrl;
@property (nonatomic, copy) NSString *KAtitle;
@property (nonatomic, copy) NSString *KAprice;
@property (nonatomic, copy) NSString *KAduringTime;
@property (nonatomic, copy) NSString *KApeople;

@property (nonatomic, strong)NSMutableArray *selectVoteArr;
@property (nonatomic, strong)NSMutableArray *nomorArr;
@property (nonatomic, assign)BOOL isHideSelect;
@property (nonatomic, strong)NSMutableArray *info;
@end
