//
//  AticleDetailImageCell.m
//  HiMaster3
//
//  Created by 余伟 on 16/10/17.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "AticleDetailImageCell.h"


@interface AticleDetailImageCell ()

@end

@implementation AticleDetailImageCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.detailImage];
        
    }
    
    return self;
    
}


- (FLAnimatedImageView *)detailImage{
    
    if (!_detailImage) {
        
        _detailImage = [[FLAnimatedImageView alloc]init];
    }
    
    return _detailImage;
}


- (void)configueCellWithModel:(NSDictionary * )dic{
    
    NSString * height = dic[@"height"];
    
    NSString * width = dic[@"width"];

    
    CGFloat bottom = [dic[@"bottom"] floatValue]/2;
    
    CGFloat widthNum = [width floatValue];
    
    CGFloat num = [height floatValue]*[UIScreen mainScreen].bounds.size.width*[UIScreen mainScreen].scale/widthNum;
    
    num = num / [UIScreen mainScreen].scale;
    
    [self.detailImage mas_updateConstraints:^(MASConstraintMaker *make) {
   
        make.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
     
        make.height.mas_equalTo(num);
  
        make.bottom.equalTo(self.contentView).offset(-bottom);
 
    }];
    
    NSString *trueWidth = [NSString stringWithFormat:@"%f",ScreenWidth-32];
    [self.detailImage setImageFadeInWithURLString:[dic[@"content"] ClipImageUrl:trueWidth] placeholderImage:nil];
    
}


@end
