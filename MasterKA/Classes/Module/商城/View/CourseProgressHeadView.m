//
//  CourseProgressHeadView.m
//  MasterKA
//
//  Created by 余伟 on 16/12/21.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "CourseProgressHeadView.h"

@implementation CourseProgressHeadView

+(instancetype)head;
{
    
    CourseProgressHeadView * head = [[[NSBundle mainBundle]loadNibNamed:@"CourseProgressHeadView" owner:nil options:nil]lastObject];
    
    return head;
    
}

@end
