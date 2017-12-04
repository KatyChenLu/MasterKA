//
//  MasterMsg.h
//  MasterKA
//
//  Created by 余伟 on 16/12/22.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterMsg : UIView

@property(nonatomic , strong)NSDictionary * dic;

@property(nonatomic ,copy)void(^msg)();

+(instancetype)masterMsg;

@end
