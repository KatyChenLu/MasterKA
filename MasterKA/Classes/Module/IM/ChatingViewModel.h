//
//  ChatingViewModel.h
//  MasterKA
//
//  Created by jinghao on 16/5/12.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "TableViewModel.h"

@interface ChatingViewModel : TableViewModel
@property (nonatomic,strong)NSString *otherUserid;
@property (nonatomic,strong)NSString *currentTime;
@property (nonatomic,strong,readonly)RACCommand *sendMessageCommand;
@end
