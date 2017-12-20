//
//  KAEditVoteViewController.h
//  MasterKA
//
//  Created by ChenLu on 2017/11/21.
//  Copyright © 2017年 chenlu. All rights reserved.
//

#import "BaseViewController.h"
#import "KAVoteViewController.h"

@interface KAEditVoteViewController : BaseViewController
@property (nonatomic, strong)NSMutableArray *info;
@property (nonatomic, strong)NSArray *selArr;
@property (nonatomic, strong)KAVoteViewController *voteVC;
@end
