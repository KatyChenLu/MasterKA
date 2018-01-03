//
//  KACollectViewModel.h
//  MasterKA
//
//  Created by ChenLu on 2017/12/15.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "TableViewModel.h"

@interface KACollectViewModel : TableViewModel
@property (nonatomic, strong)NSMutableArray *info;

@property (nonatomic, strong)NSMutableArray *addVoteKAID;
@property (nonatomic, strong)NSMutableArray *cancelVoteKAID;
@property (nonatomic, strong)NSTimer *myTimer;
@property (nonatomic, assign)BOOL isShowCusBtn;
@end
