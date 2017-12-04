//
//  MasterMsgCell.h
//  MasterKA
//
//  Created by 余伟 on 17/2/6.
//  Copyright © 2017年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterMsgCell : UITableViewCell

@property(nonatomic , strong)NSDictionary * dic;

@property(nonatomic , copy)void(^master)();

@end
