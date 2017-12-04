//
//  TopImageBtn.m
//  MasterKA
//
//  Created by 余伟 on 16/8/5.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "TopImageBtn.h"
#import "UserClient.h"

@implementation TopImageBtn



-(void)layoutSubviews
{
    
    [super layoutSubviews];
  
    CGRect imageRect = self.imageView.frame;
    imageRect.origin.x = self.width/2-imageRect.size.width/2;
    
    CGRect titleRect = self.titleLabel.frame;
    titleRect.origin.x = self.width/2-titleRect.size.width/2;
    
    if (![UserClient sharedUserClient].rawLogin) {
        
        imageRect.origin.y = 5;
       
        titleRect.origin.y = imageRect.size.height+15;
 
    }else{
        
        titleRect.origin.y = 5;
        
        imageRect.origin.y = titleRect.size.height+15;
   
    }
    
    self.imageView.frame = CGRectIntegral(imageRect);
    
    self.titleLabel.frame = CGRectIntegral(titleRect);
    
}





@end
