//
//  DianzanCellectCell.m
//  MasterKA
//
//  Created by lijiachao on 16/10/11.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "DianzanCellectCell.h"
#import "Masonry.h"
@implementation DianzanCellectCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.topImageView = [[UIImageView alloc]init];
        self.topImageView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.topImageView];
    }
    return self;
}

-(void)setDianZanCellData:(NSString*)user_top width:(CGFloat)width height:(CGFloat)height{
    
    
    
}


@end
