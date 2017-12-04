//
//  ShopTopImageBtn.m
//  MasterKA
//
//  Created by 余伟 on 16/9/26.
//  Copyright © 2016年 jinghao. All rights reserved.
//
#define pfurlKey  @"pfurlKey"
#define modelKey @"modelKey"
#define dataKey @"dataKey"


#import "ShopTopImageBtn.h"
#import <objc/runtime.h>

@implementation ShopTopImageBtn


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    CGRect imageRect =  self.imageView.frame;
    
    CGRect labelRect =  self.titleLabel.frame;
    
    imageRect.origin.x = (self.width-imageRect.size.width-12)/2;
    
    imageRect.origin.y = (self.height-imageRect.size.height-labelRect.size.height-12)/2-2;
    
    imageRect.size.width = self.imageView.size.width+12;
    imageRect.size.height = self.imageView.size.height+12;
    
    self.imageView.frame = imageRect;
    
    labelRect.origin.x = 0;
    
    
    labelRect.size.width = self.size.width;
    
    
    labelRect.origin.y = imageRect.size.height+(self.height-imageRect.size.height-labelRect.size.height-12)/2+6;
    
    self.titleLabel.frame = labelRect;
    
}



-(void)setPfurl:(NSString *)pfurl
{
    
 objc_setAssociatedObject(self, pfurlKey, pfurl, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}

-(NSString *)pfurl
{
     return objc_getAssociatedObject(self, pfurlKey);
}

-(void)setModel:(NSString *)model
{
    objc_setAssociatedObject(self, modelKey, model, OBJC_ASSOCIATION_RETAIN);
}

-(NSString *)model
{
    
    return objc_getAssociatedObject(self, modelKey);
}


-(void)setData:(id)data
{
    objc_setAssociatedObject(self, dataKey, data, OBJC_ASSOCIATION_RETAIN);
}


-(id)data
{
    return  objc_getAssociatedObject(self, dataKey);
}


@end
