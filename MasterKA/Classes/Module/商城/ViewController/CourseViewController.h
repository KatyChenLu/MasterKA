//
//  CourseViewController.h
//  MasterKA
//
//  Created by 余伟 on 16/8/15.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "BaseViewController.h"

@interface CourseViewController : BaseViewController



@property(nonatomic ,copy)NSString * categoryId;
@property (nonatomic,strong)NSString *orderId;
@property (nonatomic,strong)NSString *selectId;

-(void)first;

@end
