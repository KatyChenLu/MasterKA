//
//  UserHobyBtn.m
//  MasterKA
//
//  Created by 余伟 on 16/12/8.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "UserHobyBtn.h"

@implementation UserHobyBtn


-(void)setHoby:(id)hoby
{
    objc_setAssociatedObject(self, @selector(hoby), hoby, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

-(id)hoby
{
    return objc_getAssociatedObject(self, _cmd);
}



@end
