//
//  CategoryCollectionViewCell.m
//  MasterKA
//
//  Created by 余伟 on 16/12/20.
//  Copyright © 2016年 jinghao. All rights reserved.
//

#import "CategoryCollectionViewCell.h"

@implementation CategoryCollectionViewCell
{
    
    
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self.categoryBtn setImage:[self createImage] forState:UIControlStateNormal];
        self.categoryBtn.userInteractionEnabled = NO;
        [self.categoryBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [categoryBtn addTarget: self action:@selector(catrgory:) forControlEvents:UIControlEventTouchUpInside];
        self.categoryBtn.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.height);
        [self.contentView addSubview:self.categoryBtn];
    }
    
    return self;
}

-(void)setColor:(UIColor *)color
{
    _color = color;
      
//    
//    NSLog(@"%@", [self createImageWithColor:bg]);
//    
//    self.contentView.backgroundColor = bg;
    
    
    
//    
//     [self.categoryBtn setImage:[self createImageWithColor:color] forState:UIControlStateNormal];
    
    
}


-(UIImage *)createImageWithColor:(UIColor *)color;
{
    UIGraphicsBeginImageContext(CGSizeMake(5, 5));
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    UIBezierPath * path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(2.5, 2.5) radius:2.5 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    CGContextAddPath(ref, path.CGPath);
    
    CGContextSetFillColorWithColor(ref, color.CGColor);
    
    CGContextFillPath(ref);
    
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}


-(void)setCategoryName:(NSString *)categoryName
{
    _categoryName = categoryName;
    
    self.categoryBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
    
    [self.categoryBtn setTitle:categoryName forState:UIControlStateNormal];
    self.categoryBtn .titleLabel.font = [UIFont systemFontOfSize:14];
    
//    [self.categoryBtn setTitleColor:self.color forState:UIControlStateNormal];
    
    [self.categoryBtn setImage:[self createImageWithColor:self.color] forState:UIControlStateNormal];
    
    
}

-(void)catrgory:(UIButton *)sender
{
    self.btnClick();
}


@end
