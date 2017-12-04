//
//  UIView+CommentView.m
//  MasterKA
//
//  Created by 余伟 on 16/10/19.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#define modelKey @"model"
#import "UIView+CommentView.h"


@implementation UIView (CommentView)


-(void)setModel:(id)model
{
    
    objc_setAssociatedObject(self, modelKey, model, OBJC_ASSOCIATION_RETAIN);
    
}

-(id)model
{
    
    return  objc_getAssociatedObject(self, modelKey);
    
}



@end
